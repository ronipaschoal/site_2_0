import 'package:flutter/material.dart';
import 'package:ronip/helpers/hyperlink_helper.dart';
import 'package:ronip/helpers/media_query_helper.dart';
import 'package:ronip/model/home_menu_model.dart';
import 'package:ronip/pages/home/widgets/home_section_title_widget.dart';
import 'package:ronip/pages/home/widgets/home_section_widget.dart';
import 'package:ronip/ui/theme.dart';
import 'package:ronip/ui/widgets/image_widget.dart';

class WorkSection extends StatelessWidget {
  const WorkSection({super.key});

  static const _workList = [
    {
      'title': 'Roni Paschoal (V1)',
      'tag': 'Web · AngularJS',
      'description': 'Site anterior desenvolvido em AngularJS.',
      'url': 'https://angular.ronipaschoal.com.br/',
      'image': 'assets/images/photos/site-roni-paschoal-angularjs.png',
    },
    {
      'title': 'O Eremita do Iceberg, Flutter',
      'tag': 'Web · Flutter',
      'description':
          'Estudo de animações nativas e gerenciamento de estados Bloc/Cubit, em Flutter.',
      'url': 'https://eremitaflutter.ronipaschoal.com.br/',
      'image': 'assets/images/photos/flutter-o-eremita-do-iceberg.png',
    },
    {
      'title': 'Reali Plásticos',
      'tag': 'Web · PHP',
      'description':
          'Desenvolvimento em PHP, criação das imagens em 3d, UX e SEO do site institucional da empresa.',
      'url': 'https://www.realiplasticos.com.br/',
      'image': 'assets/images/photos/site-reali-plasticos.png',
    },
    {
      'title': 'Minha Comanda Eletrônica, App Flutter',
      'tag': 'App · Flutter',
      'description':
          'Participação na concepção e desenvolvimento em Flutter (Android, IOS, Cielo, Rede e PagSeguro), MVVM e Bloc/Cubit.',
      'url':
          'https://play.google.com/store/apps/details?id=com.totvs.thex.minhacomanda',
      'urlApple':
          'https://apps.apple.com/br/app/minha-comanda-eletr%C3%B4nica/id6474201107',
      'image': 'assets/images/photos/minha-comanda.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    final isMacOS = Theme.of(context).platform == TargetPlatform.macOS;

    return HomeSectionWidget(
      child: Column(
        children: [
          RpTheme.spacerLarge,
          if (!MediaQueryHelper(context).isSmallScreen())
            HomeSectionTitleWidget(
              title: HomeSectionEnum.programs.title(context),
            ),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: _workList.length,
            itemBuilder: (ctx, index) => _WorkCard(
              work: _workList[index],
              isIOS: isIOS,
              isMacOS: isMacOS,
            ),
            separatorBuilder: (_, __) => RpTheme.spacerLargeX,
          ),
        ],
      ),
    );
  }
}

class _WorkCard extends StatefulWidget {
  final Map<String, String> work;
  final bool isIOS;
  final bool isMacOS;

  const _WorkCard({
    required this.work,
    required this.isIOS,
    required this.isMacOS,
  });

  @override
  State<_WorkCard> createState() => _WorkCardState();
}

class _WorkCardState extends State<_WorkCard> {
  bool _hovering = false;

  void _open() {
    final work = widget.work;
    final hasAppleUrl = work['urlApple']?.isNotEmpty ?? false;
    final url = (widget.isIOS || widget.isMacOS) && hasAppleUrl
        ? work['urlApple']!
        : work['url']!;
    HyperlinkHelper.targetBlank(url);
  }

  @override
  Widget build(BuildContext context) {
    final work = widget.work;
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final duration =
        reduceMotion ? Duration.zero : const Duration(milliseconds: 220);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700.0),
        child: MouseRegion(
          onEnter: (_) => setState(() => _hovering = true),
          onExit: (_) => setState(() => _hovering = false),
          child: AnimatedContainer(
            duration: duration,
            curve: Curves.easeOut,
            transform: Matrix4.translationValues(
              0.0,
              _hovering ? -6.0 : 0.0,
              0.0,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: _hovering ? RpTheme.brandColor : RpTheme.hairlineColor,
                width: 1.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRect(
                  child: InkWell(
                    onTap: _open,
                    focusColor: RpTheme.brandColor.withAlpha(40),
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: AnimatedScale(
                      duration: duration,
                      curve: Curves.easeOut,
                      scale: _hovering ? 1.03 : 1.0,
                      child: RpImageWidget(asset: work['image']!),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectableText(
                        work['tag']!.toUpperCase(),
                        semanticsLabel: work['tag'],
                        style: RpTheme.labelStyle,
                      ),
                      RpTheme.spacerSmall,
                      SelectableText(
                        work['title']!,
                        semanticsLabel: work['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0,
                          color: RpTheme.textHighlightColor,
                        ),
                      ),
                      RpTheme.spacerSmallX,
                      SelectableText(
                        work['description']!,
                        semanticsLabel: work['description'],
                        style: const TextStyle(
                          color: RpTheme.textColor,
                          fontSize: 14.0,
                          height: 1.5,
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
    );
  }
}
