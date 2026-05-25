import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business_logic/cubit/users/users_cubit.dart';
import '../../business_logic/cubit/users/users_state.dart';
import '../../data/models/app_user.dart';
import '../../data/repository/auth_repository.dart';
import '../../data/web_services/auth_service.dart';
import 'welcome_screen.dart';
import '../widgets/contact_card.dart';

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({super.key});
  static const String screenRoute = "people_screen";

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  @override
  void initState() {
    BlocProvider.of<UsersCubit>(context).getAllUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[800],
        title: Row(
          children: [
            Image.asset("assets/images/logo.png", height: 30),
            SizedBox(width: 10),
            Text("MessageMe", style: TextStyle(color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              AuthRepository(AuthService()).signOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                WelcomeScreen.screenRoute,
                (route) => false,
              );
            },
            icon: Icon(Icons.close, color: Colors.white),
          ),
        ],
      ),
      body: BlocBuilder<UsersCubit, UsersState>(
        builder: (context, state) {
          if (state is UsersLoaded) {
            AuthRepository authRepository = AuthRepository(AuthService());
            List<AppUser> users = state.users
                .where(
                  (element) =>
                      element.email != authRepository.getCurrentUserEmail(),
                )
                .toList();
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return ContactCard(
                  name: users[index].displayName!,
                  email: users[index].email!,
                );
              },
            );
          } else {
            return loadingIndicator();
          }
        },
      ),
    );
  }

  Center loadingIndicator() => Center(child: CircularProgressIndicator());
}
