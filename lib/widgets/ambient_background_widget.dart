import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:ronip/core/theme.dart';

/// Paints the `shaders/ambient.frag` background behind [child]: a drifting
/// brand glow, a scroll-parallaxed dot grid that brightens around the
/// cursor, and film grain.
///
/// The cursor is tracked by a non-blocking [MouseRegion] around [child], so
/// content keeps receiving its own hover/tap events. Under reduced motion
/// the ticker never starts and the background renders as a still frame
/// (no drift, no spotlight). Until the shader has loaded — or if it fails
/// to — nothing is painted and the scaffold background shows through.
class RpAmbientBackgroundWidget extends StatefulWidget {
  final ScrollController scrollController;
  final Widget child;

  const RpAmbientBackgroundWidget({
    super.key,
    required this.scrollController,
    required this.child,
  });

  static Future<ui.FragmentProgram?>? _program;

  static Future<ui.FragmentProgram?> _loadProgram() =>
      _program ??= ui.FragmentProgram.fromAsset('shaders/ambient.frag')
          .then<ui.FragmentProgram?>((program) => program)
          .catchError((Object _) => null);

  @override
  State<RpAmbientBackgroundWidget> createState() =>
      _RpAmbientBackgroundWidgetState();
}

class _RpAmbientBackgroundWidgetState extends State<RpAmbientBackgroundWidget>
    with SingleTickerProviderStateMixin {
  final _frame = _AmbientFrame();
  ui.FragmentShader? _shader;
  Ticker? _ticker;
  Offset? _mouseTarget;
  bool _reduceMotion = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
    RpAmbientBackgroundWidget._loadProgram().then((program) {
      if (!mounted || program == null) return;
      setState(() => _shader = program.fragmentShader());
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (_reduceMotion) {
      _ticker?.stop();
    } else {
      _ticker ??= createTicker(_onTick);
      if (!_ticker!.isActive) _ticker!.start();
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    _ticker?.dispose();
    _shader?.dispose();
    _frame.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!widget.scrollController.hasClients) return;
    _frame.scroll = widget.scrollController.offset;
    _frame.notify();
  }

  void _onTick(Duration elapsed) {
    _frame.time = elapsed.inMicroseconds / Duration.microsecondsPerSecond;

    // Ease the spotlight toward the cursor (and fade it in/out) instead of
    // snapping, so it feels like light rather than a pointer.
    final target = _mouseTarget;
    if (target != null) {
      _frame.mouse = Offset.lerp(_frame.mouse ?? target, target, 0.12);
    }
    final targetStrength = target == null ? 0.0 : 1.0;
    _frame.mouseStrength += (targetStrength - _frame.mouseStrength) * 0.08;
    _frame.notify();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.rpColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      opaque: false,
      onHover:
          _reduceMotion ? null : (event) => _mouseTarget = event.localPosition,
      onExit: (_) => _mouseTarget = null,
      child: Stack(
        children: [
          if (_shader != null)
            Positioned.fill(
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: _AmbientPainter(
                    shader: _shader!,
                    frame: _frame,
                    background: colors.backgroundColor,
                    grid: colors.gridColor,
                    brand: RpTheme.brandColor.withValues(
                      alpha: isDark ? 0.22 : 0.10,
                    ),
                  ),
                ),
              ),
            ),
          widget.child,
        ],
      ),
    );
  }
}

/// The per-frame inputs, doubling as the painter's repaint signal so a
/// tick only repaints the background layer, never rebuilds widgets.
class _AmbientFrame extends ChangeNotifier {
  double time = 0.0;
  double scroll = 0.0;
  Offset? mouse;
  double mouseStrength = 0.0;

  void notify() => notifyListeners();
}

class _AmbientPainter extends CustomPainter {
  final ui.FragmentShader shader;
  final _AmbientFrame frame;
  final Color background;
  final Color grid;
  final Color brand;

  _AmbientPainter({
    required this.shader,
    required this.frame,
    required this.background,
    required this.grid,
    required this.brand,
  }) : super(repaint: frame);

  @override
  void paint(Canvas canvas, Size size) {
    final mouse = frame.mouse ?? const Offset(-9999, -9999);
    var i = 0;
    void setColor(Color c) {
      shader
        ..setFloat(i++, c.r)
        ..setFloat(i++, c.g)
        ..setFloat(i++, c.b)
        ..setFloat(i++, c.a);
    }

    shader
      ..setFloat(i++, size.width)
      ..setFloat(i++, size.height)
      ..setFloat(i++, frame.time)
      ..setFloat(i++, mouse.dx)
      ..setFloat(i++, mouse.dy)
      ..setFloat(i++, frame.mouseStrength)
      ..setFloat(i++, frame.scroll);
    setColor(background);
    setColor(grid);
    setColor(brand);

    canvas.drawRect(Offset.zero & size, Paint()..shader = shader);
  }

  @override
  bool shouldRepaint(_AmbientPainter oldDelegate) =>
      oldDelegate.shader != shader ||
      oldDelegate.background != background ||
      oldDelegate.grid != grid ||
      oldDelegate.brand != brand;
}
