part of '../../../main.dart';

class _Actions extends StatelessWidget {
  const _Actions({
    required this.itemCount,
    required this.index,
    required this.controller,
    required this.nextKey,
  });

  final int itemCount;
  final int index;
  final TutorialCoachMarkControllerDefault controller;
  final GlobalKey? nextKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (itemCount > 1) IndicadorWidget(itemCount: itemCount, index: index),
        _ButtonNext(onPressed: () async => nextFocus()),
        _ButtonSkip(onPressed: () async => skipFocus()),
      ],
    );
  }

  Future<void> nextFocus() async {
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

  void skipFocus() {
    controller.skip();
  }
}
