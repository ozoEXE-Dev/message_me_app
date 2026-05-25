abstract class AuthState {}

class AuthInitial extends AuthState{}

class AuthLoading extends AuthState{}

class AuthRegistered extends AuthState{}

class AuthVerificationEmailSent extends AuthState{}

class AuthError extends AuthState{
  String error;
  AuthError({required this.error});
}

class AuthResetPasswordEmailSent extends AuthState{}

class AuthSignedInWithGoogle extends AuthState{}

class AuthCompletedButProfileMissing extends AuthState{}

class AuthCompletedAndProfileCompleted extends AuthState{}