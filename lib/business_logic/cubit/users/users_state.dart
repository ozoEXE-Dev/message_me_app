import '../../../data/models/app_user.dart';

abstract class UsersState {}

class UsersInitial extends UsersState{}

class UsersLoading extends UsersState{}

class UsersLoaded extends UsersState{
  List<AppUser> users;
  UsersLoaded(this.users);
}

class UserDisplayNameNotUnique extends UsersState{}

class UserDisplayNameUnique extends UsersState{}