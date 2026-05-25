import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/cubit/users/users_cubit.dart';
import '../../business_logic/cubit/users/users_state.dart';
import '../../responsive.dart';
import '../widgets/my_button.dart';
import '../widgets/my_text_field.dart';
import 'people_screen.dart';

class UserInformationScreen extends StatefulWidget {
  const UserInformationScreen({super.key});

  static const String screenRoute = "user_information_screen";

  @override
  State<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _displayName = TextEditingController();

  @override
  void dispose() {
    _displayName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 1440),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: BlocConsumer<UsersCubit, UsersState>(
            listener: (context, state) {
              if (state is UserDisplayNameNotUnique) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "There is a user with this name. Please try another name",
                    ),
                  ),
                );
              }
              if (state is UserDisplayNameUnique) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  PeopleScreen.screenRoute,
                  (route) => false,
                );
              }
            },
            builder: (context, state) {
              if (state is UsersLoading) {
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Enter Your Display Name",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      MyTextField(
                        text: "Display Name",
                        isHidden: false,
                        contentPadding: Responsive.isMobile(context)
                            ? 10
                            : Responsive.isTablet(context)
                            ? 20
                            : 30,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your display name';
                          }
                          if (value.length < 2) {
                            return 'Display name must be at least 2 characters';
                          }
                          if (value.length > 30) {
                            return 'Display name must be less than 30 characters';
                          }
                          final regex = RegExp(r'^[a-zA-Z0-9]+$');
                           if (!regex.hasMatch(value)) {
                            return 'Only letters and numbers are allowed';
                          }
                          return null;
                        },
                        controller: _displayName,
                      ),
                      SizedBox(height: 30),
                      MyButton(
                        color: Colors.blue[800]!,
                        text: "Continue",
                        padding: Responsive.isMobile(context)
                            ? 10
                            : Responsive.isTablet(context)
                            ? 20
                            : 30,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            BlocProvider.of<UsersCubit>(context).createUserProfile(_displayName.text);
                          }
                        },
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
}

