import 'package:flutter/material.dart';
import 'package:ronip/l10n/app_localizations.dart';
import 'package:ronip/pages/cv/cv_dialog_widget.dart';
import 'package:ronip/core/theme.dart';

/// Menu entry that opens the résumé as a dismissible overlay above the
/// current page (see [CvDialogWidget]), styled like the other nav links.
class CvMenuLinkWidget extends StatelessWidget {
  final GlobalKey<ScaffoldState> drawerKey;

  const CvMenuLinkWidget({
    super.key,
    required this.drawerKey,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        drawerKey.currentState?.closeDrawer();
        CvDialogWidget.show(context);
      },
      child: Text(
        AppLocalizations.of(context)!.cvHeading,
        style: TextStyle(color: context.rpColors.textColor),
      ),
    );
  }
}
