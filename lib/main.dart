import 'package:flutter/material.dart';
import 'package:new_tutorial/provider/tutorial_main_state.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TutorialMainState(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<TutorialMainState>(context);
    final mediaQuery = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8,
            children: <Widget>[
              _ContainerDefault(color: Colors.red, key: state.redKey),
              _ContainerDefault(color: Colors.blue, key: state.blueKey),
              CustomPaint(
                foregroundPainter: _CurvaClipper(),
                size: Size(mediaQuery.width, mediaQuery.height),
              ),
              InkWell(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                key: state.greenKey,
                onTap: () {
                  state.tutorialCoachMark.show(context: context);
                },
                child: _ContainerDefault(
                  color: Colors.green.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContainerDefault extends StatelessWidget {
  const _ContainerDefault({required this.color, super.key});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    );
  }
}

class _CurvaClipper extends CustomPainter {
  _CurvaClipper();

  @override
  void paint(Canvas canvas, Size size) {
    // valores originais do SVG/base
    final baseWidth = size.height;
    final baseHeight = size.width;

    Path path = Path();
    path.moveTo(
      (-0.5 / baseWidth) * size.width,
      (9.5 / baseHeight) * size.height,
    );
    path.cubicTo(
      (3.37324 / baseWidth) * size.width,
      (17.2021 / baseHeight) * size.height,
      (9.37324 / baseWidth) * size.width,
      (22.7021 / baseHeight) * size.height,
      (17.5 / baseWidth) * size.width,
      (26 / baseHeight) * size.height,
    );
    path.cubicTo(
      (30.0627 / baseWidth) * size.width,
      (30.7056 / baseHeight) * size.height,
      (43.0627 / baseWidth) * size.width,
      (33.3723 / baseHeight) * size.height,
      (56.5 / baseWidth) * size.width,
      (34 / baseHeight) * size.height,
    );
    path.cubicTo(
      (74.8539 / baseWidth) * size.width,
      (34.7719 / baseHeight) * size.height,
      (93.1872 / baseWidth) * size.width,
      (34.4385 / baseHeight) * size.height,
      (111.5 / baseWidth) * size.width,
      (33 / baseHeight) * size.height,
    );
    path.cubicTo(
      (143.556 / baseWidth) * size.width,
      (29.4351 / baseHeight) * size.height,
      (175.556 / baseWidth) * size.width,
      (25.4351 / baseHeight) * size.height,
      (207.5 / baseWidth) * size.width,
      (21 / baseHeight) * size.height,
    );
    path.cubicTo(
      (236.966 / baseWidth) * size.width,
      (17.9034 / baseHeight) * size.height,
      (265.633 / baseWidth) * size.width,
      (21.2367 / baseHeight) * size.height,
      (293.5 / baseWidth) * size.width,
      (31 / baseHeight) * size.height,
    );
    path.cubicTo(
      (327.816 / baseWidth) * size.width,
      (46.1433 / baseHeight) * size.height,
      (347.149 / baseWidth) * size.width,
      (72.31 / baseHeight) * size.height,
      (351.5 / baseWidth) * size.width,
      (109.5 / baseHeight) * size.height,
    );
    path.cubicTo(
      (351.5 / baseWidth) * size.width,
      (116.833 / baseHeight) * size.height,
      (351.5 / baseWidth) * size.width,
      (124.167 / baseHeight) * size.height,
      (351.5 / baseWidth) * size.width,
      (131.5 / baseHeight) * size.height,
    );
    path.cubicTo(
      (350.5 / baseWidth) * size.width,
      (257.999 / baseHeight) * size.height,
      (350.167 / baseWidth) * size.width,
      (384.666 / baseHeight) * size.height,
      (350.5 / baseWidth) * size.width,
      (511.5 / baseHeight) * size.height,
    );
    path.cubicTo(
      (233.5 / baseWidth) * size.width,
      (511.5 / baseHeight) * size.height,
      (116.5 / baseWidth) * size.width,
      (511.5 / baseHeight) * size.height,
      (-0.5 / baseWidth) * size.width,
      (511.5 / baseHeight) * size.height,
    );
    path.cubicTo(
      (-0.5 / baseWidth) * size.width,
      (344.167 / baseHeight) * size.height,
      (-0.5 / baseWidth) * size.width,
      (176.833 / baseHeight) * size.height,
      (-0.5 / baseWidth) * size.width,
      (9.5 / baseHeight) * size.height,
    );
    path.close();

    Paint paint = Paint()..style = PaintingStyle.fill;
    paint.color = Colors.red;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
