import 'package:flutter/material.dart';
import 'dart:math';

import 'package:new_tutorial/tutorial_page/target/target_content_default.dart';
import 'package:new_tutorial/tutorial_page/target/target_focus_default.dart';
import 'package:new_tutorial/tutorial_page/target/target_position_default.dart';
import 'package:new_tutorial/tutorial_page/tutorial_coach_mark_default.dart';
import 'package:new_tutorial/tutorial_page/util.dart';

typedef EduChildBuilder = Widget Function(BuildContext context);
typedef EduChildChildBuilder = Widget Function(BuildContext context);

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
  final count = 3;

  final mainListKey = GlobalKey(debugLabel: 'sou a lista e tenho valor principal');
  final mainList = <GlobalKey?>[];
  final listLists = <GlobalKey?>[];
  final list = <List<GlobalKey?>>[];
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < count; i++) {
      list.add(getList(i));
    }

    mainList.add(null);
    mainList.add(mainListKey);

    for (final (index, item) in list.indexed) {
      final key = GlobalKey(debugLabel: 'sou a lista secundária de valor: $index');
      listLists.add(key);
      mainList.add(key);
      for (int i = 0; i < item.length; i++) {
        mainList.add(item[i]);
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        createTutorial();
      }
    });
  }

  List<GlobalKey?> getList(int mainNumber) {
    final list = <GlobalKey?>[];

    for (int i = 0; i < count; i++) {
      list.add(GlobalKey(debugLabel: 'sou da lista e tenho valor: principal: $mainNumber. numero: $i'));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text(widget.title)),
      body: Center(
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8,
            children: <Widget>[
              ListView.builder(
                key: mainListKey,
                shrinkWrap: true,
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final secondList = list[index];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    key: listLists[index],
                    children: [
                      Text('Lista de numero: $index'),
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: secondList.length,
                          itemBuilder: (context, i) {
                            final randomColor = Color((Random().nextDouble() * 0xFFFFFF).toInt()).withValues(alpha: 1.0);

                            return _ContainerDefault(
                              color: randomColor,
                              key: secondList[i],
                              title: '${index * 10 + (i + 1)}',
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
              InkWell(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                onTap: () async {
                  _tutorialCoachMark.show(context: context);
                  print('guias');
                },
                child: _ContainerDefault(color: Colors.green.withValues(alpha: 0.6), title: 'sem titulo'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void createTutorial() {
    _tutorialCoachMark = TutorialCoachMarkDefault(
      targets: _createTargets(),
      colorShadow: ColorDefault.backgroundColor,
      paddingFocus: 10,
      opacityShadow: ColorDefault.backgroundOpacity,
      pulseEnable: false,
      hideSkip: true,
      onFinish: () {
        print("finish");
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
      },
      onClickTargetWithTapPosition: (target, tapDetails) {},
      onClickOverlay: (target) {},
      onSkip: () => true,
    );
  }

  List<TargetFocusDefault> _createTargets() {
    List<TargetFocusDefault> targets = [];

    targets.addAll(_getFirstTutorial());

    return targets;
  }

  _Child _createChild({required String title, required String description, String? imageAsset, bool inBottom = true}) {
    return _Child(title: title, description: description, imageAsset: imageAsset, inBottom: inBottom);
  }

  List<TargetFocusDefault> _getFirstTutorial() {
    final list = <_Child>[];

    list.add(
      _createChild(
        title: 'Troca de perfil',
        description: 'Novo layout de gerenciamento do seu perfil.',
        imageAsset: 'lib/assets/first.gif',
      ),
    );
    list.add(
      _createChild(title: 'Configurações', description: 'É possível ajustar suas preferências conforme a necessidade.'),
    );
    list.add(
      _createChild(
        title: 'Usuários',
        inBottom: false,
        description:
            'É mostrado todos os perfis vinculados ao seu, podendo selecionar o desejado e ver suas informações.',
        imageAsset: 'lib/assets/first.gif',
      ),
    );
    list.add(
      _createChild(
        title: 'Deslogar do aplicativo',
        inBottom: false,
        description:
            'Botão para deslogar do aplicativo fica na parte inferior. Além disso é possível verificar o número da versão.',
        imageAsset: 'lib/assets/first.gif',
      ),
    );

    final listTargets = <TargetFocusDefault>[];
    for (final (index, item) in list.indexed) {
      listTargets.add(
        _getTargetFocusDefault(
          keyTarget: mainList[index],
          scrollController: scrollController,
          inBottom: item.inBottom,
          nextKey: index + 1 < mainList.length ? mainList[index + 1] : null,
          itemCount: list.length,
          index: index,
          child: item,
        ),
      );
    }

    return listTargets;
  }
}

class _ContainerDefault extends StatelessWidget {
  const _ContainerDefault({required this.color, super.key, required this.title});

  final Color color;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Center(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black, fontSize: 32),
          ),
        ),
      ),
    );
  }
}

class _Child extends StatefulWidget {
  const _Child({required this.title, required this.description, this.imageAsset, required this.inBottom});

  final String title;
  final String description;
  final String? imageAsset;
  final bool inBottom;

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
  void didUpdateWidget(covariant _Child oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.inBottom != oldWidget.inBottom) {
      _controller.forward(from: 0.0);
    }
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
          child: Opacity(opacity: 1.0 - _animation.value, child: child),
        );
      },
      child: SizedBox(
        width: mediaQuery.width,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            _Title(text: widget.title),
            _Description(text: widget.description),
            if (widget.imageAsset != null) _Image(imageAsset: widget.imageAsset!),
          ],
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
    return Text(
      text,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.blueAccent, fontSize: 24),
    );
  }
}

class _Description extends StatelessWidget {
  const _Description({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black87),
      textAlign: TextAlign.center,
    );
  }
}

class _Image extends StatelessWidget {
  const _Image({required this.imageAsset});

  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Image.asset(imageAsset, width: mediaQuery.height / 3, fit: BoxFit.contain);
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

class _ContentBuilder extends StatefulWidget {
  const _ContentBuilder({
    this.inBottom = true,
    this.subtractHeight,
    required this.scrollController,
    required this.child,
    required this.actions,
  });

  final bool inBottom;
  final double? subtractHeight;
  final ScrollController scrollController;
  final Widget child;
  final Widget? actions;

  @override
  State<_ContentBuilder> createState() => _ContentBuilderState();
}

class _ContentBuilderState extends State<_ContentBuilder> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  late double startPosition;
  late double targetPosition;
  double? targetPositionOld;

  bool isFirstBuild = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));

    _controller.value = 1.0;

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant _ContentBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.inBottom != oldWidget.inBottom || oldWidget.subtractHeight != widget.subtractHeight) {
      _animation = Tween<double>(
        begin: targetPositionOld,
        end: targetPosition,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

      targetPositionOld = targetPosition;

      _controller.forward(from: 0.0);
    }
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

    final padding = (((mediaQuery.height / 2.5))) + (widget.subtractHeight ?? 0);

    targetPosition = padding;
    startPosition = height;
    if (isFirstBuild) {
      _animation = Tween<double>(
        begin: startPosition,
        end: targetPosition,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
      isFirstBuild = false;
      targetPositionOld = targetPosition;
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return _getBuilder(width, height, widget.subtractHeight ?? 0);
      },
    );
  }

  Widget _getBuilder(double width, double height, double subtractHeight) {
    if (widget.inBottom) {
      return Positioned(
        top: _animation.value,
        child: AnimatedSize(
          duration: Duration(milliseconds: 300),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              CustomPaint(painter: _CurvaClipper(), size: Size(width, height)),
              Padding(padding: EdgeInsets.only(top: 64), child: widget.child),
            ],
          ),
        ),
      );
    }

    return Positioned(
      bottom: _animation.value,
      child: AnimatedSize(
        duration: Duration(milliseconds: 300),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CustomPaint(painter: _CurvaClipperBottom(), size: Size(width, height)),

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(padding: const EdgeInsets.only(bottom: 32.0), child: widget.actions!),
            ),
          ],
        ),
      ),
    );
  }
}

TargetFocusDefault _getTargetFocusDefault({
  required GlobalKey? keyTarget,
  required ScrollController scrollController,
  required bool inBottom,
  double? subtractHeight,
  required Widget child,
  required GlobalKey? nextKey,
  required int itemCount,
  required int index,
}) {
  Widget actions(TutorialCoachMarkControllerDefault controller) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (itemCount > 1) IndicadorPaginacaoWidget(itemCount: itemCount, index: index),
        _ButtonNext(
          onPressed: () async => nextFocus(controller: controller, nextKey: nextKey),
        ),
        _ButtonSkip(),
      ],
    );
  }

  return TargetFocusDefault(
    keyTarget: keyTarget,
    shape: ShapeLightFocusDefault.RRect,
    targetPosition: TargetPositionDefault(Size(0, 0), Offset(-10, 0)),
    enableOverlayTab: true,
    unFocusAnimationDuration: Duration(),
    focusAnimationDuration: Duration(),
    contents: [
      TargetContentDefault(
        padding: EdgeInsets.zero,
        customPosition: CustomTargetContentPosition(),
        builder: (context, controller) {
          return Stack(
            children: [
              _ContentBuilder(
                inBottom: inBottom,
                subtractHeight: subtractHeight,
                scrollController: scrollController,
                actions: inBottom ? null : actions(controller),
                child: child,
              ),
              if (!inBottom) Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: child,
              ),
              if (inBottom) actions(controller),
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.sizeOf(context).height),
                child: Container(
                  color: Colors.white,
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height / 2,
                ),
              ),
            ],
          );
        },
      ),
    ],
  );
}

Future<void> nextFocus({required GlobalKey? nextKey, required TutorialCoachMarkControllerDefault controller}) async {
  final key = nextKey;

  if (key != null) {
    final keyContext = key.currentContext;

    if (keyContext != null) {
      Scrollable.ensureVisible(
        keyContext,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.0,
      );
    }
  }

  await Future.delayed(Duration(milliseconds: 300));
  controller.next();
}

class IndicadorPaginacaoWidget extends StatelessWidget {
  const IndicadorPaginacaoWidget({super.key, required this.itemCount, required this.index});

  final int itemCount;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: List.generate(itemCount, (i) {
          return _DotWidget(isSelected: index == i);
        }),
      ),
    );
  }
}

class _DotWidget extends StatefulWidget {
  const _DotWidget({required this.isSelected});

  final bool isSelected;

  @override
  State<_DotWidget> createState() => _DotWidgetState();
}

class _DotWidgetState extends State<_DotWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));

    _setupAnimations();
    _controller.forward();
  }

  void _setupAnimations() {
    final selectedColor = Colors.blue;
    final startColor = Colors.blue.withValues(alpha: 0.6);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.isSelected ? 1.2 : 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _colorAnimation = ColorTween(
      begin: startColor,
      end: widget.isSelected ? selectedColor : startColor,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void didUpdateWidget(covariant _DotWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isSelected != widget.isSelected) {
      _controller.reset();
      _setupAnimations();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: _colorAnimation.value),
          ),
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
      ..color = Colors.black.withValues(alpha: 0.3)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8); // blur de sombra

    final shadowPath = path_0.shift(const Offset(0, -4));

    canvas.drawPath(shadowPath, shadowPaint);

    final paint0Fill = Paint()..style = PaintingStyle.fill;

    paint0Fill.color = Colors.white;
    canvas.drawPath(path_0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class _CurvaClipperBottom extends CustomPainter {
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

    // === APLICAR TRANSFORMAÇÃO: Flip Vertical + Mover para base da tela ===
    final Matrix4 transform = Matrix4.identity()
      ..translate(0.0, size.height)
      ..scale(1.0, -1.0); // espelhamento vertical

    final transformedPath = path_0.transform(transform.storage);

    // === SOMBRA ===
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.6)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8);

    final shadowPath = transformedPath.shift(const Offset(0, -4));
    canvas.drawPath(shadowPath, shadowPaint);

    // === PREENCHIMENTO ===
    final paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = Colors.white;
    canvas.drawPath(transformedPath, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
