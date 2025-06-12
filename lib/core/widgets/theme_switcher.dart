import 'package:flutter/material.dart';
import 'package:shamil_web/core/constants/app_colors.dart';

class StylizedLoadingIndicator extends StatefulWidget {
  const StylizedLoadingIndicator({super.key});

  @override
  State<StylizedLoadingIndicator> createState() => _StylizedLoadingIndicatorState();
}

class _StylizedLoadingIndicatorState extends State<StylizedLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeTransition(
        opacity: _animation,
        child: Container(
          width: 80,
          height: 10,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            gradient: LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.primaryGold,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ),
    );
  }
}