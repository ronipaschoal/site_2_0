import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:ronip/core/hyperlink_helper.dart';
import 'package:ronip/core/media_query_helper.dart';
import 'package:ronip/core/profile.dart';
import 'package:ronip/l10n/app_localizations.dart';
import 'package:ronip/models/home_menu_model.dart';
import 'package:ronip/pages/cv/cv_data.dart';
import 'package:ronip/pages/cv/cv_dialog_widget.dart';
import 'package:ronip/pages/home/widgets/home_section_title_widget.dart';
import 'package:ronip/pages/home/widgets/home_section_widget.dart';
import 'package:ronip/core/theme.dart';
import 'package:ronip/widgets/reveal_on_scroll_widget.dart';
import 'package:ronip/widgets/signature_widget.dart';
import 'package:ronip/widgets/tappable_widget.dart';

const _mailtoUrl = 'mailto:$contactEmail?subject=Website contact!';

class ContactSection extends StatelessWidget {
  final List<ExternalMenu> externalMenuList;
  final ScrollController scrollController;

  const ContactSection({
    super.key,
    required this.externalMenuList,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return HomeSectionWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RpTheme.spacerLargeX2,
              HomeSectionTitleWidget(
                index: 3,
                title: HomeSectionEnum.contact.title(context),
                scrollController: scrollController,
              ),
              RpRevealOnScrollWidget(
                scrollController: scrollController,
                // Without a semanticsLabel, SelectableText is exposed on web
                // as an unnamed text box.
                child: SelectableText(
                  l10n.sayHello,
                  semanticsLabel: l10n.sayHello,
                ),
              ),
              RpTheme.spacerLarge,
              RpRevealOnScrollWidget(
                scrollController: scrollController,
                child: const _LetsTalkCta(),
              ),
              RpTheme.spacerLarge,
              RpRevealOnScrollWidget(
                scrollController: scrollController,
                child: const _EmailRow(),
              ),
              RpTheme.spacerLargeX,
              RpRevealOnScrollWidget(
                scrollController: scrollController,
                child: Wrap(
                  spacing: RpTheme.spacingLarge,
                  runSpacing: RpTheme.spacingMedium,
                  children: [
                    for (final external in externalMenuList)
                      _ArrowLink(
                        label: external.text,
                        url: external.url,
                        onTap: external.goToExternal,
                      ),
                    _ArrowLink(
                      label: l10n.cvHeading,
                      onTap: () => CvDialogWidget.show(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
          RpTheme.spacerLargeX2,
          _Footer(scrollController: scrollController),
        ],
      ),
    );
  }
}

/// The oversized "Let's talk →" mailto link.
class _LetsTalkCta extends StatelessWidget {
  const _LetsTalkCta();

  @override
  Widget build(BuildContext context) {
    final colors = context.rpColors;
    final l10n = AppLocalizations.of(context)!;
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final duration =
        reduceMotion ? Duration.zero : const Duration(milliseconds: 260);
    final fontSize =
        RpTheme.fluid(context, min: 44.0, max: 112.0, factor: 0.09);

    return RpTappableWidget(
      url: _mailtoUrl,
      semanticsLabel: '${l10n.letsTalk}: $contactEmail',
      onTap: () => HyperlinkHelper.open(_mailtoUrl),
      builder: (context, highlighted) {
        final style = RpTheme.headingStyle(
          highlighted ? RpTheme.brandColor : colors.textHighlightColor,
          fontSize: fontSize,
          weight: 500,
          height: 1.0,
        );

        return Padding(
          padding: const EdgeInsets.all(RpTheme.spacingSmall),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  AnimatedDefaultTextStyle(
                    duration: duration,
                    style: style,
                    child: Text(l10n.letsTalk),
                  ),
                  AnimatedPadding(
                    duration: duration,
                    curve: Curves.easeOutCubic,
                    padding: EdgeInsets.only(
                      left: highlighted ? fontSize * 0.4 : fontSize * 0.25,
                    ),
                    child: AnimatedDefaultTextStyle(
                      duration: duration,
                      style: style,
                      child: const Text('→'),
                    ),
                  ),
                ],
              ),
              RpTheme.spacerSmall,
              AnimatedContainer(
                duration: duration,
                curve: Curves.easeOutCubic,
                height: 2.0,
                width: highlighted ? fontSize * 5 : fontSize * 1.2,
                color: RpTheme.brandColor,
              ),
            ],
          ),
        );
      },
    );
  }
}

/// The email in mono, plus a copy button that briefly flips to "Copied ✓".
class _EmailRow extends StatefulWidget {
  const _EmailRow();

  @override
  State<_EmailRow> createState() => _EmailRowState();
}

class _EmailRowState extends State<_EmailRow> {
  bool _copied = false;
  Timer? _reset;

  @override
  void dispose() {
    _reset?.cancel();
    super.dispose();
  }

  Future<void> _copy() async {
    await Clipboard.setData(const ClipboardData(text: contactEmail));
    if (!mounted) return;
    setState(() => _copied = true);
    // The label swap is purely visual; say it out loud for screen readers.
    SemanticsService.sendAnnouncement(
      View.of(context),
      '${AppLocalizations.of(context)!.copied}: $contactEmail',
      Directionality.of(context),
    );
    _reset?.cancel();
    _reset = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.rpColors;

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: RpTheme.spacingMedium,
      runSpacing: RpTheme.spacingSmall,
      children: [
        SelectableText(
          contactEmail,
          semanticsLabel: contactEmail,
          style: TextStyle(
            fontFamily: RpTheme.fontFamilyMono,
            fontSize: RpTheme.fontSizeRegular + 2.0,
            color: colors.textHighlightColor,
          ),
        ),
        OutlinedButton(
          onPressed: _copy,
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: _copied ? RpTheme.statusColor : colors.hairlineColor,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: Text(
              (_copied ? '${l10n.copied} ✓' : l10n.copyEmail).toUpperCase(),
              key: ValueKey(_copied),
              semanticsLabel: _copied ? l10n.copied : l10n.copyEmail,
              // Green only on the border: as text it drops to 1.65:1 on the
              // light palette.
              style: RpTheme.labelStyle(
                _copied ? colors.textHighlightColor : colors.textColor,
              ).copyWith(fontSize: 11.0, letterSpacing: 1.4),
            ),
          ),
        ),
      ],
    );
  }
}

/// "LinkedIn ↗" style secondary link with a hover underline.
class _ArrowLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  /// Set for external destinations (announced as a link); null for in-page
  /// actions like opening the résumé (announced as a button).
  final String? url;

  const _ArrowLink({required this.label, required this.onTap, this.url});

  @override
  Widget build(BuildContext context) {
    final colors = context.rpColors;

    return RpTappableWidget(
      url: url,
      // The plain name, not the uppercased "LABEL ↗" — screen readers may
      // spell out all-caps words and read the arrow glyph aloud.
      semanticsLabel: label,
      onTap: onTap,
      builder: (context, highlighted) => Padding(
        padding: const EdgeInsets.all(RpTheme.spacingSmallX),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$label ↗'.toUpperCase(),
              style: RpTheme.labelStyle(
                highlighted ? colors.textHighlightColor : colors.textColor,
              ),
            ),
            RpTheme.spacerSmallX,
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 1.0,
              width: highlighted ? 60.0 : 0.0,
              color: RpTheme.brandColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  final ScrollController scrollController;

  const _Footer({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.rpColors;
    final isSmallScreen = context.isSmallScreen;
    final style = RpTheme.labelStyle(colors.textColor)
        .copyWith(fontSize: 11.0, letterSpacing: 1.4);
    // The commit hash stays lowercase, as git prints it.
    final meta = [
      l10n.builtWithFlutter.toUpperCase(),
      'BUILD ${RpProfile.buildSha}',
      '© ${DateTime.now().year}',
    ].join('  ·  ');

    final info = Column(
      crossAxisAlignment:
          isSmallScreen ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          meta,
          style: style,
          textAlign: isSmallScreen ? TextAlign.start : TextAlign.end,
          semanticsLabel: '${l10n.builtWithFlutter}, build '
              '${RpProfile.buildSha}, © ${DateTime.now().year}',
        ),
        RpTheme.spacerSmall,
        _ArrowLink(
          label: l10n.sourceCode,
          url: RpProfile.sourceUrl,
          onTap: () => HyperlinkHelper.open(RpProfile.sourceUrl),
        ),
      ],
    );

    return Container(
      padding: const EdgeInsets.only(
        top: RpTheme.spacingLarge,
        bottom: RpTheme.spacingLarge,
      ),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.hairlineColor)),
      ),
      child: Flex(
        direction: isSmallScreen ? Axis.vertical : Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment:
            isSmallScreen ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          RpSignatureWidget(
            scrollController: scrollController,
            fontSize: isSmallScreen ? 34.0 : 44.0,
          ),
          if (isSmallScreen) RpTheme.spacerMedium else RpTheme.spacerLarge,
          // Beside the signature on wider screens, the meta line may need
          // to wrap (tablet widths) rather than overflow the row.
          if (isSmallScreen) info else Flexible(child: info),
        ],
      ),
    );
  }
}
