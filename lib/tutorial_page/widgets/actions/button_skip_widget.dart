part of '../../../main.dart';

class _ButtonSkip extends StatelessWidget {
  const _ButtonSkip({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        side: WidgetStatePropertyAll(BorderSide(color: Colors.transparent)),
      ),
      child: Text('Pular tutorial', style: TextStyle(color: Colors.blueAccent)),
    );
  }
}
