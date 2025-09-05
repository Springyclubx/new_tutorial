import 'package:flutter/material.dart';
import 'package:new_tutorial/tutorial_page/model/target_focus.dart';
import 'package:new_tutorial/tutorial_page/model/target_position.dart';
import 'package:new_tutorial/tutorial_page/paint/curves_clipper_paint.dart';
import 'dart:math';

import 'package:new_tutorial/tutorial_page/model/target_content.dart';
import 'package:new_tutorial/tutorial_page/tutorial_coach_mark.dart';
import 'package:new_tutorial/tutorial_page/util.dart';

part 'tutorial_page/widgets/title/title_text_widget.dart';

part 'tutorial_page/widgets/title/description_widget.dart';

part 'tutorial_page/widgets/title/title_widget.dart';

part 'tutorial_page/widgets/indicator_widget.dart';

part 'tutorial_page/widgets/actions/actions_widget.dart';

part 'tutorial_page/widgets/actions/button_next_widget.dart';

part 'tutorial_page/widgets/actions/button_skip_widget.dart';

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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
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

  final mainListKey = GlobalKey(
    debugLabel: 'sou a lista e tenho valor principal',
  );
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
      final key = GlobalKey(
        debugLabel: 'sou a lista secundária de valor: $index',
      );
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
      list.add(
        GlobalKey(
          debugLabel:
              'sou da lista e tenho valor: principal: $mainNumber. numero: $i',
        ),
      );
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
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
                            final randomColor = Color(
                              (Random().nextDouble() * 0xFFFFFF).toInt(),
                            ).withValues(alpha: 1.0);

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
                },
                child: _ContainerDefault(
                  color: Colors.green.withValues(alpha: 0.6),
                  title: 'sem titulo',
                ),
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
      onFinish: () {},
      onClickTarget: (target) {},
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

  _TitleWidget _createChild({
    required String title,
    required String description,
    String? imageAsset,
    bool inBottom = true,
  }) {
    return _TitleWidget(
      title: title,
      description: description,
      imageAsset: imageAsset,
      inBottom: inBottom,
    );
  }

  List<TargetFocusDefault> _getFirstTutorial() {
    final list = <_TitleWidget>[];

    list.add(
      _createChild(
        title: 'Troca de perfil',
        description: 'Novo layout de gerenciamento do seu perfil.',
        imageAsset: 'lib/assets/first.gif',
      ),
    );
    list.add(
      _createChild(
        title: 'Configurações',
        description:
            'É possível ajustar suas preferências conforme a necessidade.',
      ),
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
  const _ContainerDefault({
    required this.color,
    super.key,
    required this.title,
  });

  final Color color;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Center(
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: Colors.black, fontSize: 32),
          ),
        ),
      ),
    );
  }
}

class _ContentBuilder extends StatefulWidget {
  const _ContentBuilder({
    this.inBottom = true,
    this.sumHeight,
    required this.scrollController,
    required this.child,
    required this.actions,
  });

  final bool inBottom;
  final double? sumHeight;
  final ScrollController scrollController;
  final Widget child;
  final Widget? actions;

  @override
  State<_ContentBuilder> createState() => _ContentBuilderState();
}

class _ContentBuilderState extends State<_ContentBuilder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  late double startPosition;
  late double targetPosition;
  double? targetPositionOld;

  bool isFirstBuild = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(covariant _ContentBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.inBottom != oldWidget.inBottom) {
      requestAnimated(0);
    } else if (oldWidget.sumHeight != widget.sumHeight) {
      requestAnimated(targetPositionOld);
    }
  }

  void requestAnimated(double? begin) {
    _animation = Tween<double>(
      begin: begin,
      end: targetPosition,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    targetPositionOld = targetPosition;

    _controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.sizeOf(context);
    final width = mediaQuery.width;
    final height = (width * 1.482421875).toDouble();

    final padding = (((mediaQuery.height / 2.5))) - (widget.sumHeight ?? 0);

    targetPosition = padding;
    startPosition = height;
    if (isFirstBuild) {
      requestAnimated(startPosition);
      isFirstBuild = false;
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return _getBuilder(width, height, widget.sumHeight ?? 0);
      },
    );
  }

  Widget _getBuilder(double width, double height, double subtractHeight) {
    final mediaQuery = MediaQuery.sizeOf(context);

    if (widget.inBottom) {
      return Positioned(
        top: _animation.value,
        child: AnimatedSize(
          duration: Duration(milliseconds: 300),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              CustomPaint(painter: CurvaClipper(), size: Size(width, height)),
              Padding(
                padding: EdgeInsets.only(top: mediaQuery.height / 2),
                child: _Container(),
              ),
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
            CustomPaint(
              painter: CurvaClipperBottom(),
              size: Size(width, height),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: mediaQuery.height / 2),
              child: _Container(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.sizeOf(context).height / 20,
                ),
                child: widget.actions!,
              ),
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
  return TargetFocusDefault(
    keyTarget: keyTarget,
    shape: ShapeLightFocusDefault.RRect,
    targetPosition: TargetPositionDefault(Size(0, 0), Offset(-10, 0)),
    enableOverlayTab: true,
    unFocusAnimationDuration: Duration(),
    focusAnimationDuration: Duration(),
    contents: [
      TargetContentDefaultModel(
        padding: EdgeInsets.zero,
        customPosition: CustomTargetContentPositionModel(),
        builder: (context, controller) {
          final actionWidget = _Actions(
            itemCount: itemCount,
            index: index,
            controller: controller,
            nextKey: nextKey,
          );
          return Stack(
            children: [
              _ContentBuilder(
                inBottom: inBottom,
                sumHeight: subtractHeight,
                scrollController: scrollController,
                actions: inBottom ? null : actionWidget,
                child: child,
              ),

              if (!inBottom)
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: child,
                ),
              if (inBottom)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: actionWidget,
                ),
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.sizeOf(context).height,
                ),
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

class _Container extends StatelessWidget {
  const _Container();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.sizeOf(context);

    return Container(
      color: Colors.white,
      width: mediaQuery.width,
      height: mediaQuery.height / 5,
    );
  }
}
