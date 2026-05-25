import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business_logic/cubit/auth/auth_cubit.dart';
import '../../business_logic/cubit/auth/auth_state.dart';
import '../../responsive.dart';
import 'sign_in_screen.dart';
import '../widgets/my_button.dart';
import '../widgets/my_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  static const String screenRoute = "register_screen";

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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

  goToLoginScreen(BuildContext context) {
    Navigator.of(context).pushNamed(SignInScreen.screenRoute);
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
              if (state is AuthRegistered) {
                goToLoginScreen(context);
              }
              if (state is AuthError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
            builder: (context, state) {
              if (state is AuthLoading) {
                return loadingIndicator();
              }
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
                      text: "Enter Your Email",
                      isHidden: false,
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
                      text: "Register",
                      padding: Responsive.isMobile(context)
                          ? 10
                          : Responsive.isTablet(context)
                          ? 20
                          : 30,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          BlocProvider.of<AuthCubit>(context).signUp(
                            email: _email.text,
                            password: _password.text,
                          );
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Center loadingIndicator() => Center(child: CircularProgressIndicator());
}
