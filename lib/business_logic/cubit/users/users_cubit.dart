import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/app_user.dart';

import '../../../data/repository/auth_repository.dart';
import '../../../data/repository/users_repository.dart';
import 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  UsersRepository usersRepository;
  AuthRepository authRepository;
  UsersCubit(this.usersRepository, this.authRepository) : super(UsersInitial());

  Future createUserProfile(String displayName) async {
    emit(UsersLoading());
    if (await usersRepository.isDisplayNameUnique(displayName)) {
      await usersRepository.addUser(
        displayName,
        authRepository.getCurrentUserEmail(),
        authRepository.getCurrentUserUID(),
      );
      emit(UserDisplayNameUnique());
    } else {
      emit(UserDisplayNameNotUnique());
    }
    ;
  }

  Future getAllUsers() async{
    emit(UsersLoading());
   List<AppUser> users = await usersRepository.getAllUsers();
   emit(UsersLoaded(users));
  }
}
