import 'package:flutter/material.dart';
import 'package:new_tutorial/tutorial_page/target/target_content_default.dart';
import 'package:new_tutorial/tutorial_page/target/target_focus_default.dart';
import 'package:new_tutorial/tutorial_page/tutorial_coach_mark_default.dart';

class TutorialMainState extends ChangeNotifier {
  TutorialMainState() {
    _init();
  }

  late final TutorialCoachMarkDefault _tutorialCoachMark;

  final _redKey = GlobalKey();
  final _greenKey = GlobalKey();
  final _blueKey = GlobalKey();

  GlobalKey get redKey => _redKey;

  GlobalKey get greenKey => _greenKey;

  GlobalKey get blueKey => _blueKey;

  TutorialCoachMarkDefault get tutorialCoachMark => _tutorialCoachMark;

  Future<void> _init() async {
    createTutorial();
  }

  void createTutorial() {
    _tutorialCoachMark = TutorialCoachMarkDefault(
      targets: _createTargets(),
      colorShadow: Colors.black,
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.5,
      pulseEnable: false,
      onFinish: () {
        print("finish");
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print("target: $target");
        print(
          "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}",
        );
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
        enableOverlayTab: true,
        contents: [
          TargetContentDefault(
            align: ContentAlignDefault.bottom,
            topDistance: 100,
            padding: EdgeInsets.zero,
            builder: (context, controller) {
              final mediaQuery = MediaQuery.sizeOf(context);
              return Stack(
                children: [
                  ClipPath(
                    clipper: _CurvaClipper(),
                    child: Container(
                      width: mediaQuery.width,
                      color: Colors.white54,
                      height: mediaQuery.height,
                      alignment: Alignment.topLeft,
                    ),
                  ),

                  Center(
                    child: const Text(
                      "Topo com duas curvas",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
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

class _CurvaClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // começa no canto superior esquerdo
    path.moveTo(0, 0);

    // curva aguda no topo (logo no começo) - MAIS ACENTUADA
    path.quadraticBezierTo(
      size.width * 0.25, 180, // Ponto de controle Y aumentado (mais para baixo)
      size.width * 0.5, 60,   // Ponto final Y ajustado
    );

    // curva suave até o canto direito - MAIS ACENTUADA
    path.quadraticBezierTo(
      size.width * 0.75, -60,  // Ponto de controle Y diminuído (mais para cima)
      size.width, 100,         // Ponto final Y aumentado (desce mais)
    );

    // fecha o restante até embaixo
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
