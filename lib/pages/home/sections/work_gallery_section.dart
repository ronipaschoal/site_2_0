import 'package:flutter/material.dart';
import 'package:ronip/core/hyperlink_helper.dart';
import 'package:ronip/core/media_query_helper.dart';
import 'package:ronip/models/home_menu_model.dart';
import 'package:ronip/models/work_item_model.dart';
import 'package:ronip/pages/home/widgets/home_section_title_widget.dart';
import 'package:ronip/core/theme.dart';
import 'package:ronip/widgets/image_widget.dart';

/// "Pin and scrub" gallery: the section reserves a tall block of vertical
/// scroll space, but pins itself to the viewport for that whole distance
/// (the same trick CSS `position: sticky` uses) while translating its cards
/// horizontally in step with the extra scroll — so scrolling (wheel, or a
/// touch drag on mobile) drives the gallery sideways instead of the page
/// moving down, until the last card clears and the page continues to
/// Contact normally. Only the sizing below is screen-size aware; the pin
/// mechanic itself just reacts to scroll offset, so it's the same on touch.
class WorkGallerySection extends StatefulWidget {
  final ScrollController scrollController;

  const WorkGallerySection({super.key, required this.scrollController});

  // Stand-in for what would come from a real content source (CMS/database):
  // each item already carries its own per-language title/description.
  static const _workList = [
    WorkItem(
      title: {'pt': 'Roni Paschoal (V1)', 'en': 'Roni Paschoal (V1)'},
      tag: 'Web · AngularJS',
      description: {
        'pt': 'Site anterior desenvolvido em AngularJS.',
        'en': 'Previous site developed in AngularJS.',
      },
      url: 'https://angular.ronipaschoal.com.br/',
      image: 'assets/images/photos/site-roni-paschoal-angularjs.png',
    ),
    WorkItem(
      title: {
        'pt': 'O Eremita do Iceberg, Flutter',
        'en': 'O Eremita do Iceberg, Flutter',
      },
      tag: 'Web · Flutter',
      description: {
        'pt':
            'Estudo de animações nativas e gerenciamento de estados Bloc/Cubit, em Flutter.',
        'en':
            'Study of native animations and Bloc/Cubit state management, in Flutter.',
      },
      url: 'https://eremitaflutter.ronipaschoal.com.br/',
      image: 'assets/images/photos/flutter-o-eremita-do-iceberg.png',
    ),
    WorkItem(
      title: {'pt': 'Reali Plásticos', 'en': 'Reali Plásticos'},
      tag: 'Web · PHP',
      description: {
        'pt':
            'Desenvolvimento em PHP, criação das imagens em 3d, UX e SEO do site institucional da empresa.',
        'en':
            "Development in PHP, creation of 3D images, UX and SEO of the company's institutional website.",
      },
      url: 'https://www.realiplasticos.com.br/',
      image: 'assets/images/photos/site-reali-plasticos.png',
    ),
    WorkItem(
      title: {
        'pt': 'Minha Comanda Eletrônica, App Flutter',
        'en': 'Minha Comanda Eletrônica, App Flutter',
      },
      tag: 'App · Flutter',
      description: {
        'pt':
            'Participação na concepção e desenvolvimento em Flutter (Android, IOS, Cielo, Rede e PagSeguro), MVVM e Bloc/Cubit.',
        'en':
            'Participation in the design and development in Flutter (Android, IOS, Cielo, Rede and PagSeguro), MVVM and Bloc/Cubit.',
      },
      url:
          'https://play.google.com/store/apps/details?id=com.totvs.thex.minhacomanda',
      urlApple:
          'https://apps.apple.com/br/app/minha-comanda-eletr%C3%B4nica/id6474201107',
      image: 'assets/images/photos/minha-comanda.png',
    ),
  ];

  @override
  State<WorkGallerySection> createState() => _WorkGallerySectionState();
}

class _WorkGallerySectionState extends State<WorkGallerySection> {
  final _anchorKey = GlobalKey();

  double _stickyOffset(double travelDistance) {
    final box = _anchorKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.attached || !box.hasSize) return 0.0;
    final topY = box.localToGlobal(Offset.zero).dy;
    return (-topY).clamp(0.0, travelDistance);
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final isSmallScreen = context.isSmallScreen;
    final viewportSize = MediaQuery.sizeOf(context);
    final cardCount = WorkGallerySection._workList.length;

    final edgePadding = isSmallScreen ? 16.0 : 48.0;
    final cardGap = isSmallScreen ? 16.0 : 28.0;
    final cardWidth = isSmallScreen
        ? (viewportSize.width * 0.84).clamp(240.0, 520.0)
        : (viewportSize.width * 0.56).clamp(420.0, 760.0);
    final cardHeight = viewportSize.height * (isSmallScreen ? 0.42 : 0.62);
    // The mobile AppBar sits on top of the (extendBodyBehindAppBar) body, and
    // unlike normal sections this one stays pinned under that band for its
    // whole scrub duration, so it needs an explicit clearance — normal
    // sections only ever pass through that band briefly while scrolling.
    final topInset = MediaQuery.paddingOf(context).top +
        (isSmallScreen ? kToolbarHeight : 0.0);

    final totalContentWidth =
        edgePadding * 2 + cardWidth * cardCount + cardGap * (cardCount - 1);
    final travelDistance = reduceMotion
        ? 0.0
        : (totalContentWidth - viewportSize.width).clamp(0.0, double.infinity);

    return Center(
      child: SizedBox(
        key: _anchorKey,
        height: viewportSize.height + travelDistance,
        child: AnimatedBuilder(
          animation: widget.scrollController,
          builder: (context, _) {
            final offset = reduceMotion ? 0.0 : _stickyOffset(travelDistance);
            final progress =
                travelDistance == 0 ? 0.0 : offset / travelDistance;

            return Stack(
              children: [
                Positioned(
                  top: offset,
                  left: 0,
                  right: 0,
                  height: viewportSize.height,
                  child: Stack(
                    children: [
                      ClipRect(
                        child: OverflowBox(
                          alignment: Alignment.centerLeft,
                          minWidth: 0,
                          maxWidth: double.infinity,
                          maxHeight: viewportSize.height,
                          child: Transform.translate(
                            // Transform's hit-testing is bounded by its own
                            // layout size, which OverflowBox reports as the
                            // (larger) size of this Row rather than the
                            // clipped viewport — so cards scrolled into view
                            // stay tappable instead of only the portion that
                            // was visible before any translation.
                            offset: Offset(-progress * travelDistance, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: edgePadding),
                                for (var i = 0; i < cardCount; i++) ...[
                                  _GalleryCard(
                                    work: WorkGallerySection._workList[i],
                                    index: i,
                                    width: cardWidth,
                                    height: cardHeight,
                                    compact: isSmallScreen,
                                  ),
                                  if (i != cardCount - 1)
                                    SizedBox(width: cardGap),
                                ],
                                SizedBox(width: edgePadding),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: edgePadding,
                        top: isSmallScreen
                            ? topInset + 20.0
                            : viewportSize.height * 0.1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            HomeSectionTitleWidget(
                              title: HomeSectionEnum.programs.title(context),
                              scrollController: widget.scrollController,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: edgePadding,
                        bottom: isSmallScreen
                            ? MediaQuery.paddingOf(context).bottom + 20.0
                            : viewportSize.height * 0.08,
                        child: IgnorePointer(
                          child: Text(
                            '${(progress * (cardCount - 1)).round() + 1} / $cardCount',
                            style:
                                RpTheme.labelStyle(context.rpColors.textColor),
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
      ),
    );
  }
}

class _GalleryCard extends StatefulWidget {
  final WorkItem work;
  final int index;
  final double width;
  final double height;
  final bool compact;

  const _GalleryCard({
    required this.work,
    required this.index,
    required this.width,
    required this.height,
    required this.compact,
  });

  @override
  State<_GalleryCard> createState() => _GalleryCardState();
}

class _GalleryCardState extends State<_GalleryCard> {
  bool _hovering = false;

  void _open(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    final isMacOS = Theme.of(context).platform == TargetPlatform.macOS;
    final work = widget.work;
    final hasAppleUrl = work.urlApple?.isNotEmpty ?? false;
    final url = (isIOS || isMacOS) && hasAppleUrl ? work.urlApple! : work.url;
    HyperlinkHelper.open(url);
  }

  @override
  Widget build(BuildContext context) {
    final work = widget.work;
    final locale = Localizations.localeOf(context);
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final duration =
        reduceMotion ? Duration.zero : const Duration(milliseconds: 220);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: () => _open(context),
        child: AnimatedScale(
          duration: duration,
          curve: Curves.easeOut,
          scale: _hovering ? 1.02 : 1.0,
          child: AnimatedContainer(
            duration: duration,
            curve: Curves.easeOut,
            width: widget.width,
            height: widget.height,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  RpImageWidget(
                    asset: work.image,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(
                          color: RpTheme.blackColor.withAlpha(120),
                          width: 0.6,
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            context.rpColors.backgroundColor.withAlpha(235),
                            context.rpColors.backgroundColor.withAlpha(50),
                            context.rpColors.backgroundColor.withAlpha(50),
                            context.rpColors.backgroundColor.withAlpha(235),
                          ],
                          stops: const [0.0, 0.16, 0.6, 0.9],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20.0,
                    top: 16.0,
                    child: SelectableText(
                      (widget.index + 1).toString().padLeft(2, '0'),
                      style: TextStyle(
                        fontFamily: RpTheme.fontFamilyMono,
                        fontSize: widget.compact ? 16.0 : 20.0,
                        fontWeight: FontWeight.w600,
                        color: context.rpColors.textHighlightColor,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20.0,
                    right: 20.0,
                    bottom: 18.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SelectableText(
                          work.tag.toUpperCase(),
                          style: RpTheme.labelStyle(context.rpColors.textColor),
                        ),
                        RpTheme.spacerSmall,
                        SelectableText(
                          work.titleFor(locale),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: widget.compact ? 17.0 : 22.0,
                            color: context.rpColors.textHighlightColor,
                          ),
                        ),
                        RpTheme.spacerSmallX,
                        SelectableText(
                          work.descriptionFor(locale),
                          maxLines: 2,
                          style: TextStyle(
                            color: context.rpColors.textColor,
                            fontSize: widget.compact ? 12.5 : 14.0,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
