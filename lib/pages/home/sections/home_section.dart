import 'package:flutter/material.dart';
import 'package:ronip/core/media_query_helper.dart';
import 'package:ronip/core/profile.dart';
import 'package:ronip/l10n/app_localizations.dart';
import 'package:ronip/core/theme.dart';
import 'package:ronip/widgets/command_palette_widget.dart';
import 'package:ronip/widgets/logo_widget.dart';

class HomeSection extends StatefulWidget {
  final VoidCallback onOpenCommandPalette;

  const HomeSection({super.key, required this.onOpenCommandPalette});

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
          reduceMotion ? Duration.zero : const Duration(milliseconds: 1200),
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
    final l10n = AppLocalizations.of(context)!;
    final colors = context.rpColors;
    final isSmallScreen = context.isSmallScreen;
    final viewport = MediaQuery.sizeOf(context);

    return Container(
      height: viewport.height,
      padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 16.0 : 48.0),
      child: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _RiseIn(
                      animation: _stage(0.0, 0.4),
                      child: const _StatusPill(),
                    ),
                    RpTheme.spacerLarge,
                    _RiseIn(
                      animation: _stage(0.05, 0.5),
                      child: const RpLogoWidget(),
                    ),
                    RpTheme.spacerLarge,
                    _RiseIn(
                      animation: _stage(0.2, 0.6),
                      child: Text(
                        l10n.wellcome.toUpperCase(),
                        semanticsLabel: l10n.wellcome,
                        textAlign: TextAlign.center,
                        style: RpTheme.labelStyle(colors.textColor),
                      ),
                    ),
                    _RiseIn(
                      animation: _stage(0.3, 0.75),
                      // The page's single <h1>.
                      child: Semantics(
                        headingLevel: 1,
                        label: 'Roni Paschoal',
                        excludeSemantics: true,
                        child: SelectableText(
                          'Roni Paschoal',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: RpTheme.fontFamilyDisplay,
                            fontSize: RpTheme.fluid(
                              context,
                              min: 52.0,
                              max: 104.0,
                              factor: 0.085,
                            ),
                            height: 1.25,
                            color: colors.textHighlightColor,
                          ),
                        ),
                      ),
                    ),
                    RpTheme.spacerSmall,
                    _RiseIn(
                      animation: _stage(0.45, 0.9),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 720.0),
                        child: SelectableText(
                          l10n.heroHeadline,
                          semanticsLabel: l10n.heroHeadline,
                          textAlign: TextAlign.center,
                          style: RpTheme.headingStyle(
                            colors.textColor,
                            fontSize: RpTheme.fluid(
                              context,
                              min: 20.0,
                              max: 32.0,
                              factor: 0.026,
                            ),
                            weight: 400,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ),
                    RpTheme.spacerLarge,
                    _RiseIn(
                      animation: _stage(0.6, 1.0),
                      child: _MetaRow(
                        onOpenCommandPalette: widget.onOpenCommandPalette,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Only where there's room below the content, so it never collides
            // with the meta line on short viewports.
            if (viewport.height >= (isSmallScreen ? 700.0 : 820.0))
              Align(
                alignment: Alignment.bottomCenter,
                child: _RiseIn(
                  animation: _stage(0.7, 1.0),
                  child: const ExcludeSemantics(child: _ScrollCue()),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// "● Open to Flutter opportunities" with a softly pulsing dot.
class _StatusPill extends StatefulWidget {
  const _StatusPill();

  @override
  State<_StatusPill> createState() => _StatusPillState();
}

class _StatusPillState extends State<_StatusPill>
    with SingleTickerProviderStateMixin {
  late final _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    reduceMotion ? _pulse.stop() : _pulse.repeat();
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.rpColors;
    const dotColor =
        RpProfile.openToWork ? RpTheme.statusColor : RpTheme.brandColor;
    final text =
        RpProfile.openToWork ? l10n.statusOpenToWork : l10n.statusWorking;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 7.0),
      decoration: BoxDecoration(
        color: colors.surfaceColor.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(999.0),
        border: Border.all(color: colors.hairlineColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox.square(
            dimension: 14.0,
            child: AnimatedBuilder(
              animation: _pulse,
              builder: (context, _) => Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 6.0 + 8.0 * _pulse.value,
                    height: 6.0 + 8.0 * _pulse.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: dotColor.withValues(
                        alpha: 0.45 * (1 - _pulse.value),
                      ),
                    ),
                  ),
                  Container(
                    width: 6.0,
                    height: 6.0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: dotColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          RpTheme.spacerSmall,
          // Flexible: on narrow phones (or with a larger system font) the
          // label wraps instead of overflowing the pill.
          Flexible(
            child: Text(
              text.toUpperCase(),
              semanticsLabel: text,
              textAlign: TextAlign.center,
              style: RpTheme.labelStyle(colors.textHighlightColor)
                  .copyWith(fontSize: 11.0, letterSpacing: 1.6),
            ),
          ),
        ],
      ),
    );
  }
}

/// Mono metadata line: career figures and — on devices with a keyboard —
/// the command palette shortcut.
class _MetaRow extends StatelessWidget {
  final VoidCallback onOpenCommandPalette;

  const _MetaRow({required this.onOpenCommandPalette});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.rpColors;
    final style = RpTheme.labelStyle(colors.textColor)
        .copyWith(fontSize: 11.5, letterSpacing: 1.4);
    final separator = ExcludeSemantics(
      child: Text('/', style: style.copyWith(color: RpTheme.brandColor)),
    );
    final experience = l10n.yearsOfExperience(RpProfile.yearsOfExperience);
    final hybrid = '${RpProfile.yearsHybridMobile} ${l10n.factHybridMobile}';

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 12.0,
      runSpacing: 8.0,
      children: [
        Text(
          experience.toUpperCase(),
          semanticsLabel: experience,
          style: style,
        ),
        separator,
        Text(
          hybrid.toUpperCase(),
          semanticsLabel: hybrid,
          style: style,
        ),
        if (!context.isSmallScreen) ...[
          separator,
          Semantics(
            button: true,
            label: '${l10n.commandPaletteTooltip} '
                '(${RpCommandPaletteWidget.shortcutLabel})',
            excludeSemantics: true,
            child: InkWell(
              onTap: onOpenCommandPalette,
              borderRadius: BorderRadius.circular(6.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: RpCommandPaletteWidget.shortcutLabel,
                        style: style.copyWith(color: colors.textHighlightColor),
                      ),
                      TextSpan(text: ' ${l10n.commandHint.toUpperCase()}'),
                    ],
                  ),
                  style: style,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// "SCROLL" label over a thin track with a brand segment sliding down it.
class _ScrollCue extends StatefulWidget {
  const _ScrollCue();

  @override
  State<_ScrollCue> createState() => _ScrollCueState();
}

class _ScrollCueState extends State<_ScrollCue>
    with SingleTickerProviderStateMixin {
  late final _loop = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    reduceMotion ? _loop.stop() : _loop.repeat();
  }

  @override
  void dispose() {
    _loop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.rpColors;
    const trackHeight = 40.0;
    const segment = 12.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: RpTheme.spacingLarge),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppLocalizations.of(context)!.scrollHint.toUpperCase(),
            style: RpTheme.labelStyle(colors.textColor)
                .copyWith(fontSize: 10.0, letterSpacing: 3.0),
          ),
          RpTheme.spacerSmall,
          SizedBox(
            width: 1.0,
            height: trackHeight,
            child: AnimatedBuilder(
              animation: _loop,
              builder: (context, _) {
                final t = Curves.easeInOutCubic.transform(_loop.value);
                return Stack(
                  clipBehavior: Clip.hardEdge,
                  children: [
                    Positioned.fill(
                      child: ColoredBox(color: colors.hairlineColor),
                    ),
                    Positioned(
                      top: -segment + (trackHeight + segment) * t,
                      left: 0.0,
                      right: 0.0,
                      height: segment,
                      child: const ColoredBox(color: RpTheme.brandColor),
                    ),
                  ],
                );
              },
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
        alwaysIncludeSemantics: true,
        child: Transform.translate(
          offset: Offset(0, (1 - animation.value) * 18.0),
          child: child,
        ),
      ),
      child: child,
    );
  }
}
