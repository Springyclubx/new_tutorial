import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../util.dart';

enum ContentAlignType { top, bottom, left, right, custom }

class CustomTargetContentPositionModel {
  CustomTargetContentPositionModel({
    this.top,
    this.left,
    this.right,
    this.bottom,
  });

  final double? top, left, right, bottom;

  @override
  String toString() {
    return 'CustomTargetPosition{top: $top, left: $left, right: $right, bottom: $bottom}';
  }
}

typedef TargetContentBuilder =
    Widget Function(
      BuildContext context,
      TutorialCoachMarkControllerDefault controller,
    );

class TargetContentDefaultModel {
  TargetContentDefaultModel({
    this.align = ContentAlignType.bottom,
    this.padding = const EdgeInsets.all(20.0),
    this.child,
    this.customPosition,
    this.builder,
    this.topDistance,
  }) : assert(!(align == ContentAlignType.custom && customPosition == null));

  final ContentAlignType align;
  final EdgeInsets padding;
  final CustomTargetContentPositionModel? customPosition;
  final Widget? child;
  final TargetContentBuilder? builder;
  final double? topDistance;

  @override
  String toString() {
    return 'ContentTarget{align: $align, child: $child}';
  }
}
