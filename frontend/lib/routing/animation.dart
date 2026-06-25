import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Page<void> animationRouter(Widget page, GoRouterState state) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}
