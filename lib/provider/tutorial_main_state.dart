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
                  CustomPaint(
                    foregroundPainter: _CurvaClipper(),
                    size: Size(mediaQuery.width, mediaQuery.height),
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

//Copy this CustomPainter code to the Bottom of the File
class _CurvaClipper extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * -0.0005002383, 0);
    path_0.cubicTo(
      size.width * -0.0005002383,
      0,
      size.width * -0.06007850,
      size.height * 0.1131537,
      size.width * 0.4995000,
      size.height * 0.05064647,
    );
    path_0.cubicTo(
      size.width * 1.059077,
      size.height * -0.01186064,
      size.width * 0.9995000,
      size.height * 0.2586138,
      size.width * 0.9995000,
      size.height * 0.2586138,
    );
    path_0.lineTo(size.width * 0.9995000, size.height);
    path_0.lineTo(size.width * -0.0005002383, size.height);
    path_0.lineTo(size.width * -0.0005002383, 0);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
