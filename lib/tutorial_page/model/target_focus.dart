import 'package:flutter/widgets.dart';
import 'package:new_tutorial/tutorial_page/model/target_content.dart';
import 'package:new_tutorial/tutorial_page/model/target_position.dart';
import 'package:new_tutorial/tutorial_page/util.dart';

class TargetFocusDefault {
  TargetFocusDefault({
    this.identify,
    this.keyTarget,
    this.targetPosition,
    this.contents,
    this.shape,
    this.radius,
    this.borderSide,
    this.color,
    this.enableOverlayTab = false,
    this.enableTargetTab = true,
    this.alignSkip,
    this.paddingFocus,
    this.focusAnimationDuration,
    this.unFocusAnimationDuration,
    this.pulseVariation,
  });

  final dynamic identify;
  final GlobalKey? keyTarget;
  final TargetPositionDefault? targetPosition;
  final List<TargetContentDefaultModel>? contents;
  final ShapeLightFocusDefault? shape;
  final double? radius;
  final BorderSide? borderSide;
  final bool enableOverlayTab;
  final bool enableTargetTab;
  final Color? color;
  final AlignmentGeometry? alignSkip;
  final double? paddingFocus;
  final Duration? focusAnimationDuration;
  final Duration? unFocusAnimationDuration;
  final Tween<double>? pulseVariation;

  @override
  String toString() {
    return 'TargetFocus{identify: $identify, keyTarget: $keyTarget, targetPosition: $targetPosition, contents: $contents, shape: $shape}';
  }
}
