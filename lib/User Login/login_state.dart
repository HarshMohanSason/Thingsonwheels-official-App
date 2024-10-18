enum LoginStateEnum{
  idle,
  loggedIn,
  loggedOut,
  loading,
  error,
}

class LoginState{
  final LoginStateEnum state;
  final String? errorMessage;
  const LoginState({required this.state, this.errorMessage,});
}