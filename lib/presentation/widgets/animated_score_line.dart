import 'package:flutter/material.dart';

/// スコア数値をアニメーション表示するウィジェット
class AnimatedScoreLine extends StatefulWidget {
  final String label;
  final int score;
  final int maxScore;
  final Duration duration;
  final int delayMillis;

  const AnimatedScoreLine(
    this.label,
    this.score,
    this.maxScore, {
    this.duration = const Duration(milliseconds: 1000),
    this.delayMillis = 0,
  });

  @override
  State<AnimatedScoreLine> createState() => _AnimatedScoreLineState();
}

class _AnimatedScoreLineState extends State<AnimatedScoreLine>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _scoreAnimation;
  late Animation<double> _barAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    // 遅延をシミュレート
    if (widget.delayMillis > 0) {
      Future.delayed(Duration(milliseconds: widget.delayMillis), () {
        if (mounted) {
          _controller.forward();
        }
      });
    } else {
      _controller.forward();
    }

    // スコア数値のアニメーション（0から目標値へ）
    _scoreAnimation = IntTween(begin: 0, end: widget.score).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // プログレスバーのアニメーション
    _barAnimation = Tween<double>(
      begin: 0.0,
      end: (widget.score / widget.maxScore).clamp(0.0, 1.0),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // 透明度のアニメーション（フェードイン）
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: AnimatedBuilder(
          animation: Listenable.merge([_scoreAnimation, _barAnimation]),
          builder: (context, child) {
            return Row(
              children: [
                Expanded(
                  child: Text(
                    widget.label,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                Text(
                  '${_scoreAnimation.value} pt',
                  style: const TextStyle(
                    color: Color(0xFFFFD700),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 80,
                  child: LinearProgressIndicator(
                    value: _barAnimation.value,
                    backgroundColor: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(4),
                    valueColor: AlwaysStoppedAnimation(
                      Color.lerp(
                        const Color(0xFF44AA44),
                        const Color(0xFFFFD700),
                        _barAnimation.value,
                      )!,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
