import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business_logic/cubit/auth/auth_cubit.dart';
import '../../business_logic/cubit/auth/auth_state.dart';
import '../../responsive.dart';
import 'people_screen.dart';
import 'user_information_screen.dart';
import '../widgets/my_button.dart';
import '../widgets/my_text_field.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  static const String screenRoute = "sign_in_screen";

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void goToUserInformationScreen(BuildContext context){
    Navigator.of(context).pushNamedAndRemoveUntil(UserInformationScreen.screenRoute, (route)=>false);
  }

  void goToPeopleScreen(BuildContext context){
    Navigator.of(context).pushNamedAndRemoveUntil(PeopleScreen.screenRoute, (route)=>false);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 1440),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthResetPasswordEmailSent) {
                showTextSnackBar("Reset password email is sent");
              }
              if (state is AuthVerificationEmailSent) {
                showTextSnackBar("Verification email is sent");
              }
              if(state is AuthError){
                showTextSnackBar(state.error);
              }
              if (state is AuthCompletedButProfileMissing) {
                goToUserInformationScreen(context);
              }

              if(state is AuthCompletedAndProfileCompleted){
                goToPeopleScreen(context);
              }
            
            },
            builder: (context, state) {
              if (state is AuthLoading) {
                return loadingIndicator();
              } else {
                return Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: 180,
                        child: Image.asset("assets/images/logo.png"),
                      ),
                      SizedBox(height: 40),
                      MyTextField(
                        isHidden: false,
                        text: "Enter Your Email",
                        contentPadding: Responsive.isMobile(context)
                            ? 10
                            : Responsive.isTablet(context)
                            ? 20
                            : 30,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }

                          final emailRegex = RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          );

                          if (!emailRegex.hasMatch(value)) {
                            return 'Enter a valid email';
                          }

                          return null;
                        },
                        controller: _email,
                      ),
                      SizedBox(height: 10),
                      MyTextField(
                        isHidden: true,
                        text: "Enter Your Password",
                        contentPadding: Responsive.isMobile(context)
                            ? 10
                            : Responsive.isTablet(context)
                            ? 20
                            : 30,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                        },
                        controller: _password,
                      ),
                      SizedBox(height: 10),
                      MyButton(
                        color: Colors.blue[800]!,
                        text: "Sign in",
                        padding: Responsive.isMobile(context)
                            ? 10
                            : Responsive.isTablet(context)
                            ? 20
                            : 30,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            BlocProvider.of<AuthCubit>(context).login(
                              email: _email.text,
                              password: _password.text,
                            );
                          }
                        },
                      ),
                      Container(
                        alignment: Alignment.topRight,
                        child: TextButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              BlocProvider.of<AuthCubit>(context).sendPasswordResetEmail(email: _email.text);
                            }
                          },
                          child: Text(
                            "Forgot password?",
                            style: TextStyle(color: Colors.blue[900]),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Center loadingIndicator() => Center(child: CircularProgressIndicator());
 void showTextSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}
