import 'package:flutter/material.dart';
import 'package:ronip/l10n/app_localizations.dart';
import 'package:ronip/pages/home/widgets/home_section_widget.dart';
import 'package:ronip/ui/theme.dart';
import 'package:ronip/ui/widgets/logo_widget.dart';

class HomeSection extends StatefulWidget {
  final ScrollController scrollController;

  const HomeSection({super.key, required this.scrollController});

  @override
  State<HomeSection> createState() => _HomeSectionState();
}

class _HomeSectionState extends State<HomeSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // How far the user has scrolled past this section, as a 0..1 fraction of
  // its own height - kept in step with RpLogoScrollTransitionWidget's own
  // progress so the hero logo fades out exactly as the background watermark
  // logo grows in.
  double _scrollProgress = 0.0;

  @override
  void initState() {
    super.initState();
    final reduceMotion = WidgetsBinding
        .instance.platformDispatcher.accessibilityFeatures.disableAnimations;
    _controller = AnimationController(
      vsync: this,
      duration:
          reduceMotion ? Duration.zero : const Duration(milliseconds: 900),
    )..forward();
    widget.scrollController.addListener(_updateScrollProgress);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_updateScrollProgress);
    _controller.dispose();
    super.dispose();
  }

  void _updateScrollProgress() {
    if (!widget.scrollController.hasClients) return;
    final extent = context.size?.height ?? 0.0;
    final progress = extent <= 0
        ? 0.0
        : (widget.scrollController.offset / extent).clamp(0.0, 1.0);
    if (progress != _scrollProgress) {
      setState(() => _scrollProgress = progress);
    }
  }

  Animation<double> _stage(double begin, double end) => CurvedAnimation(
        parent: _controller,
        curve: Interval(begin, end, curve: Curves.easeOutCubic),
      );

  @override
  Widget build(BuildContext context) {
    final logoStage = _stage(0.0, 0.5);
    final introStage = _stage(0.2, 0.7);
    final nameStage = _stage(0.35, 0.85);
    final roleStage = _stage(0.55, 1.0);

    return HomeSectionWidget(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _RiseIn(animation: logoStage, child: const RpLogoWidget()),
          RpTheme.spacerLarge,
          _RiseIn(
            animation: introStage,
            child: Text(
              AppLocalizations.of(context)!.wellcome.toUpperCase(),
              semanticsLabel: AppLocalizations.of(context)!.wellcome,
              textAlign: TextAlign.center,
              style: RpTheme.labelStyle,
            ),
          ),
          RpTheme.spacerSmall,
          _RiseIn(
            animation: nameStage,
            child: const SelectableText(
              'Roni Paschoal',
              semanticsLabel: 'Roni Paschoal',
              style: TextStyle(
                fontFamily: RpTheme.fontFamilyDisplay,
                fontSize: RpTheme.fontSizeLarge,
                color: RpTheme.textHighlightColor,
              ),
            ),
          ),
          RpTheme.spacerSmallX,
          _RiseIn(
            animation: roleStage,
            child: Column(
              children: [
                SelectableText(
                  AppLocalizations.of(context)!.flutterSpecialist,
                  semanticsLabel:
                      AppLocalizations.of(context)!.flutterSpecialist,
                  style: const TextStyle(fontSize: RpTheme.fontSizeMedium),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RiseIn extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const _RiseIn({required this.animation, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => Opacity(
        opacity: animation.value.clamp(0.0, 1.0),
        child: Transform.translate(
          offset: Offset(0, (1 - animation.value) * 14.0),
          child: child,
        ),
      ),
      child: child,
    );
  }
}
