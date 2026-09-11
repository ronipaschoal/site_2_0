import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ronip/helpers/hyperlink_helper.dart';
import 'package:ronip/helpers/media_query_helper.dart';
import 'package:ronip/l10n/app_localizations.dart';
import 'package:ronip/model/cv_item_model.dart';
import 'package:ronip/pages/cv/cv_data.dart';
import 'package:ronip/pages/home/widgets/home_section_title_widget.dart';
import 'package:ronip/ui/theme.dart';

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

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQueryHelper(context).isSmallScreen();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _CvHeaderWidget(),
        RpTheme.spacerLargeX,
        if (isSmallScreen)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CvSidebarWidget(scrollController: scrollController),
              RpTheme.spacerLargeX,
              _CvMainColumnWidget(scrollController: scrollController),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 280.0,
                child: _CvSidebarWidget(scrollController: scrollController),
              ),
              RpTheme.spacerLargeX,
              Expanded(
                child: _CvMainColumnWidget(scrollController: scrollController),
              ),
            ],
          ),
      ],
    );
  }
}

class _CvHeaderWidget extends StatelessWidget {
  const _CvHeaderWidget();

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQueryHelper(context).isSmallScreen();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectableText(
          'Roni Paschoal',
          semanticsLabel: 'Roni Paschoal',
          style: TextStyle(
            fontFamily: RpTheme.fontFamilyDisplay,
            fontSize: isSmallScreen ? 32.0 : RpTheme.fontSizeLarge,
            color: RpTheme.textHighlightColor,
          ),
        ),
        RpTheme.spacerSmall,
        SelectableText(
          AppLocalizations.of(context)!.cvRole.toUpperCase(),
          style: const TextStyle(
            fontFamily: RpTheme.fontFamilyMono,
            fontSize: RpTheme.fontSizeRegular,
            fontWeight: FontWeight.w600,
            color: RpTheme.brandColor,
            letterSpacing: 2.0,
          ),
        ),
        RpTheme.spacerSmallX,
        SelectableText(
          'Flutter · Dart · Android · iOS',
          style: TextStyle(color: RpTheme.textColor),
        ),
        RpTheme.spacerSmall,
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 15.0,
              color: RpTheme.textColor,
            ),
            const SizedBox(width: 4.0),
            SelectableText('Santo André, SP', style: RpTheme.labelStyle),
            const SizedBox(width: 12.0),
            SelectableText(
              AppLocalizations.of(context)!
                  .cvAge(DateTime.now().year - cvBirthYear),
              style: RpTheme.labelStyle,
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
          SelectableText(
            _skillGroupLabel(context, key).toUpperCase(),
            style: RpTheme.labelStyle,
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
        SelectableText(
          AppLocalizations.of(context)!.cvSkillsLanguages.toUpperCase(),
          style: RpTheme.labelStyle,
        ),
        RpTheme.spacerSmall,
        Wrap(
          spacing: RpTheme.spacingSmall,
          runSpacing: RpTheme.spacingSmall,
          children: [
            for (final item in cvLanguageList)
              _CvSkillChipWidget(
                '${item.languageFor(languageCode)} – '
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
        SelectableText(
          summaryText,
          semanticsLabel: summaryText,
          textAlign: TextAlign.justify,
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
            Divider(color: RpTheme.hairlineColor, height: 1.0),
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
          _CvCertificationRowWidget(item: certification),
          RpTheme.spacerMedium,
        ],
        RpTheme.spacerLarge,
        HomeSectionTitleWidget(
          title: AppLocalizations.of(context)!.cvEducation,
          scrollController: scrollController,
        ),
        for (final education in cvEducationList) ...[
          _CvEducationRowWidget(item: education),
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
        InkWell(
          onTap: () => HyperlinkHelper.targetBlank(item.url),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: RpTheme.spacingSmallX,
            children: [
              Text(
                item.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                  color: RpTheme.brandColor,
                  decoration: TextDecoration.underline,
                  decorationColor: RpTheme.brandColor,
                ),
              ),
              const Icon(
                Icons.open_in_new,
                size: 14.0,
                color: RpTheme.brandColor,
              ),
            ],
          ),
        ),
        RpTheme.spacerSmallX,
        SelectableText(
          item.descriptionFor(languageCode),
          semanticsLabel: item.descriptionFor(languageCode),
          textAlign: TextAlign.justify,
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
            SelectableText(
              item.company,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18.0,
                color: RpTheme.textHighlightColor,
              ),
            ),
            SelectableText(
              item.period,
              style: TextStyle(
                fontFamily: RpTheme.fontFamilyMono,
                fontSize: 12.5,
                color: RpTheme.textColor,
              ),
            ),
          ],
        ),
        RpTheme.spacerSmallX,
        SelectableText(
          item.roleFor(languageCode),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: RpTheme.fontSizeRegular,
            color: RpTheme.brandColor,
          ),
        ),
        RpTheme.spacerSmall,
        SelectableText(
          item.descriptionFor(languageCode),
          semanticsLabel: item.descriptionFor(languageCode),
          textAlign: TextAlign.justify,
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
    return Row(
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
              SelectableText(
                item.title,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: RpTheme.textHighlightColor,
                ),
              ),
              SelectableText(
                '${item.issuer} · ${item.date}',
                style: TextStyle(
                  fontFamily: RpTheme.fontFamilyMono,
                  fontSize: 12.0,
                  color: RpTheme.textColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CvEducationRowWidget extends StatelessWidget {
  final CvEducationItem item;

  const _CvEducationRowWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
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
              SelectableText(
                '${item.institution} · ${item.course}',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: RpTheme.textHighlightColor,
                ),
              ),
              SelectableText(
                item.period,
                style: TextStyle(
                  fontFamily: RpTheme.fontFamilyMono,
                  fontSize: 12.0,
                  color: RpTheme.textColor,
                ),
              ),
            ],
          ),
        ),
      ],
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
        border: Border.all(color: RpTheme.hairlineColor),
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      ),
      child: SelectableText(
        skill,
        style: TextStyle(
          fontFamily: RpTheme.fontFamilyMono,
          fontSize: 12.5,
          color: RpTheme.textHighlightColor,
        ),
      ),
    );
  }
}

/// Icon + text, both tappable to open the link. The text stays a
/// [SelectableText.rich] (rather than plain `Text`) so the address/handle
/// can still be selected and copied; the tap-to-open behavior is attached
/// via a [TapGestureRecognizer] on its span instead of wrapping the row in
/// an [InkWell] — a `SelectableText`'s own selection gesture would
/// otherwise compete with an ancestor tap gesture for the same pointer.
class _CvLinkRowWidget extends StatefulWidget {
  final CvContactItem contact;

  const _CvLinkRowWidget({required this.contact});

  @override
  State<_CvLinkRowWidget> createState() => _CvLinkRowWidgetState();
}

class _CvLinkRowWidgetState extends State<_CvLinkRowWidget> {
  late final TapGestureRecognizer _recognizer = TapGestureRecognizer()
    ..onTap = _open;

  void _open() => widget.contact.url.startsWith('mailto:')
      ? HyperlinkHelper.mail(widget.contact.url)
      : HyperlinkHelper.targetBlank(widget.contact.url);

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
        InkWell(
          onTap: _open,
          customBorder: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: _icon(),
          ),
        ),
        RpTheme.spacerSmall,
        Flexible(
          child: SelectableText.rich(
            TextSpan(
              text: widget.contact.text,
              recognizer: _recognizer,
              style: const TextStyle(
                fontSize: 13.5,
                color: RpTheme.brandColor,
                decoration: TextDecoration.underline,
                decorationColor: RpTheme.brandColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
