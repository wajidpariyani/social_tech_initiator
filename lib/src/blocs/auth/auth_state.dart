class AuthState {
  final bool isLogin;
  final bool isLoading;
  final bool isSuccess;
  final bool isFailure;
  final String? failureMessage; // Store error message

  AuthState({
    required this.isLogin,
    this.isLoading = false,
    this.isSuccess = false,
    this.isFailure = false,
    this.failureMessage,
  });

  AuthState copyWith({
    bool? isLogin,
    bool? isLoading,
    bool? isSuccess,
    bool? isFailure,
    String? failureMessage,
  }) {
    return AuthState(
      isLogin: isLogin ?? this.isLogin,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      failureMessage: failureMessage, // Update failure message
    );
  }
}
