import 'package:flutter/material.dart';

/// A Facebook-style sliding drawer wrapper.
/// When the drawer opens, the main [child] slides to the right and scales down
/// slightly, revealing the [drawer] underneath — just like the Facebook app.
class SlidingDrawerWrapper extends StatefulWidget {
  final Widget drawer;
  final Widget child;

  /// Width of the drawer as a fraction of the screen width.
  final double drawerWidthFactor;

  const SlidingDrawerWrapper({
    super.key,
    required this.drawer,
    required this.child,
    this.drawerWidthFactor = 0.78,
  });

  @override
  State<SlidingDrawerWrapper> createState() => SlidingDrawerWrapperState();
}

class SlidingDrawerWrapperState extends State<SlidingDrawerWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _shadowAnimation;

  bool get isOpen => _controller.value > 0.5;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _shadowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void open() => _controller.forward();
  void close() => _controller.reverse();
  void toggle() => isOpen ? close() : open();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final drawerWidth = screenWidth * widget.drawerWidthFactor;

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        final delta = details.primaryDelta! / drawerWidth;
        _controller.value = (_controller.value + delta).clamp(0.0, 1.0);
      },
      onHorizontalDragEnd: (details) {
        final velocity = details.primaryVelocity ?? 0;
        if (velocity > 300 || _controller.value > 0.5) {
          open();
        } else if (velocity < -300 || _controller.value <= 0.5) {
          close();
        }
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final slideX = _slideAnimation.value * drawerWidth;

          return Stack(
            children: [
              // ── Drawer (behind) ──
              SizedBox(
                width: drawerWidth,
                height: double.infinity,
                child: widget.drawer,
              ),

              // ── Main content (slides + scales) ──
              Transform.translate(
                offset: Offset(slideX, 0),
                child: Stack(
                  children: [
                    widget.child,

                    // Dark overlay on the content when drawer is open
                    if (_controller.value > 0)
                      Positioned.fill(
                        child: GestureDetector(
                          onTap: close,
                          child: Container(
                            color: Colors.black.withValues(
                              alpha: _shadowAnimation.value * 0.45,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
