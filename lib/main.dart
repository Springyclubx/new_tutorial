import 'package:flutter/material.dart';
import 'package:new_tutorial/tutorial_page/target/target_content_default.dart';
import 'package:new_tutorial/tutorial_page/target/target_focus_default.dart';
import 'package:new_tutorial/tutorial_page/tutorial_coach_mark_default.dart';
import 'package:new_tutorial/tutorial_page/util.dart';

void main() {
  runApp(const MyApp());
}

class ColorDefault {
  static Color backgroundColor = Colors.black;


  static double backgroundOpacity = 0.4;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

late final TutorialCoachMarkDefault _tutorialCoachMark;

class _MyHomePageState extends State<MyHomePage> {
  final _redKey = GlobalKey();
  final _greenKey = GlobalKey();
  final _blueKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    createTutorial();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text(widget.title)),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8,
            children: <Widget>[
              _ContainerDefault(color: Colors.red, key: _redKey),
              _ContainerDefault(color: Colors.blue, key: _blueKey),
              InkWell(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                key: _greenKey,
                onTap: () async {
                  await initialTutorial();
                  print('guias');
                },
                child: _ContainerDefault(color: Colors.green.withValues(alpha: 0.6)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> initialTutorial() async {
    final overlay = Overlay.of(context);
    overlay.let((it) {
      showWithOverlayState(overlay: it);
    });
  }

  Future<void> showWithOverlayState({required OverlayState overlay}) async {
    postFrame(() {
      late final OverlayEntry overlayEntry;
      overlayEntry = _buildOverlay(
        onPressed: () {
          overlayEntry.remove();
        },
      );
      overlay.insert(overlayEntry);
    });
  }

  void createTutorial() {
    _tutorialCoachMark = TutorialCoachMarkDefault(
      targets: _createTargets(),
      colorShadow: ColorDefault.backgroundColor,
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: ColorDefault.backgroundOpacity,
      pulseEnable: false,
      onFinish: () {
        print("finish");
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print("target: $target");
        print("clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
      },
      onSkip: () {
        print("skip");
        return true;
      },
    );
  }

  List<TargetFocusDefault> _createTargets() {
    List<TargetFocusDefault> targets = [];
    targets.add(
      TargetFocusDefault(
        keyTarget: _redKey,
        alignSkip: Alignment.topRight,
        shape: ShapeLightFocusDefault.RRect,
        enableOverlayTab: true,
        contents: [
          TargetContentDefault(
            padding: EdgeInsets.zero,
            builder: (context, controller) {
              return Stack(
                children: [
                  _MainChild(),
                  _Child(
                    onPressed: () {
                      controller.skip();
                  },),
                ],
              );
            },
          ),
        ],
      ),
    );

    return targets;
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
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.all(Radius.circular(8))),
    );
  }
}

OverlayEntry _buildOverlay({required VoidCallback onPressed}) {
  return OverlayEntry(
    builder: (context) {
      return Material(
        color: ColorDefault.backgroundColor.withValues(alpha: ColorDefault.backgroundOpacity),
        child: Stack(
          children: [
            _MainChild(),
            _Child(onPressed: onPressed),
          ],
        ),
      );
    },
  );
}

class _Child extends StatefulWidget {
  const _Child({required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<_Child> createState() => _ChildState();
}

class _ChildState extends State<_Child> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));

    _animation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.sizeOf(context);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0.0, mediaQuery.height * _animation.value * 0.0),
          child: Opacity(
            opacity: 1.0 - _animation.value, // Faz o widget aparecer gradualmente
            child: child,
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: (mediaQuery.height / 4) / 2),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const _Title(text: 'Title'),
              const _Description(text: 'Description'),
              const _Image(),
              _ButtonNext(onPressed: widget.onPressed),
              _ButtonSkip(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.blueAccent, fontSize: 32));
  }
}

class _Description extends StatelessWidget {
  const _Description({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black87));
  }
}

class _Image extends StatelessWidget {
  const _Image();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Image.asset('lib/assets/first.gif', width: mediaQuery.height / 3, fit: BoxFit.contain);
  }
}

class _ButtonNext extends StatelessWidget {
  const _ButtonNext({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        onPressed.call();
        _tutorialCoachMark.show(context: context);
      },
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.blueAccent),
        side: WidgetStatePropertyAll(BorderSide(color: Colors.transparent)),
      ),
      child: Text('Avançar', style: TextStyle(color: Colors.white)),
    );
  }
}

/// Fazer igual o EduBotaoAssinaturaWidget
class _ButtonSkip extends StatelessWidget {
  const _ButtonSkip();

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: ButtonStyle(side: WidgetStatePropertyAll(BorderSide(color: Colors.transparent))),
      child: Text('Pular tutorial', style: TextStyle(color: Colors.blueAccent)),
    );
  }
}

class _MainChild extends StatefulWidget {
  const _MainChild();

  @override
  State<_MainChild> createState() => _MainChildState();
}

class _MainChildState extends State<_MainChild> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  late double targetTop;
  late double startTop;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));

    _animation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final width = mediaQuery.width;
    final height = (width * 1.482421875).toDouble();

    targetTop = mediaQuery.height / 4;
    startTop = mediaQuery.height;

    _animation = Tween<double>(
      begin: startTop,
      end: targetTop,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          top: _animation.value,
          child: CustomPaint(painter: _CurvaClipper(), size: Size(width, height)),
        );
      },
    );
  }
}

//Copy this CustomPainter code to the Bottom of the File
class _CurvaClipper extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path_0 = Path();
    path_0.moveTo(0, 0);
    path_0.cubicTo(
      size.width * 0.005859375,
      size.height * 0.005270092,
      size.width * 0.005859375,
      size.height * 0.005270092,
      size.width * 0.008102417,
      size.height * 0.007961751,
    );
    path_0.cubicTo(
      size.width * 0.02343929,
      size.height * 0.02605047,
      size.width * 0.05513667,
      size.height * 0.03382892,
      size.width * 0.08346462,
      size.height * 0.03910560,
    );
    path_0.cubicTo(
      size.width * 0.2125256,
      size.height * 0.06167050,
      size.width * 0.3589665,
      size.height * 0.04425221,
      size.width * 0.4883003,
      size.height * 0.03075348,
    );
    path_0.cubicTo(
      size.width * 0.5739990,
      size.height * 0.02182523,
      size.width * 0.6617641,
      size.height * 0.01533229,
      size.width * 0.7480469,
      size.height * 0.02503294,
    );
    path_0.cubicTo(
      size.width * 0.7500258,
      size.height * 0.02525203,
      size.width * 0.7520047,
      size.height * 0.02547112,
      size.width * 0.7540436,
      size.height * 0.02569685,
    );
    path_0.cubicTo(
      size.width * 0.8068368,
      size.height * 0.03178258,
      size.width * 0.8605001,
      size.height * 0.04391843,
      size.width * 0.9023438,
      size.height * 0.06719368,
    );
    path_0.cubicTo(
      size.width * 0.9039464,
      size.height * 0.06806176,
      size.width * 0.9039464,
      size.height * 0.06806176,
      size.width * 0.9055815,
      size.height * 0.06894737,
    );
    path_0.cubicTo(
      size.width * 0.9214250,
      size.height * 0.07755223,
      size.width * 0.9351028,
      size.height * 0.08641371,
      size.width * 0.9472656,
      size.height * 0.09749671,
    );
    path_0.cubicTo(
      size.width * 0.9489575,
      size.height * 0.09895900,
      size.width * 0.9489575,
      size.height * 0.09895900,
      size.width * 0.9506836,
      size.height * 0.1004508,
    );
    path_0.cubicTo(
      size.width * 0.9895743,
      size.height * 0.1355518,
      size.width * 1.001273,
      size.height * 0.1762446,
      size.width * 1.000939,
      size.height * 0.2191005,
    );
    path_0.cubicTo(
      size.width * 1.000943,
      size.height * 0.2224003,
      size.width * 1.000950,
      size.height * 0.2257000,
      size.width * 1.000960,
      size.height * 0.2289998,
    );
    path_0.cubicTo(
      size.width * 1.000973,
      size.height * 0.2361280,
      size.width * 1.000963,
      size.height * 0.2432559,
      size.width * 1.000931,
      size.height * 0.2503840,
    );
    path_0.cubicTo(
      size.width * 1.000884,
      size.height * 0.2609830,
      size.width * 1.000882,
      size.height * 0.2715818,
      size.width * 1.000889,
      size.height * 0.2821808,
    );
    path_0.cubicTo(
      size.width * 1.000899,
      size.height * 0.3000168,
      size.width * 1.000873,
      size.height * 0.3178527,
      size.width * 1.000826,
      size.height * 0.3356887,
    );
    path_0.cubicTo(
      size.width * 1.000780,
      size.height * 0.3533328,
      size.width * 1.000750,
      size.height * 0.3709768,
      size.width * 1.000741,
      size.height * 0.3886209,
    );
    path_0.cubicTo(
      size.width * 1.000741,
      size.height * 0.3897205,
      size.width * 1.000740,
      size.height * 0.3908201,
      size.width * 1.000740,
      size.height * 0.3919530,
    );
    path_0.cubicTo(
      size.width * 1.000737,
      size.height * 0.3975380,
      size.width * 1.000735,
      size.height * 0.4031229,
      size.width * 1.000732,
      size.height * 0.4087079,
    );
    path_0.cubicTo(
      size.width * 1.000716,
      size.height * 0.4482024,
      size.width * 1.000663,
      size.height * 0.4876968,
      size.width * 1.000589,
      size.height * 0.5271913,
    );
    path_0.cubicTo(
      size.width * 1.000518,
      size.height * 0.5655448,
      size.width * 1.000462,
      size.height * 0.6038984,
      size.width * 1.000429,
      size.height * 0.6422520,
    );
    path_0.cubicTo(
      size.width * 1.000427,
      size.height * 0.6446663,
      size.width * 1.000425,
      size.height * 0.6470807,
      size.width * 1.000423,
      size.height * 0.6494951,
    );
    path_0.cubicTo(
      size.width * 1.000406,
      size.height * 0.6691150,
      size.width * 1.000390,
      size.height * 0.6887348,
      size.width * 1.000374,
      size.height * 0.7083547,
    );
    path_0.cubicTo(
      size.width * 1.000301,
      size.height * 0.7989822,
      size.width * 1.000144,
      size.height * 0.8896096,
      size.width,
      size.height * 0.9802372,
    );
    path_0.cubicTo(
      size.width * 0.6700000,
      size.height * 0.9802372,
      size.width * 0.3400000,
      size.height * 0.9802372,
      0,
      size.height * 0.9802372,
    );
    path_0.cubicTo(0, size.height * 0.6567589, 0, size.height * 0.3332806, 0, 0);
    path_0.close();

    // === SOMBRA EM CIMA ===
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.6)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8); // blur de sombra

    final shadowPath = path_0.shift(const Offset(0, -4));

    canvas.drawPath(shadowPath, shadowPaint);

    final paint_0_fill = Paint()..style = PaintingStyle.fill;

    paint_0_fill.color = Colors.white;
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
