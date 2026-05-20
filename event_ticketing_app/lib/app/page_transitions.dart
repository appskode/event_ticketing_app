import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Faster route transitions; hero flights use the same duration.
const routeTransitionDuration = Duration(milliseconds: 200);
const routeReverseTransitionDuration = Duration(milliseconds: 160);

CustomTransitionPage<T> heroFriendlyPage<T>({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: key,
    transitionDuration: routeTransitionDuration,
    reverseTransitionDuration: routeReverseTransitionDuration,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(opacity: curved, child: child);
    },
  );
}
