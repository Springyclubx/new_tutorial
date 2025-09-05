part of '../../main.dart';

class IndicadorWidget extends StatelessWidget {
  const IndicadorWidget({
    super.key,
    required this.itemCount,
    required this.index,
  });

  final int itemCount;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: List.generate(itemCount, (i) {
          return _DotWidget(isSelected: index == i);
        }),
      ),
    );
  }
}

class _DotWidget extends StatefulWidget {
  const _DotWidget({required this.isSelected});

  final bool isSelected;

  @override
  State<_DotWidget> createState() => _DotWidgetState();
}

class _DotWidgetState extends State<_DotWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _setupAnimations();
    _controller.forward();
  }

  void _setupAnimations() {
    final selectedColor = Colors.blue;
    final startColor = Colors.blue.withValues(alpha: 0.6);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.isSelected ? 1.2 : 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _colorAnimation = ColorTween(
      begin: startColor,
      end: widget.isSelected ? selectedColor : startColor,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void didUpdateWidget(covariant _DotWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isSelected != widget.isSelected) {
      _controller.reset();
      _setupAnimations();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _colorAnimation.value,
            ),
          ),
        );
      },
    );
  }
}
