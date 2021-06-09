# map_chart_jp

A map chart of Japan.

## Getting Started

You need to prepare data by prefecture and JpMapController.

Write this code in the StatefulWidget.

```dart
Map<Prefecture,ChartData> dataMap = {};
late JpMapController _controller;
```

Initialize and dispose controller.

```dart
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
```

In build function, you can use `JpMapChart` widget.

```dart
JpMapChart(
  notifier: _controller
)
```

# parameters

## JpMapController.compact

- false: Okinawa will be placed in the exact location.
- true: Okinawa will be moved to the upper left and other prefectures will be displayed in a larger size.
