import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomSlider(),
        ],
    ),
      ));
  }
}

class CustomSlider extends StatefulWidget {
  @override
  _CustomSliderState createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {

  ui.Image customImage;
  double _sliderValue = 0;

  Future<ui.Image>loadImage(String assetPath) async {
    ByteData data = await rootBundle.load(assetPath);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    ui.FrameInfo fi = await codec.getNextFrame();

    return fi.image;
  }

  @override
  void initState() {
    super.initState();

    loadImage('images/scrubber.png').then((image) {
      customImage = image;
    });
  }


  @override
  Widget build(BuildContext context) {
    final Color positiveColor = Colors.grey[400];
    
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: positiveColor, // Positive Color
        inactiveTrackColor: Colors.orange, // Negative Color
        trackShape: CustomTrackShape(),
        trackHeight: 4.0,
        thumbColor: Colors.redAccent,
        thumbShape: CustomSliderThumbRect(
          thumbRadius: 10.0,
          thumbHeight: 50.0,
          max: 10,
          min: 0,
        ),
        //overlayColor: Colors.yellow, // Don't need
        // overlayShape: RoundSliderOverlayShape(overlayRadius: 18.0),
      ),
      child: Slider(
        value: _sliderValue,
        max: 100.0,
        min: 0.0,
        onChanged: (val) {
          setState(() => _sliderValue = val);
          print(val);
        },
      ),
    );
  }
}

class CustomSliderThumbRect extends SliderComponentShape {
  final double thumbRadius;
  final thumbHeight;
  final int min;
  final int max;

  const CustomSliderThumbRect({
    this.thumbRadius,
    this.thumbHeight,
    this.min,
    this.max,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        Animation<double> activationAnimation,
        Animation<double> enableAnimation,
        bool isDiscrete,
        TextPainter labelPainter,
        RenderBox parentBox,
        SliderThemeData sliderTheme,
        TextDirection textDirection,
        double value,
        double textScaleFactor,
        Size sizeWithOverflow,
    }) 
    {
    final Canvas canvas = context.canvas;

    final rRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: 15, height: 15),
      Radius.circular(5),
    );

    final paint = Paint()
      ..color = sliderTheme.activeTrackColor //Thumb Background Color
      ..style = PaintingStyle.fill;

    canvas.drawRRect(rRect, paint);
    // tp.paint(canvas, textCenter);
  }

  String getValue(double value) {
    return (min+(max-min)*value).round().toString();
  }
}

class CustomTrackShape extends RectangularSliderTrackShape {
  Rect getPreferredRect({
    @required RenderBox parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, 0, trackWidth, trackHeight);
  }
}