import 'package:flutter/material.dart';

/// A widget that displays a skeleton loading animation.
/// Used to indicate that content is loading.
class SkeletonLoading extends StatelessWidget {
  /// Creates a skeleton loading widget with the given dimensions.
  const SkeletonLoading({
    super.key,
    this.height,
    this.width,
    this.borderRadius = 8.0,
    this.margin,
    this.child,
  });

  /// The height of the skeleton.
  final double? height;

  /// The width of the skeleton.
  final double? width;

  /// The border radius of the skeleton.
  final double borderRadius;

  /// The margin around the skeleton.
  final EdgeInsetsGeometry? margin;

  /// Optional child widget to display inside the skeleton.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.7),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: child,
    );
  }
}

/// A widget that displays a shimmer effect on its child.
class ShimmerEffect extends StatefulWidget {
  /// Creates a shimmer effect widget.
  const ShimmerEffect({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
    this.color,
    this.baseColor,
    this.highlightColor,
  });

  /// The child widget to apply the shimmer effect to.
  final Widget child;

  /// The duration of one shimmer animation cycle.
  final Duration duration;

  /// The color of the shimmer effect. If provided, baseColor and highlightColor are ignored.
  final Color? color;

  /// The base color of the shimmer effect.
  final Color? baseColor;

  /// The highlight color of the shimmer effect.
  final Color? highlightColor;

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();

    _animation = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color baseColor = widget.baseColor ??
        Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.7);
    final Color highlightColor = widget.highlightColor ??
        Theme.of(context).colorScheme.surface.withOpacity(0.9);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.color != null
                  ? [
                      widget.color!.withOpacity(0.5),
                      widget.color!,
                      widget.color!.withOpacity(0.5),
                    ]
                  : [
                      baseColor,
                      highlightColor,
                      baseColor,
                    ],
              stops: const [0.0, 0.5, 1.0],
              transform: GradientRotation(_animation.value),
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// A skeleton card for product items.
class ProductSkeletonCard extends StatelessWidget {
  /// Creates a skeleton card for product items.
  const ProductSkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            SkeletonLoading(
              height: 120,
              width: double.infinity,
              borderRadius: 8,
            ),
            const SizedBox(height: 8),
            // Title placeholder
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SkeletonLoading(
                height: 16,
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 4),
            // Subtitle placeholder
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SkeletonLoading(
                height: 14,
                width: 120,
              ),
            ),
            const SizedBox(height: 8),
            // Price placeholder
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SkeletonLoading(
                height: 20,
                width: 80,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

/// A grid of skeleton product cards.
class ProductSkeletonGrid extends StatelessWidget {
  /// Creates a grid of skeleton product cards.
  const ProductSkeletonGrid({
    super.key,
    this.itemCount = 6,
    this.crossAxisCount = 2,
    this.mainAxisSpacing = 16.0,
    this.crossAxisSpacing = 16.0,
  });

  /// The number of skeleton items to display.
  final int itemCount;

  /// The number of columns in the grid.
  final int crossAxisCount;

  /// The spacing between rows in the grid.
  final double mainAxisSpacing;

  /// The spacing between columns in the grid.
  final double crossAxisSpacing;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: 0.7,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) => const ProductSkeletonCard(),
    );
  }
}
