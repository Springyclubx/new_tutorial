part of '../../../main.dart';

class _Title extends StatelessWidget {
  const _Title({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(color: Colors.blueAccent, fontSize: 24),
    );
  }
}
