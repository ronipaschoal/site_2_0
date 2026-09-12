import 'package:flutter/widgets.dart';

extension RpResponsive on BuildContext {
  static const _smallScreenBreakpoint = 600.0;

  bool get isSmallScreen =>
      MediaQuery.sizeOf(this).width < _smallScreenBreakpoint;
}
