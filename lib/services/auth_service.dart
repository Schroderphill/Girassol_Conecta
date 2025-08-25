class AuthService {
  bool _isLoggedIn = false;

  Future<bool> login(String email, String password) async {
    // Simula chamada de API com atraso
    await Future.delayed(const Duration(seconds: 1));

    // Login mockado: altere depois para integração real
    if (email == "teste@girassol.com" && password == "123456") {
      _isLoggedIn = true;
      return true;
    }
    return false;
  }

  void logout() {
    _isLoggedIn = false;
  }

  bool get isLoggedIn => _isLoggedIn;
}
