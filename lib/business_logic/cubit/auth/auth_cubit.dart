import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repository/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState>{
AuthRepository authRepository;
AuthCubit(this.authRepository) : super(AuthInitial());


Future<bool> _isUserProfileCompleted() async{
  return await authRepository.isUserProfileCompleted();
}

Future _sendEmailVerification() async{
  try{
    emit(AuthLoading());
    await authRepository.sendEmailVerification();
    emit(AuthVerificationEmailSent());
  }
  catch(e){
    emit(AuthError(error: e.toString()));
  }
}

Future login({required String email, required String password}) async{
  emit(AuthLoading());
  try{
   await authRepository.signInWithEmailAndPassword(email, password);
   bool isUserVerified = await authRepository.isUserVerified();
   if(isUserVerified){
      if(await _isUserProfileCompleted()){
        emit(AuthCompletedAndProfileCompleted());
      }
      else{
        emit(AuthCompletedButProfileMissing());
      }
   }
   else{
    _sendEmailVerification();
   }
  }
  on FirebaseAuthException catch(e){
    if (e.code == "invalid-credential"){
      emit(AuthError(error: "Invalid Credentials"));
    }
    else{
    emit(AuthError(error: e.toString()));
    }
  }
}

Future signUp({required String email, required String password}) async{
  emit(AuthLoading());
  try{
    await authRepository.signUp(email, password);
    emit(AuthRegistered());
  }
  on FirebaseAuthException catch (e) {
    if(e.code == "weak-password"){
      emit(AuthError(error: "Weak Password"));
      return;
    }
    else if (e.code == "email-already-in-use"){
      emit(AuthError(error: "Email Already In Use"));
      return;
    }

    emit(AuthError(error: e.toString()));
  }}

Future signInWithGoogle() async{
    try{
      emit(AuthLoading());
      await authRepository.signInWithGoogle();
      if(await _isUserProfileCompleted()){
        emit(AuthCompletedAndProfileCompleted());
      }
      else{
        emit(AuthCompletedButProfileMissing());
      }
    }
    catch(e){
      emit(AuthError(error: e.toString()));
    }
}
Future sendPasswordResetEmail({required String email}) async{
  try{
    emit(AuthLoading());
    await authRepository.sendPasswordResetEmail(email);
    emit(AuthResetPasswordEmailSent());
  }
  catch(e){
    emit(AuthError(error: e.toString()));
  }
}



}
