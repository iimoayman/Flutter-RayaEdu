import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:rayaedu/SignIn.dart';
import 'package:rayaedu/SplashScreen.dart';

import 'package:rayaedu/view/portalScafold.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',

  routes: [
    // ─────────────────────────────
    // SPLASH
    // ─────────────────────────────
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),

    // ─────────────────────────────
    // SIGN IN
    // ─────────────────────────────
    GoRoute(
      path: '/loading',
      name: 'loading',
      builder: (context, state) => const SignIn(),
    ),

    // ─────────────────────────────
    // PORTAL
    // ─────────────────────────────
    GoRoute(
      path: '/portal',
      name: 'portal',
      builder: (context, state) => const PortalScaffold(),
    ),
  ],
);