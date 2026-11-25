import 'dart:math' as math;

import 'package:a11y_kit/a11y_kit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ronip/core/media_query_helper.dart';
import 'package:ronip/core/theme.dart';
import 'package:ronip/l10n/app_localizations.dart';
import 'package:ronip/widgets/flutter_banner_widget.dart';

/// "Page not found": shown by the router's error page for any path it
/// doesn't know (the server also answers those with a real 404). Two cats
/// asleep on the page, and a link back to the home page in the same
/// language.
class NotFoundScreen extends StatelessWidget {
  /// The path that wasn't found, shown as a mono "request line".
  final String path;

  /// Where the back link goes: `/` or `/en`.
  final String homePath;

  const NotFoundScreen({
    super.key,
    required this.path,
    required this.homePath,
  });

  static const String photoAsset = 'assets/images/photos/gatos-404.webp';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.rpColors;
    final isSmallScreen = context.isSmallScreen;
    final mono = RpTheme.labelStyle(colors.textColor)
        .copyWith(fontSize: 11.5, letterSpacing: 1.4);

    return FlutterBannerWidget(
      child: Scaffold(
        backgroundColor: colors.backgroundColor,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 16.0 : 48.0,
                vertical: RpTheme.spacingLarge,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ExcludeSemantics(
                          child: Text(
                            '[404] //',
                            style: mono.copyWith(
                              color: colors.accentTextColor,
                            ),
                          ),
                        ),
                        RpTheme.spacerSmall,
                        A11yCapsText(l10n.notFoundLabel, style: mono),
                      ],
                    ),
                    // Decorative: the label above already says "Error 404".
                    ExcludeSemantics(
                      child: Text(
                        '404',
                        style: TextStyle(
                          fontFamily: RpTheme.fontFamilyDisplay,
                          fontSize: RpTheme.fluid(
                            context,
                            min: 88.0,
                            max: 168.0,
                            factor: 0.14,
                          ),
                          height: 1.2,
                          color: RpTheme.brandColor,
                        ),
                      ),
                    ),
                    // The page's single <h1>.
                    A11yHeading(
                      level: 1,
                      label: l10n.notFoundHeading,
                      child: Text(
                        l10n.notFoundHeading,
                        textAlign: TextAlign.center,
                        style: RpTheme.headingStyle(
                          colors.textHighlightColor,
                          fontSize: RpTheme.fluid(
                            context,
                            min: 26.0,
                            max: 40.0,
                            factor: 0.034,
                          ),
                          weight: 500,
                          height: 1.2,
                        ),
                      ),
                    ),
                    RpTheme.spacerMedium,
                    Text(
                      l10n.notFoundBody,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: RpTheme.fontFamilyBody,
                        fontSize: 17.0,
                        height: 1.5,
                        color: colors.textColor,
                      ),
                    ),
                    RpTheme.spacerLarge,
                    const _CatPhoto(),
                    RpTheme.spacerLarge,
                    _BackLink(homePath: homePath),
                    RpTheme.spacerMedium,
                    // A playful "request line"; the heading already says
                    // what happened, so screen readers skip it.
                    ExcludeSemantics(
                      child: Text(
                        'GET $path → 404',
                        textAlign: TextAlign.center,
                        style: mono.copyWith(letterSpacing: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The photo in a hairline card, with a "z z z" drifting up from the
/// sleeping tabby and a mono caption underneath.
class _CatPhoto extends StatelessWidget {
  const _CatPhoto();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.rpColors;

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: colors.hairlineColor),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(19.0),
            child: AspectRatio(
              aspectRatio: 1200 / 568,
              child: LayoutBuilder(
                builder: (context, constraints) => Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      NotFoundScreen.photoAsset,
                      fit: BoxFit.cover,
                      semanticLabel: l10n.notFoundImageAlt,
                    ),
                    // Rising from the tabby's forehead, above its closed eye.
                    Positioned(
                      left: constraints.maxWidth * 0.39,
                      top: constraints.maxHeight * 0.12,
                      child: const ExcludeSemantics(child: _Zzz()),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        RpTheme.spacerSmall,
        Text(
          '// ${l10n.notFoundCaption}',
          semanticsLabel: l10n.notFoundCaption,
          textAlign: TextAlign.center,
          style: RpTheme.labelStyle(colors.textColor)
              .copyWith(fontSize: 11.5, letterSpacing: 0.6),
        ),
      ],
    );
  }
}

/// Three "z"s rising and fading in a loop; still (and fully shown) when the
/// visitor asks for reduced motion.
class _Zzz extends StatefulWidget {
  const _Zzz();

  @override
  State<_Zzz> createState() => _ZzzState();
}

class _ZzzState extends State<_Zzz> with SingleTickerProviderStateMixin {
  late final _loop = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3000),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Read here, not in initState, so toggling it mid-visit applies.
    context.reduceMotion ? _loop.stop() : _loop.repeat();
  }

  @override
  void dispose() {
    _loop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const count = 3;
    final reduceMotion = context.reduceMotion;

    return SizedBox(
      width: 72.0,
      height: 84.0,
      child: AnimatedBuilder(
        animation: _loop,
        builder: (context, _) => Stack(
          clipBehavior: Clip.none,
          children: [
            for (var i = 0; i < count; i++)
              _z(
                i,
                reduceMotion
                    ? (i + 0.5) / count
                    : (_loop.value + i / count) % 1.0,
              ),
          ],
        ),
      ),
    );
  }

  /// One "z" at [t] (0..1) of its climb: drifts up and right, grows, and
  /// fades in then out.
  Widget _z(int index, double t) {
    return Positioned(
      left: 4.0 + t * 34.0,
      top: 60.0 - t * 60.0,
      child: Opacity(
        opacity: math.sin(t * math.pi).clamp(0.0, 1.0),
        child: Text(
          'z',
          style: TextStyle(
            fontFamily: RpTheme.fontFamilyMono,
            fontWeight: FontWeight.w600,
            fontSize: 16.0 + t * 16.0,
            color: RpTheme.brandColor,
            shadows: const [
              Shadow(color: Color(0x99000000), blurRadius: 4.0),
            ],
          ),
        ),
      ),
    );
  }
}

/// "← Back to home", as a real link (`<a href>` on the web) styled like
/// the hero's status pill; the border turns brand red on hover/focus.
class _BackLink extends StatelessWidget {
  final String homePath;

  const _BackLink({required this.homePath});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.rpColors;
    final duration = context.motionDuration(const Duration(milliseconds: 200));

    return A11yTappable(
      url: homePath,
      semanticsLabel: l10n.notFoundBack,
      borderRadius: BorderRadius.circular(999.0),
      onTap: () => context.go(homePath),
      builder: (context, highlighted) => AnimatedContainer(
        duration: duration,
        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: colors.surfaceColor.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(999.0),
          border: Border.all(
            color: highlighted ? RpTheme.brandColor : colors.hairlineColor,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedPadding(
              duration: duration,
              curve: Curves.easeOutCubic,
              padding: EdgeInsets.only(right: highlighted ? 14.0 : 10.0),
              child: Text(
                '←',
                style: RpTheme.labelStyle(colors.accentTextColor),
              ),
            ),
            Text(
              l10n.notFoundBack.toUpperCase(),
              style: RpTheme.labelStyle(colors.textHighlightColor)
                  .copyWith(letterSpacing: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}
