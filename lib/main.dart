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
            apiKey: "AIzaSyDkkzxDOJpeOprRCtj3Jk6lz09FBMmc4ig",
            authDomain: "messageme-f64d4.firebaseapp.com",
            projectId: "messageme-f64d4",
            storageBucket: "messageme-f64d4.firebasestorage.app",
            messagingSenderId: "569758046497",
            appId: "1:569758046497:web:68b95ecf20c2805c3dc660",
            measurementId: "G-XQ2QMFJHNN",
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
