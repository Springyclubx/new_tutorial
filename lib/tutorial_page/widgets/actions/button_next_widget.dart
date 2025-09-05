part of '../../../main.dart';

class _ButtonNext extends StatelessWidget {
  const _ButtonNext({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        onPressed.call();
      },
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.blueAccent),
        side: WidgetStatePropertyAll(BorderSide(color: Colors.transparent)),
      ),
      child: Text('Avançar', style: TextStyle(color: Colors.white)),
    );
  }
}
