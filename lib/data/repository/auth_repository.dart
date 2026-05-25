import '../web_services/auth_service.dart';

class AuthRepository {
  AuthService auth;

  AuthRepository(this.auth);

  Future signInWithEmailAndPassword (String email, String password) async{
    await  auth.signInWithEmailAndPassword(email, password);
  }
  Future signOut() async{
    await auth.signOut();
  }
  Future signInWithGoogle() async{
    await auth.signInWithGoogle();
  }

  Future signUp(String email, String password) async{
    await auth.signUp(email, password);
  }
  Future sendPasswordResetEmail(String email) async{
    await auth.sendPasswordResetEmail(email);
  }

  Future<bool> isUserVerified() async{
    return await auth.isUserVerified();
  }
   Future sendEmailVerification() async{
    await auth.sendEmailVerification();
   }
  
  Future<bool> isUserProfileCompleted() async{
    return await auth.isUserProfileCompleted();
  }

  String getCurrentUserUID(){
    return auth.getCurrentUserUID();
  }

  String getCurrentUserEmail(){
    return auth.getCurrentUserEmail();
  }
}