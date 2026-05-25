import 'package:flutter/material.dart';
import 'presentation/screens/people_screen.dart';
import 'presentation/screens/register_screen.dart';
import 'presentation/screens/sign_in_screen.dart';
import 'presentation/screens/user_information_screen.dart';
import 'presentation/screens/welcome_screen.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case WelcomeScreen.screenRoute:
        return MaterialPageRoute(
          builder: (_) => WelcomeScreen(),
        );
      case SignInScreen.screenRoute:
        return MaterialPageRoute(
          builder: (_) =>SignInScreen(),
        );

      case RegisterScreen.screenRoute:
        return MaterialPageRoute(
          builder: (_) => RegisterScreen(),
        );

      case PeopleScreen.screenRoute:
        return MaterialPageRoute(
          builder: (_) => PeopleScreen(),
          
        );

      case UserInformationScreen.screenRoute:
        return MaterialPageRoute(
          builder: (_) => UserInformationScreen(),
          
        );
    }
  }
}
