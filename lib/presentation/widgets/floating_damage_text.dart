import 'package:flutter/material.dart';

class FloatingDamageText extends StatefulWidget {
  final int damage;
  final Offset position;
  final bool isCritical;
  final bool isHealing;
  final Duration duration;

  const FloatingDamageText({
    super.key,
    required this.damage,
    required this.position,
    this.isCritical = false,
    this.isHealing = false,
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  State<FloatingDamageText> createState() => _FloatingDamageTextState();
}

class _FloatingDamageTextState extends State<FloatingDamageText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _offsetAnimation = Tween<Offset>(
      begin: widget.position,
      end: widget.position + const Offset(0, -80),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward().then((_) {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isHealing
        ? Colors.green
        : widget.isCritical
            ? const Color(0xFFFF3333)
            : const Color(0xFFFFAA00);

    return AnimatedBuilder(
      animation: _offsetAnimation,
      builder: (context, child) {
        return Positioned(
          left: _offsetAnimation.value.dx,
          top: _offsetAnimation.value.dy,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Transform.scale(
              scale: 1.0 + (1.0 - _opacityAnimation.value) * 0.2,
              child: Text(
                widget.isHealing
                    ? '+${widget.damage}'
                    : widget.isCritical
                        ? '⚡${widget.damage}⚡'
                        : '${widget.damage}',
                style: TextStyle(
                  color: color,
                  fontSize: widget.isCritical ? 28 : 20,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: color.withValues(alpha: 0.8),
                      blurRadius: 8,
                      offset: Offset.zero,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
