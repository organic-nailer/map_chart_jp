import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:map_chart_jp/map_chart_jp.dart';
import 'wave_color.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'map_chart_jp sample',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
    );
  }
}

const kTabletBreakpoint = 720.0;
const kDesktopBreakpoint = 1220.0;

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  var isDensity = true;

  void setView(bool density) {
    isDensity = density;
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, dimens) => Scaffold(
        drawer: dimens.maxWidth <= kDesktopBreakpoint ? buildDrawer(setView, true) : null,
        appBar: dimens.maxWidth <= kTabletBreakpoint ? buildAppBar() : null,
        body: Row(
          children: <Widget>[
            if (dimens.maxWidth >= kDesktopBreakpoint) buildDrawer(setView, false, 0),
            Expanded(
                child: Column(
                  children: <Widget>[
                    if (dimens.maxWidth >= kTabletBreakpoint) buildAppBar(),
                    Expanded(
                      child: isDensity ? DensityView() : GamingView()
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text(
        'JP MAP CHART',
      ),
    );
  }

  Widget buildDrawer(Function setView, bool closable, [double elevation = 15.0]) {
    return Drawer(
      elevation: elevation,
      child: Ink(
        color: Colors.blueGrey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 56,
              ),
              ListTile(
                title: Text("Density", style: TextStyle(color: Colors.white),),
                onTap: () {
                  setView(true);
                  if(closable) Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text("Gaming", style: TextStyle(color: Colors.white),),
                onTap: () {
                  setView(false);
                  if(closable) Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text("License", style: TextStyle(color: Colors.white),),
                onTap: () {
                  showAboutDialog(context: context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DensityView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DensityViewState();
}

class _DensityViewState extends State<DensityView> with SingleTickerProviderStateMixin {
  Map<Prefecture,ChartData> dataMap = {};

  late JpMapController _controller;

  @override
  void initState() {
    super.initState();
    _controller = JpMapController(
        defaultData: ChartData(Colors.white54),
      compact: false
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.init();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: FutureBuilder<String>(
              future: rootBundle.loadString("assets/density.json"),
              builder: (context, snapshot) {
                if(!snapshot.hasData || snapshot.data == null) return Container();
                List<dynamic> decoded = json.decode(snapshot.data!);
                dataMap.clear();
                List<JpStatisticsValue> statistics = [];
                for(var raw in decoded) {
                  if(raw["id"] == null || raw["density"] == null) continue;
                  statistics.add(JpStatisticsValue(PrefExt.fromPrefCode(raw["id"]), double.parse(raw["density"])));
                }
                var data = JpMapChartData.fromStatistics(statistics);
                _controller.update(data.dataMap);
                return JpMapChart(
                  notifier: _controller,
                );
              }
          ),
        ),
      ],
    );
  }
}


class GamingView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GamingViewState();
}

class _GamingViewState extends State<GamingView> with SingleTickerProviderStateMixin {
  Map<Prefecture,ChartData> dataMap = {};
  late Animation<double> _animation;
  late AnimationController _controller;
  final waveTween = Tween<double>(begin:380,end:700);

  late JpMapController _mapController;

  List<Prefecture> gamingPref = [
    Prefecture.Saitama
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this
    )..repeat(reverse: true);
    _animation = waveTween.animate(_controller)..addListener(() {
      dataMap.clear();
      gamingPref.forEach((p) {
        dataMap[p] = ChartData(Wave2ColorMaterial.fromWave(_animation.value));
      });
      _mapController.update(dataMap);
    });
    _mapController = JpMapController(
        defaultData: ChartData(Colors.blueGrey)
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _mapController.init();
  }

  @override
  void dispose() {
    _controller.dispose();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: JpMapChart(
            notifier: _mapController,
          )
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                checkItem(Prefecture.Saitama),
                checkItem(Prefecture.Gunma)
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget checkItem(Prefecture pref) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      //crossAxisAlignment: CrossAxisAlignment.baseline,
      children: [
        Checkbox(
            value: gamingPref.contains(pref),
            onChanged: (value) {
              if(value == true && !gamingPref.contains(pref)) gamingPref.add(pref);
              else if(gamingPref.contains(pref)) gamingPref.remove(pref);
              setState(() { });
            }
        ),
        Text(
          "${pref.getJpName()}"
        )
      ],
    );
  }
}
