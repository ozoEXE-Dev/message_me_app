import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'business_logic/cubit/auth/auth_cubit.dart';
import 'business_logic/cubit/users/users_cubit.dart';
import 'data/repository/users_repository.dart';
import 'data/web_services/users_web_services.dart';
import 'app_router.dart';
import 'data/repository/auth_repository.dart';
import 'data/web_services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'presentation/screens/people_screen.dart';
import 'presentation/screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: kIsWeb
        ? const FirebaseOptions(
            apiKey: "your api key. i didn't put mine because of security",
            authDomain: "your authDomain key. i didn't put mine because of security",
            projectId: "your projectID. i didn't put mine because of security",
            storageBucket: "your storageBucket. i didn't put mine because of security",
            messagingSenderId: "your messagingSenderID. i didn't put mine because of security",
            appId: "your appID. i didn't put mine because of security",
            measurementId: "your measurmentID key. i didn't put mine because of security",
          )
        : null,
  );
  AuthRepository authRepository = AuthRepository(AuthService());

  bool isUserVerified = await authRepository.isUserVerified();
  bool isUserProfileCompleted = await authRepository.isUserProfileCompleted();
  runApp(
    MainApp(
      isUserVerified: isUserVerified,
      isUserProfileCompleted: isUserProfileCompleted,
    ),
  );
}

class MainApp extends StatelessWidget {
  bool isUserVerified;
  bool isUserProfileCompleted;
  late AuthCubit authCubit;
  late UsersCubit usersCubit;

  MainApp({
    super.key,
    required this.isUserVerified,
    required this.isUserProfileCompleted,
  }) {
    authCubit = AuthCubit(AuthRepository(AuthService()));
    usersCubit = UsersCubit(UsersRepository(UsersWebServices()), AuthRepository(AuthService()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => authCubit,
      child: BlocProvider(
        create: (context) => usersCubit,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateRoute: AppRouter().generateRoute,
          initialRoute: isUserVerified && isUserProfileCompleted
              ? PeopleScreen.screenRoute
              : WelcomeScreen.screenRoute,
        ),
      ),
    );
  }
}
