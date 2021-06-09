import 'dart:math' as Math;

import 'pref_list.dart';
import 'svg_decoder.dart';
import 'package:flutter/material.dart';

class ChartData {
	final Color color;
	ChartData(this.color);
}

class JpMapChart extends StatelessWidget {
	final JpMapController notifier;
	JpMapChart({required this.notifier});

	@override
	Widget build(BuildContext context) {
		return LayoutBuilder(
				builder: (context, constraints) {
					var size = constraints.biggest;
					return Stack(
							children: [
								CustomPaint(
										painter: _JpPainter(notifier, size)
								)
							]
					);
				}
		);
	}
}

class JpPaintData {
	final Path path;
	final Color? color;
	JpPaintData(this.path, {this.color});
}

class JpMapController extends ChangeNotifier {
	List<JpPaintData> paintData = [];
	List<PrefMapData>? pathList;

	final bool compact;
	final ChartData defaultData;
	JpMapController({
		ChartData? defaultData,
		bool? compact
	}): this.defaultData = defaultData ?? ChartData(Colors.deepOrangeAccent),
		this.compact = compact ?? true;

	void init() async {
		pathList = await SvgDecoder.getJpMap();
		notifyListeners();
	}

	void update(Map<Prefecture,ChartData> dataMap) {
		assert(pathList != null);
		paintData = pathList!.map((e) {
			if(e.pref == Prefecture.Okinawa) {
				return JpPaintData(
					compact ? e.path.shift(Offset(500, -2300)) : e.path,
					color: dataMap[e.pref]?.color ?? defaultData.color
				);
			}
			if(dataMap.containsKey(e.pref)) {
				return JpPaintData(e.path,color: dataMap[e.pref]!.color);
			}
			return JpPaintData(e.path, color: defaultData.color);
		}).toList();
		notifyListeners();
	}

	void setPaintData(List<JpPaintData> newData) {
		paintData = newData;
		notifyListeners();
	}
}

class _JpPainter extends CustomPainter {
	JpMapController repaint;
	Size canvasSize;
	double offset;
	_JpPainter(this.repaint, this.canvasSize, {this.offset = 20}): super(repaint: repaint);
	@override
	void paint(Canvas canvas, Size size) {
		double minX = double.infinity;
		double minY = double.infinity;
		double maxX = 0;
		double maxY = 0;
		var pathList = repaint.paintData;
		for(var path in pathList) {
			var rect = path.path.getBounds();
			minX = Math.min(minX, rect.left);
			minY = Math.min(minY, rect.top);
			maxX = Math.max(maxX, rect.right);
			maxY = Math.max(maxY, rect.bottom);
		}
		var scale = Math.min(
			(canvasSize.width-2*offset)/(maxX-minX),
			(canvasSize.height-2*offset)/(maxY-minY)
		);
		canvas.scale(scale);
		canvas.translate(-minX+offset, -minY+offset);
		canvas.translate(
			0.5 * (canvasSize.width - scale*(maxX-minX)) / scale,
			0.5 * (canvasSize.height - scale*(maxY-minY)) / scale
		);
		for (var path in pathList) {
			var paint = Paint()
				..color = path.color ?? Colors.deepOrangeAccent
				..strokeWidth = 4.0;
			canvas.drawPath(path.path, paint);
			if (true) {
				var border = Paint()
					..color = Colors.black
					..strokeWidth = 1.0
					..style = PaintingStyle.stroke;
				canvas.drawPath(path.path, border);
			}
		}
	}

	@override
	bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
