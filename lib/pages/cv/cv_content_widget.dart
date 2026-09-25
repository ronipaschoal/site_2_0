import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ronip/core/hyperlink_helper.dart';
import 'package:ronip/core/media_query_helper.dart';
import 'package:ronip/l10n/app_localizations.dart';
import 'package:ronip/models/cv_item_model.dart';
import 'package:ronip/pages/cv/cv_data.dart';
import 'package:ronip/pages/home/widgets/home_section_title_widget.dart';
import 'package:ronip/core/theme.dart';
import 'package:ronip/widgets/tappable_widget.dart';

/// The résumé content itself — header, contact/skills sidebar, and the
/// summary/experience/certifications/education main column — laid out
/// after the same two-column shape as the PDF résumé
/// (`Roni_Paschoal_Mobile_Developer_Flutter.pdf`). On small screens the
/// columns stack, sidebar first.
///
/// Shared by [CvScreen] (the full `/cv` page) and `CvDialogWidget` (the
/// same content opened as a dismissible overlay from the home menu), so it
/// takes the host's [scrollController] rather than owning one — reveal/
/// decode animations key off it, matching the rest of the site.
///
/// Every piece of résumé text is a [SelectableText] so a visitor (or a
/// recruiter copy-pasting into an ATS) can select and copy it directly;
/// the underlying content lives in `cv_data.dart` and is shared with the
/// PDF export (`CvPdfBuilder`) behind the print button.
class CvContentWidget extends StatelessWidget {
  final ScrollController scrollController;

  const CvContentWidget({super.key, required this.scrollController});

  /// Screen readers order nodes by position, so without a container per
  /// column they'd interleave the sidebar and the main column line by line
  /// ("Contact, Summary, email, …"). A container keeps each column whole:
  /// the sidebar reads first, then the main column.
  static Widget _column(Widget child) =>
      Semantics(container: true, explicitChildNodes: true, child: child);

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = context.isSmallScreen;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _CvHeaderWidget(),
        RpTheme.spacerLargeX,
        if (isSmallScreen)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _column(_CvSidebarWidget(scrollController: scrollController)),
              RpTheme.spacerLargeX,
              _column(
                _CvMainColumnWidget(scrollController: scrollController),
              ),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 280.0,
                child: _column(
                  _CvSidebarWidget(scrollController: scrollController),
                ),
              ),
              RpTheme.spacerLargeX,
              Expanded(
                child: _column(
                  _CvMainColumnWidget(scrollController: scrollController),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

/// A [SelectableText] that is always named for screen readers — without a
/// `semanticsLabel`, Flutter Web exposes a SelectableText as an unlabelled
/// text box. [semanticsLabel] overrides the spoken text (e.g. the natural
/// case of an all-caps label); [headingLevel] makes it an `<h1>`–`<h6>`.
class _CvText extends StatelessWidget {
  final String text;
  final String? semanticsLabel;
  final int? headingLevel;
  final TextStyle? style;
  final TextAlign? textAlign;

  const _CvText(
    this.text, {
    this.semanticsLabel,
    this.headingLevel,
    this.style,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    final label = semanticsLabel ?? text;
    final selectable = SelectableText(
      text,
      semanticsLabel: label,
      style: style,
      textAlign: textAlign,
    );
    final level = headingLevel;
    if (level == null) return selectable;

    return Semantics(
      headingLevel: level,
      label: label,
      excludeSemantics: true,
      child: selectable,
    );
  }
}

class _CvHeaderWidget extends StatelessWidget {
  const _CvHeaderWidget();

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = context.isSmallScreen;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CvText(
          'Roni Paschoal',
          headingLevel: 1,
          style: TextStyle(
            fontFamily: RpTheme.fontFamilyDisplay,
            fontSize: isSmallScreen ? 32.0 : RpTheme.fontSizeLarge,
            color: context.rpColors.textHighlightColor,
          ),
        ),
        RpTheme.spacerSmall,
        _CvText(
          AppLocalizations.of(context)!.cvRole.toUpperCase(),
          semanticsLabel: AppLocalizations.of(context)!.cvRole,
          style: TextStyle(
            fontFamily: RpTheme.fontFamilyMono,
            fontSize: RpTheme.fontSizeRegular,
            fontWeight: FontWeight.w600,
            color: context.rpColors.accentTextColor,
            letterSpacing: 2.0,
          ),
        ),
        RpTheme.spacerSmallX,
        _CvText(
          'Flutter · Dart · Android · iOS',
          style: TextStyle(color: context.rpColors.textColor),
        ),
        RpTheme.spacerSmall,
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 15.0,
              color: context.rpColors.textColor,
            ),
            const SizedBox(width: 4.0),
            _CvText(
              'Santo André, SP',
              style: RpTheme.labelStyle(context.rpColors.textColor),
            ),
            const SizedBox(width: 12.0),
            _CvText(
              AppLocalizations.of(context)!
                  .cvAge(DateTime.now().year - cvBirthYear),
              style: RpTheme.labelStyle(context.rpColors.textColor),
            ),
          ],
        ),
      ],
    );
  }
}

class _CvSidebarWidget extends StatelessWidget {
  final ScrollController scrollController;

  const _CvSidebarWidget({required this.scrollController});

  String _skillGroupLabel(BuildContext context, String key) {
    switch (key) {
      case 'mobile':
        return AppLocalizations.of(context)!.cvSkillsMobile;
      case 'architecture':
        return AppLocalizations.of(context)!.cvSkillsArchitecture;
      case 'fullstack':
        return AppLocalizations.of(context)!.cvSkillsFullstack;
      default:
        return AppLocalizations.of(context)!.cvSkillsTools;
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSectionTitleWidget(
          title: AppLocalizations.of(context)!.contact,
          scrollController: scrollController,
        ),
        for (final contact in cvContactList) ...[
          _CvLinkRowWidget(contact: contact),
          RpTheme.spacerMedium,
        ],
        RpTheme.spacerLarge,
        HomeSectionTitleWidget(
          title: AppLocalizations.of(context)!.cvSkills,
          scrollController: scrollController,
        ),
        for (final key in cvSkillGroupOrder) ...[
          _CvText(
            _skillGroupLabel(context, key).toUpperCase(),
            semanticsLabel: _skillGroupLabel(context, key),
            style: RpTheme.labelStyle(context.rpColors.textColor),
          ),
          RpTheme.spacerSmall,
          Wrap(
            spacing: RpTheme.spacingSmall,
            runSpacing: RpTheme.spacingSmall,
            children: [
              for (final skill in cvSkillGroups[key]!)
                _CvSkillChipWidget(skill),
            ],
          ),
          RpTheme.spacerMedium,
        ],
        _CvText(
          AppLocalizations.of(context)!.cvSkillsLanguages.toUpperCase(),
          semanticsLabel: AppLocalizations.of(context)!.cvSkillsLanguages,
          style: RpTheme.labelStyle(context.rpColors.textColor),
        ),
        RpTheme.spacerSmall,
        Wrap(
          spacing: RpTheme.spacingSmall,
          runSpacing: RpTheme.spacingSmall,
          children: [
            for (final item in cvLanguageList)
              _CvSkillChipWidget(
                '${item.languageFor(languageCode)} · '
                '${item.levelFor(languageCode)}',
              ),
          ],
        ),
      ],
    );
  }
}

class _CvMainColumnWidget extends StatelessWidget {
  final ScrollController scrollController;

  const _CvMainColumnWidget({required this.scrollController});

  /// Certification and education entries only exist in Portuguese (course
  /// and issuer names), so they're tagged `lang="pt"` on web — with the site
  /// in English, screen readers still switch to a Portuguese voice for them.
  static Widget _portuguese(Widget child) => Semantics(
        localeForSubtree: const Locale('pt'),
        child: child,
      );

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final summaryText = cvSummary[locale.languageCode] ??
        cvSummary['pt'] ??
        cvSummary.values.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSectionTitleWidget(
          title: AppLocalizations.of(context)!.cvSummary,
          scrollController: scrollController,
        ),
        _CvText(
          summaryText,
          textAlign: TextAlign.start,
        ),
        RpTheme.spacerLargeX,
        HomeSectionTitleWidget(
          title: AppLocalizations.of(context)!.cvExperience,
          scrollController: scrollController,
        ),
        for (var i = 0; i < cvExperienceList.length; i++) ...[
          _CvExperienceCardWidget(item: cvExperienceList[i]),
          if (i != cvExperienceList.length - 1) ...[
            RpTheme.spacerLarge,
            Divider(color: context.rpColors.hairlineColor, height: 1.0),
            RpTheme.spacerLarge,
          ],
        ],
        RpTheme.spacerLargeX,
        HomeSectionTitleWidget(
          title: AppLocalizations.of(context)!.cvProjects,
          scrollController: scrollController,
        ),
        for (var i = 0; i < cvProjectList.length; i++) ...[
          _CvProjectCardWidget(item: cvProjectList[i]),
          if (i != cvProjectList.length - 1) RpTheme.spacerMedium,
        ],
        RpTheme.spacerLargeX,
        HomeSectionTitleWidget(
          title: AppLocalizations.of(context)!.cvCertifications,
          scrollController: scrollController,
        ),
        for (final certification in cvCertificationList) ...[
          _portuguese(_CvCertificationRowWidget(item: certification)),
          RpTheme.spacerMedium,
        ],
        RpTheme.spacerLarge,
        HomeSectionTitleWidget(
          title: AppLocalizations.of(context)!.cvEducation,
          scrollController: scrollController,
        ),
        for (final education in cvEducationList) ...[
          _portuguese(_CvEducationRowWidget(item: education)),
          RpTheme.spacerMedium,
        ],
      ],
    );
  }
}

class _CvProjectCardWidget extends StatelessWidget {
  final CvProjectItem item;

  const _CvProjectCardWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RpTappableWidget(
          url: item.url,
          semanticsLabel: item.title,
          onTap: () => HyperlinkHelper.open(item.url),
          builder: (context, highlighted) {
            final color = context.rpColors.accentTextColor;
            return Padding(
              padding: const EdgeInsets.all(2.0),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: RpTheme.spacingSmallX,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                      color: color,
                      decoration: TextDecoration.underline,
                      decorationColor: color,
                      decorationThickness: highlighted ? 2.0 : 1.0,
                    ),
                  ),
                  Icon(Icons.open_in_new, size: 14.0, color: color),
                ],
              ),
            );
          },
        ),
        RpTheme.spacerSmallX,
        _CvText(
          item.descriptionFor(languageCode),
          textAlign: TextAlign.start,
          style: const TextStyle(fontSize: 14.5),
        ),
        RpTheme.spacerSmall,
        Wrap(
          spacing: RpTheme.spacingSmall,
          runSpacing: RpTheme.spacingSmall,
          children: [for (final tech in item.tech) _CvSkillChipWidget(tech)],
        ),
      ],
    );
  }
}

class _CvExperienceCardWidget extends StatelessWidget {
  final CvExperienceItem item;

  const _CvExperienceCardWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: RpTheme.spacingSmall,
          runSpacing: RpTheme.spacingSmallX,
          children: [
            _CvText(
              item.company,
              headingLevel: 3,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18.0,
                color: context.rpColors.textHighlightColor,
              ),
            ),
            _CvText(
              item.periodWithDurationFor(languageCode),
              style: TextStyle(
                fontFamily: RpTheme.fontFamilyMono,
                fontSize: 12.5,
                color: context.rpColors.textColor,
              ),
            ),
          ],
        ),
        RpTheme.spacerSmallX,
        _CvText(
          item.roleFor(languageCode),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: RpTheme.fontSizeRegular,
            color: context.rpColors.accentTextColor,
          ),
        ),
        RpTheme.spacerSmall,
        _CvText(
          item.descriptionFor(languageCode),
          textAlign: TextAlign.start,
          style: const TextStyle(fontSize: 14.5),
        ),
      ],
    );
  }
}

class _CvCertificationRowWidget extends StatelessWidget {
  final CvCertificationItem item;

  const _CvCertificationRowWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6.0),
            child: Icon(
              Icons.workspace_premium_outlined,
              size: 16.0,
              color: RpTheme.brandColor,
            ),
          ),
          RpTheme.spacerSmall,
          Expanded(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: RpTheme.spacingSmall,
              children: [
                _CvText(
                  item.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: context.rpColors.textHighlightColor,
                  ),
                ),
                _CvText(
                  '${item.issuer} · ${item.date}',
                  style: TextStyle(
                    fontFamily: RpTheme.fontFamilyMono,
                    fontSize: 12.0,
                    color: context.rpColors.textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CvEducationRowWidget extends StatelessWidget {
  final CvEducationItem item;

  const _CvEducationRowWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6.0),
            child: Icon(
              Icons.school_outlined,
              size: 16.0,
              color: RpTheme.brandColor,
            ),
          ),
          RpTheme.spacerSmall,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CvText(
                  '${item.institution} · ${item.course}',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: context.rpColors.textHighlightColor,
                  ),
                ),
                _CvText(
                  item.period,
                  style: TextStyle(
                    fontFamily: RpTheme.fontFamilyMono,
                    fontSize: 12.0,
                    color: context.rpColors.textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CvSkillChipWidget extends StatelessWidget {
  final String skill;

  const _CvSkillChipWidget(this.skill);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        border: Border.all(color: context.rpColors.hairlineColor),
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      ),
      child: _CvText(
        skill,
        style: TextStyle(
          fontFamily: RpTheme.fontFamilyMono,
          fontSize: 12.5,
          color: context.rpColors.textHighlightColor,
        ),
      ),
    );
  }
}

/// Icon + text, both tappable to open the link. The icon is the accessible
/// link ([RpTappableWidget]: focusable, a real `<a href>` on web). The text
/// stays a [SelectableText.rich] (rather than plain `Text`) so the
/// address/handle can still be selected and copied, and is hidden from
/// semantics so the link isn't announced twice; its tap-to-open behavior is
/// attached via a [TapGestureRecognizer] on the span instead of an ancestor
/// tap gesture, which would compete with the text's own selection gesture
/// for the same pointer.
class _CvLinkRowWidget extends StatefulWidget {
  final CvContactItem contact;

  const _CvLinkRowWidget({required this.contact});

  @override
  State<_CvLinkRowWidget> createState() => _CvLinkRowWidgetState();
}

class _CvLinkRowWidgetState extends State<_CvLinkRowWidget> {
  late final TapGestureRecognizer _recognizer = TapGestureRecognizer()
    ..onTap = _open;

  void _open() => HyperlinkHelper.open(widget.contact.url);

  @override
  void dispose() {
    _recognizer.dispose();
    super.dispose();
  }

  Widget _icon() {
    switch (widget.contact.type) {
      case CvContactType.email:
        return _svgIcon('assets/images/logos/email.svg');
      case CvContactType.linkedin:
        return _svgIcon('assets/images/logos/linkedin.svg');
      case CvContactType.github:
        return _svgIcon('assets/images/logos/github.svg');
      case CvContactType.website:
        return const Icon(
          Icons.public,
          size: 16.0,
          color: RpTheme.brandColor,
        );
    }
  }

  Widget _svgIcon(String asset) => SvgPicture.asset(
        asset,
        width: 16.0,
        height: 16.0,
        colorFilter: const ColorFilter.mode(
          RpTheme.brandColor,
          BlendMode.srcIn,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // The icon carries the link for keyboard and screen readers (a real
        // <a href> on web); the text beside it stays a selectable span for
        // copy/paste and is excluded so the link isn't announced twice.
        RpTappableWidget(
          url: widget.contact.url,
          semanticsLabel: widget.contact.text,
          onTap: _open,
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          builder: (context, _) => Padding(
            padding: const EdgeInsets.all(4.0),
            child: _icon(),
          ),
        ),
        RpTheme.spacerSmall,
        Flexible(
          child: ExcludeSemantics(
            child: SelectableText.rich(
              TextSpan(
                text: widget.contact.text,
                recognizer: _recognizer,
                style: TextStyle(
                  fontSize: 13.5,
                  color: context.rpColors.accentTextColor,
                  decoration: TextDecoration.underline,
                  decorationColor: context.rpColors.accentTextColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
