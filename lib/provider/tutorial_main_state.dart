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
      colorShadow: Colors.red,
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.5,
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
            align: ContentAlignDefault.top,
            builder: (context, controller) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Titulo lorem ipsum",
                    style: TextStyle(color: Colors.white),
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
