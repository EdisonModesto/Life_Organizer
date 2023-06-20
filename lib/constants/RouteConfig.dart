import 'package:go_router/go_router.dart';
import 'package:life_organizer/features/2.%20Home/HomeView.dart';
import 'package:life_organizer/main.dart';

import '../features/1. Authentication/AuthView.dart';

var routeConfig = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => AuthView(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => HomeView(),
    )
  ]
);