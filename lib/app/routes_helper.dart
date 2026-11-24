import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

sealed class RoutesHelper {
  /// [key] is shared by a page's language versions (`/` and `/en`), so
  /// switching language updates the page in place — no slide transition,
  /// and its state (scroll position, an open dialog) is kept.
  static CustomTransitionPage transitionPage(
    Widget page, {
    required LocalKey key,
  }) {
    return CustomTransitionPage(
      key: key,
      child: page,
      transitionsBuilder: (_, animation, __, child) {
        return SlideTransition(
          position: animation.drive(
            Tween(
              begin: const Offset(1.5, 0),
              end: Offset.zero,
            ),
          ),
          child: child,
        );
      },
    );
  }
}
