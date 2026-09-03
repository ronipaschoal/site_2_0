import 'package:flutter/material.dart';
import 'package:ronip/helpers/hyperlink_helper.dart';
import 'package:ronip/ui/theme.dart';
import 'package:ronip/ui/widgets/image_widget.dart';

class WorkGalleryCardWidget extends StatefulWidget {
  final Map<String, String> work;
  final int index;
  final double width;
  final double height;
  final bool compact;

  const WorkGalleryCardWidget({
    super.key,
    required this.work,
    required this.index,
    required this.width,
    required this.height,
    required this.compact,
  });

  @override
  State<WorkGalleryCardWidget> createState() => _WorkGalleryCardWidgetState();
}

class _WorkGalleryCardWidgetState extends State<WorkGalleryCardWidget> {
  static const _borderRadius = BorderRadius.all(Radius.circular(16.0));

  void _open(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    final isMacOS = Theme.of(context).platform == TargetPlatform.macOS;
    final work = widget.work;
    final hasAppleUrl = work['urlApple']?.isNotEmpty ?? false;
    final url =
        (isIOS || isMacOS) && hasAppleUrl ? work['urlApple']! : work['url']!;
    HyperlinkHelper.targetBlank(url);
  }

  @override
  Widget build(BuildContext context) {
    final work = widget.work;
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final duration =
        reduceMotion ? Duration.zero : const Duration(milliseconds: 220);

    return GestureDetector(
      onTap: () => _open(context),
      child: AnimatedContainer(
        duration: duration,
        curve: Curves.easeOut,
        width: widget.width,
        height: widget.height,
        child: ClipRRect(
          borderRadius: _borderRadius,
          child: Stack(
            fit: StackFit.expand,
            children: [
              RpImageWidget(
                asset: work['image']!,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        RpTheme.backgroundColor.withAlpha(100),
                        RpTheme.backgroundColor.withAlpha(235),
                      ],
                      stops: const [0.45, 1.0],
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
                    color: RpTheme.textHighlightColor,
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
                    Text(
                      work['tag']!.toUpperCase(),
                      style: RpTheme.labelStyle,
                    ),
                    RpTheme.spacerSmall,
                    Text(
                      work['title']!,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: widget.compact ? 17.0 : 22.0,
                        color: RpTheme.textHighlightColor,
                      ),
                    ),
                    RpTheme.spacerSmallX,
                    Text(
                      work['description']!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: RpTheme.textColor,
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
    );
  }
}
