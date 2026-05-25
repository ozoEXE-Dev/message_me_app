import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/cubit/auth/auth_cubit.dart';
import '../../business_logic/cubit/auth/auth_state.dart';
import 'user_information_screen.dart';
import '../../responsive.dart';
import 'people_screen.dart';
import 'register_screen.dart';
import 'sign_in_screen.dart';
import '../widgets/my_button.dart';
import 'package:flutter/foundation.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});
  static const String screenRoute = "welcome_screen";

  void goToPeopleScreen(BuildContext context) {
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(PeopleScreen.screenRoute, (route) => false);
  }

  void goToUserInformationScreen(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      UserInformationScreen.screenRoute,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 1440),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthCompletedAndProfileCompleted) {
                goToPeopleScreen(context);
              }
              if (state is AuthCompletedButProfileMissing) {
                goToUserInformationScreen(context);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    children: [
                      Container(
                        height: 180,
                        child: Image.asset("assets/images/logo.png"),
                      ),
                      Text(
                        "MessageMe",
                        style: TextStyle(
                          color: Colors.blue[900],
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  MyButton(
                    text: "Sign in",
                    onPressed: () {
                      Navigator.pushNamed(context, SignInScreen.screenRoute);
                    },
                    color: Colors.yellow[900]!,
                    padding: Responsive.isMobile(context)
                        ? 10
                        : Responsive.isTablet(context)
                        ? 20
                        : 30,
                  ),
                  SizedBox(height: 15),
                  MyButton(
                    text: "Register",
                    onPressed: () {
                      Navigator.pushNamed(context, RegisterScreen.screenRoute);
                    },
                    color: Colors.blue[900]!,
                    padding: Responsive.isMobile(context)
                        ? 10
                        : Responsive.isTablet(context)
                        ? 20
                        : 30,
                  ),
                  SizedBox(height: 15),
                  if (!kIsWeb)
                    MyButton(
                      text: "Sign in with google",
                      onPressed: () async {
                        BlocProvider.of<AuthCubit>(context).signInWithGoogle();
                      },
                      color: Colors.red[900]!,
                      padding: Responsive.isMobile(context)
                          ? 10
                          : Responsive.isTablet(context)
                          ? 20
                          : 30,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
