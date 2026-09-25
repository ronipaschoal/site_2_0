import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:ronip/core/hyperlink_helper.dart';
import 'package:ronip/core/media_query_helper.dart';
import 'package:ronip/core/profile.dart';
import 'package:ronip/l10n/app_localizations.dart';
import 'package:ronip/models/home_menu_model.dart';
import 'package:ronip/models/work_item_model.dart';
import 'package:ronip/pages/home/widgets/home_section_title_widget.dart';
import 'package:ronip/core/theme.dart';
import 'package:ronip/widgets/image_widget.dart';
import 'package:ronip/widgets/logo_widget.dart';
import 'package:ronip/widgets/tappable_widget.dart';

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
    WorkItem(
      title: {'pt': 'Este site, Flutter Web', 'en': 'This site, Flutter Web'},
      tag: 'Web · Flutter · Shaders',
      description: {
        'pt':
            'Portfólio em Flutter Web com fragment shaders, Bloc/Cubit, animações ligadas ao scroll e CI/CD via GitHub Actions.',
        'en':
            'Flutter Web portfolio with fragment shaders, Bloc/Cubit, scroll-linked animations and CI/CD via GitHub Actions.',
      },
      url: RpProfile.sourceUrl,
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
  ];

  @override
  State<WorkGallerySection> createState() => _WorkGallerySectionState();
}

class _WorkGallerySectionState extends State<WorkGallerySection> {
  final _anchorKey = GlobalKey();

  /// Card whose semantic proxy holds keyboard / screen reader focus.
  int? _focusedIndex;

  /// Measured height of the section title (it may wrap to two lines on
  /// phones), so the mobile card row can start right below it. Seeded with
  /// a one-line estimate for the first frame.
  final _titleKey = GlobalKey();
  double _titleHeight = 110.0;

  void _measureTitle() {
    final height = _titleKey.currentContext?.size?.height;
    if (!mounted || height == null) return;
    if ((height - _titleHeight).abs() > 0.5) {
      setState(() => _titleHeight = height);
    }
  }

  /// Scrolls the page so the pinned gallery's horizontal scrub puts card
  /// [index] at the left edge — used when keyboard focus lands on a card
  /// that's currently translated out of view.
  void _revealCard(int index, double step, double travelDistance) {
    final box = _anchorKey.currentContext?.findRenderObject() as RenderBox?;
    final controller = widget.scrollController;
    if (box == null || !box.attached || !controller.hasClients) return;

    final sectionTop = controller.offset + box.localToGlobal(Offset.zero).dy;
    final target = sectionTop + (index * step).clamp(0.0, travelDistance);
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    reduceMotion
        ? controller.jumpTo(target)
        : controller.animateTo(
            target,
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutCubic,
          );
  }

  /// One invisible, focusable link per card, stacked on the slot where the
  /// focused card gets scrubbed to (the left edge of the row). They always
  /// sit in view, so every project stays in the semantics tree; focusing
  /// one scrolls the gallery to its card, so sighted keyboard and screen
  /// reader users see what's being announced. They don't take pointer
  /// events — mouse input goes to the visual cards underneath.
  Widget _proxies({
    required double left,
    required double top,
    required double width,
    required double height,
    required double step,
    required double travelDistance,
  }) {
    final locale = Localizations.localeOf(context);
    const works = WorkGallerySection._workList;

    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: _PointerTransparent(
        child: FocusTraversalGroup(
          policy: OrderedTraversalPolicy(),
          child: Semantics(
            explicitChildNodes: true,
            child: Stack(
              children: [
                for (var i = 0; i < works.length; i++)
                  Positioned.fill(
                    child: FocusTraversalOrder(
                      order: NumericFocusOrder(i.toDouble()),
                      child: Semantics(
                        sortKey: OrdinalSortKey(i.toDouble()),
                        child: RpTappableWidget(
                          url: _urlFor(context, works[i]),
                          semanticsLabel: _labelFor(works[i], locale),
                          onTap: () =>
                              HyperlinkHelper.open(_urlFor(context, works[i])),
                          showFocusRing: false,
                          // Stacked over the visual row: without this, on
                          // web the topmost proxy (the last project) would
                          // catch every click on the left-most card.
                          passThroughPointer: true,
                          onFocusChange: (focused) {
                            setState(() {
                              if (focused) {
                                _focusedIndex = i;
                              } else if (_focusedIndex == i) {
                                _focusedIndex = null;
                              }
                            });
                            if (focused) _revealCard(i, step, travelDistance);
                          },
                          builder: (_, __) => const SizedBox.expand(),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

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

    // The row scrubs across the full window, but starts and ends aligned
    // with the content column's inner edge (column margin + 48px padding),
    // like the text sections around it.
    final columnMargin = ((viewportSize.width - RpTheme.contentMaxWidth) / 2)
        .clamp(0.0, double.infinity);
    final edgePadding = isSmallScreen ? 16.0 : columnMargin + 48.0;
    final cardGap = isSmallScreen ? 16.0 : 28.0;
    final cardWidth = isSmallScreen
        ? (viewportSize.width * 0.84).clamp(240.0, 520.0)
        : (viewportSize.width * 0.56).clamp(420.0, 760.0);
    final padding = MediaQuery.paddingOf(context);
    // Unlike normal sections, this one stays pinned under the (translucent,
    // extendBodyBehindAppBar) AppBar for its whole scrub duration, so it
    // clears it explicitly. The body's top padding already includes the
    // AppBar (and the status bar), so it's the whole clearance.
    final topInset = padding.top;
    final titleTop =
        isSmallScreen ? topInset + 12.0 : viewportSize.height * 0.1;

    // Phones: the cards fill the band between the title and the progress
    // readout, instead of a fixed fraction of the screen floating in the
    // middle. Desktop keeps the centered row.
    final rowPadTop =
        isSmallScreen ? titleTop + _titleHeight : viewportSize.height * 0.1;
    final progressBottom =
        isSmallScreen ? padding.bottom + 20.0 : viewportSize.height * 0.08;
    const progressHeight = 20.0;
    final cardHeight = isSmallScreen
        ? (viewportSize.height -
                rowPadTop -
                progressBottom -
                progressHeight -
                RpTheme.spacingMedium)
            .clamp(240.0, viewportSize.height * 0.8)
        : viewportSize.height * 0.56;
    if (isSmallScreen) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _measureTitle());
    }

    final totalContentWidth =
        edgePadding * 2 + cardWidth * cardCount + cardGap * (cardCount - 1);
    final travelDistance = reduceMotion
        ? 0.0
        : (totalContentWidth - viewportSize.width).clamp(0.0, double.infinity);

    final cardRowTop = isSmallScreen
        ? rowPadTop
        : rowPadTop + (viewportSize.height - rowPadTop - cardHeight) / 2;

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
                      // The visual row is mouse-only: its cards get translated
                      // (and clipped) out of view, which would drop them from
                      // the semantics tree and strand keyboard focus
                      // off-screen. Keyboard and screen readers go through
                      // the proxies below instead.
                      ExcludeSemantics(
                        child: ExcludeFocus(
                          // Desktop: nudge the card row below the title.
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: rowPadTop,
                            ),
                            child: ClipRect(
                              child: OverflowBox(
                                alignment: isSmallScreen
                                    ? Alignment.topLeft
                                    : Alignment.centerLeft,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(width: edgePadding),
                                      for (var i = 0; i < cardCount; i++) ...[
                                        _GalleryCard(
                                          focused: _focusedIndex == i,
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
                          ),
                        ),
                      ),
                      Positioned(
                        left: edgePadding,
                        // Bounded on the right so a long title wraps on
                        // phones instead of running off-screen.
                        right: edgePadding,
                        top: titleTop,
                        child: KeyedSubtree(
                          key: _titleKey,
                          child: HomeSectionTitleWidget(
                            index: 2,
                            title: HomeSectionEnum.programs.title(context),
                            scrollController: widget.scrollController,
                          ),
                        ),
                      ),
                      Positioned(
                        right: edgePadding,
                        bottom: progressBottom,
                        // Visual-only position readout; each card is already
                        // announced on its own.
                        child: ExcludeSemantics(
                          child: _GalleryProgress(
                            progress: progress,
                            count: cardCount,
                          ),
                        ),
                      ),
                      _proxies(
                        left: edgePadding,
                        top: cardRowTop,
                        width: cardWidth,
                        height: cardHeight,
                        step: cardWidth + cardGap,
                        travelDistance: travelDistance,
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

/// `01 ━━━━──── 05`: one segment per card, filling in step with [progress].
class _GalleryProgress extends StatelessWidget {
  final double progress;
  final int count;

  const _GalleryProgress({required this.progress, required this.count});

  @override
  Widget build(BuildContext context) {
    final colors = context.rpColors;
    final style = RpTheme.labelStyle(colors.textColor).copyWith(fontSize: 12.0);
    final current = (progress * (count - 1)).round() + 1;
    // The first segment starts full, so the bar never reads as "empty"
    // while the first card is in view.
    final filled = (progress * (count - 1) + 1) / count;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          current.toString().padLeft(2, '0'),
          style: style.copyWith(color: colors.textHighlightColor),
        ),
        RpTheme.spacerSmall,
        for (var i = 0; i < count; i++) ...[
          if (i != 0) const SizedBox(width: 4.0),
          SizedBox(
            width: 24.0,
            height: 2.0,
            child: Stack(
              children: [
                Positioned.fill(child: ColoredBox(color: colors.hairlineColor)),
                FractionallySizedBox(
                  widthFactor: (filled * count - i).clamp(0.0, 1.0),
                  heightFactor: 1.0,
                  child: const ColoredBox(color: RpTheme.brandColor),
                ),
              ],
            ),
          ),
        ],
        RpTheme.spacerSmall,
        Text(count.toString().padLeft(2, '0'), style: style),
      ],
    );
  }
}

/// App Store link on Apple platforms when the work has one, else [WorkItem.url].
String _urlFor(BuildContext context, WorkItem work) {
  final platform = Theme.of(context).platform;
  final isApple =
      platform == TargetPlatform.iOS || platform == TargetPlatform.macOS;
  final hasAppleUrl = work.urlApple?.isNotEmpty ?? false;
  return isApple && hasAppleUrl ? work.urlApple! : work.url;
}

/// "Title. Tag, Tag. Description." — what a card announces as a link.
String _labelFor(WorkItem work, Locale locale) => '${work.titleFor(locale)}. '
    '${work.tag.split(' · ').join(', ')}. '
    '${work.descriptionFor(locale)}';

class _GalleryCard extends StatefulWidget {
  final WorkItem work;

  /// Its semantic proxy has focus: show the active look and a focus ring.
  final bool focused;
  final int index;
  final double width;
  final double height;
  final bool compact;

  const _GalleryCard({
    required this.work,
    required this.focused,
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

  /// Pointer position within the card, normalized to -1..1 on each axis;
  /// drives the image parallax and the floating "Open ↗" label.
  Offset _pointer = Offset.zero;
  Offset _pointerPx = Offset.zero;

  void _onHover(PointerHoverEvent event) {
    final p = event.localPosition;
    setState(() {
      _pointerPx = p;
      _pointer = Offset(
        (p.dx / widget.width) * 2 - 1,
        (p.dy / widget.height) * 2 - 1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final work = widget.work;
    final colors = context.rpColors;
    final locale = Localizations.localeOf(context);
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final duration =
        reduceMotion ? Duration.zero : const Duration(milliseconds: 260);
    final parallax =
        _hovering && !reduceMotion ? _pointer * -10.0 : Offset.zero;

    final url = _urlFor(context, work);

    // The MouseRegion only tracks the pointer for the parallax and the
    // floating label; focus, activation and semantics live in the tappable.
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      onHover: _onHover,
      child: RpTappableWidget(
        url: url,
        semanticsLabel: _labelFor(work, locale),
        onTap: () => HyperlinkHelper.open(url),
        borderRadius: BorderRadius.circular(16.0),
        builder: (context, highlighted) {
          // Hover or keyboard focus — the card's "active" look.
          final active = _hovering || highlighted || widget.focused;
          return AnimatedContainer(
            duration: duration,
            curve: Curves.easeOut,
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                if (active)
                  BoxShadow(
                    color: RpTheme.brandColor.withValues(alpha: 0.18),
                    blurRadius: 40.0,
                    spreadRadius: -8.0,
                  ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AnimatedScale(
                    duration: duration,
                    curve: Curves.easeOut,
                    scale: active ? 1.06 : 1.0,
                    child: TweenAnimationBuilder<Offset>(
                      duration: reduceMotion
                          ? Duration.zero
                          : const Duration(milliseconds: 120),
                      tween: Tween(end: parallax),
                      builder: (context, offset, child) =>
                          Transform.translate(offset: offset, child: child),
                      child: work.image == null
                          ? _GeneratedCover(index: widget.index)
                          : RpImageWidget(
                              asset: work.image!,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(
                          // Keyboard focus gets a solid, AA-contrast ring.
                          color: widget.focused
                              ? colors.accentTextColor
                              : active
                                  ? RpTheme.brandColor.withValues(alpha: 0.7)
                                  : colors.hairlineColor,
                          width: widget.focused ? 2.0 : 1.0,
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            colors.backgroundColor.withAlpha(225),
                            colors.backgroundColor.withAlpha(30),
                            colors.backgroundColor.withAlpha(60),
                            colors.backgroundColor.withAlpha(240),
                          ],
                          stops: const [0.0, 0.18, 0.55, 0.92],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20.0,
                    top: 16.0,
                    child: Text(
                      (widget.index + 1).toString().padLeft(2, '0'),
                      style: TextStyle(
                        fontFamily: RpTheme.fontFamilyMono,
                        fontSize: widget.compact ? 16.0 : 20.0,
                        fontWeight: FontWeight.w600,
                        color: colors.textHighlightColor,
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
                        Wrap(
                          spacing: 6.0,
                          runSpacing: 6.0,
                          children: [
                            for (final tag in work.tag.split(' · '))
                              _TagChip(label: tag),
                          ],
                        ),
                        RpTheme.spacerSmall,
                        Text(
                          work.titleFor(locale),
                          style: RpTheme.headingStyle(
                            colors.textHighlightColor,
                            fontSize: widget.compact ? 19.0 : 26.0,
                          ),
                        ),
                        RpTheme.spacerSmallX,
                        Text(
                          work.descriptionFor(locale),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: colors.textColor,
                            fontSize: widget.compact ? 12.5 : 14.0,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!widget.compact)
                    AnimatedPositioned(
                      duration: reduceMotion
                          ? Duration.zero
                          : const Duration(milliseconds: 90),
                      left: _pointerPx.dx + 14.0,
                      top: _pointerPx.dy + 14.0,
                      child: IgnorePointer(
                        child: AnimatedOpacity(
                          duration: duration,
                          opacity: _hovering ? 1.0 : 0.0,
                          child: _OpenLabel(),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;

  const _TagChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = context.rpColors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
      decoration: BoxDecoration(
        color: colors.backgroundColor.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(999.0),
        border: Border.all(color: colors.hairlineColor),
      ),
      child: Text(
        label.toUpperCase(),
        style: RpTheme.labelStyle(colors.textHighlightColor)
            .copyWith(fontSize: 10.0, letterSpacing: 1.2),
      ),
    );
  }
}

class _OpenLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: RpTheme.brandColor,
        borderRadius: BorderRadius.circular(999.0),
      ),
      child: Text(
        '${AppLocalizations.of(context)!.openLabel} ↗'.toUpperCase(),
        style: RpTheme.labelStyle(RpTheme.whiteColor)
            .copyWith(fontSize: 11.0, letterSpacing: 1.4),
      ),
    );
  }
}

/// Cover for cards without a screenshot: the brand glow over a dot grid,
/// with the site logo — echoing the page's own ambient background.
class _GeneratedCover extends StatelessWidget {
  final int index;

  const _GeneratedCover({required this.index});

  @override
  Widget build(BuildContext context) {
    final colors = context.rpColors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceColor,
        gradient: RadialGradient(
          center: const Alignment(0.6, -0.4),
          radius: 1.1,
          colors: [
            RpTheme.brandColor.withValues(alpha: 0.35),
            colors.surfaceColor,
          ],
        ),
      ),
      child: CustomPaint(
        painter: _DotGridPainter(colors.gridColor),
        child: const Center(child: RpLogoWidget(size: Size(120.0, 120.0))),
      ),
    );
  }
}

class _DotGridPainter extends CustomPainter {
  final Color color;

  _DotGridPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    const cell = 22.0;
    final paint = Paint()..color = color;
    for (var x = cell / 2; x < size.width; x += cell) {
      for (var y = cell / 2; y < size.height; y += cell) {
        canvas.drawCircle(Offset(x, y), 1.0, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DotGridPainter oldDelegate) => oldDelegate.color != color;
}

/// Lets pointer events fall through to whatever is underneath while keeping
/// the child's semantics and focus intact — unlike [IgnorePointer], which
/// also blocks semantic actions such as a screen reader's "activate".
class _PointerTransparent extends SingleChildRenderObjectWidget {
  const _PointerTransparent({required super.child});

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderPointerTransparent();
}

class _RenderPointerTransparent extends RenderProxyBox {
  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) => false;
}
