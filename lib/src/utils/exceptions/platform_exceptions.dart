class WPlatformExceptions implements Exception{
  final String code;

  WPlatformExceptions(this.code);

  String get message {
    switch (code) {
      case 'invalid-email':
        return 'El correo electrónico no es válido';
      case 'user-not-found':
        return 'El correo electrónico no está registrado';
      case 'wrong-password':
        return 'La contraseña es incorrecta';
      case 'user-disabled':
        return 'El usuario ha sido deshabilitado';
      case 'too-many-requests':
        return 'Demasiados intentos, intente más tarde';
      case 'operation-not-allowed':
        return 'Operación no permitida';
      case 'email-already-in-use':
        return 'El correo electrónico ya está en uso';
      case 'weak-password':
        return 'La contraseña es débil';
      case 'network-request-failed':
        return 'No tienes conexión a internet';
      default:
        return 'Ocurrió un error';
    }
  }
}