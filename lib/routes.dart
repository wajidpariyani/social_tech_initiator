import 'package:flutter/material.dart';
import 'package:social_tech_initiator/src/ui/screens/auth/auth_screen.dart';
import 'package:social_tech_initiator/src/ui/screens/posts/posts_screen.dart';

import 'main.dart';

class AppRoutes {
  static const String splashScreen = '/';
  static const String authScreen = '/auth';
  static const String postsScreen = '/posts';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case authScreen:
        return MaterialPageRoute(builder: (_) =>  AuthScreen());
      case postsScreen:
        return MaterialPageRoute(builder: (_) =>  PostsScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
