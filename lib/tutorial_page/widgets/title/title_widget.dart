part of '../../../main.dart';

class _TitleWidget extends StatefulWidget {
  const _TitleWidget({
    required this.title,
    required this.description,
    this.imageAsset,
    required this.inBottom,
  });

  final String title;
  final String description;
  final String? imageAsset;
  final bool inBottom;

  @override
  State<_TitleWidget> createState() => _TitleWidgetState();
}

class _TitleWidgetState extends State<_TitleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _animation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant _TitleWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.inBottom != oldWidget.inBottom) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.sizeOf(context);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0.0, mediaQuery.height * _animation.value * 0.0),
          child: Opacity(opacity: 1.0 - _animation.value, child: child),
        );
      },
      child: SizedBox(
        width: mediaQuery.width,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            _Title(text: widget.title),
            _Description(text: widget.description),
            if (widget.imageAsset != null)
              _Image(imageAsset: widget.imageAsset!),
          ],
        ),
      ),
    );
  }
}

class _Image extends StatelessWidget {
  const _Image({required this.imageAsset});

  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.sizeOf(context);
    return Image.asset(
      imageAsset,
      width: mediaQuery.height / 3,
      fit: BoxFit.fitWidth,
    );
  }
}
