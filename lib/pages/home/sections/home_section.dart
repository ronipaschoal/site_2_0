import 'package:flutter/material.dart';
import 'package:ronip/config/navigate.dart';
import 'package:ronip/l10n/app_localizations.dart';
import 'package:ronip/pages/home/widgets/home_section_widget.dart';
import 'package:ronip/ui/theme.dart';
import 'package:ronip/ui/widgets/logo_widget.dart';

class HomeSection extends StatefulWidget {
  const HomeSection({super.key});

  @override
  State<HomeSection> createState() => _HomeSectionState();
}

class _HomeSectionState extends State<HomeSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                RpTheme.spacerLarge,
                OutlinedButton(
                  onPressed: () => RpNavigate.to(context, '/cv'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: RpTheme.textHighlightColor,
                    side: const BorderSide(color: RpTheme.brandColor),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 12.0,
                    ),
                    textStyle: const TextStyle(
                      fontFamily: RpTheme.fontFamilyMono,
                      fontSize: RpTheme.fontSizeLabel,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2.0,
                    ),
                  ),
                  child: const Text('VIEW CV'),
                ),
              ],
            ),
          ),
          RpTheme.spacerLargeX2,
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
