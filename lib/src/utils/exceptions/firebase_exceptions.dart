class WFirebaseExceptions implements Exception{
  final String code;

  WFirebaseExceptions(this.code);

  String get message {
    switch (code){
      case 'user-not-found':
        return 'Usuario no encontrado';
      case 'wrong-password':
        return 'Contraseña incorrecta';
      case 'email-already-in-use':
        return 'El correo ya está en uso';
      case 'invalid-email':
        return 'Correo inválido';
      case 'operation-not-allowed':
        return 'Operación no permitida';
      case 'weak-password':
        return 'Contraseña débil';
      case 'user-disabled':
        return 'Usuario deshabilitado';
      case 'too-many-requests':
        return 'Demasiadas solicitudes';
      case 'network-request-failed':
        return 'Error de red';
      default:
        return 'Error desconocido';
    }
  }
}

