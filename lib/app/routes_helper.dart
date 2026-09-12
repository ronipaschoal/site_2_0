import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

sealed class RoutesHelper {
  static CustomTransitionPage transitionPage(Widget page) {
    return CustomTransitionPage(
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
