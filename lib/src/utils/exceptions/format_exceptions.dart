class WFormatExceptions implements Exception{
  final String message;

  const WFormatExceptions([this.message = 'Error desconocido, por favor verifica tus datos']);

  factory WFormatExceptions.fromMessage(String message){
    return WFormatExceptions(message);
  }

  String get formatedMessage => message;

  factory WFormatExceptions.fromCode(String code){
    switch (code){
      case 'user-not-found':
        return WFormatExceptions('Usuario no encontrado');
      case 'wrong-password':
        return WFormatExceptions('Contraseña incorrecta');
      case 'email-already-in-use':
        return WFormatExceptions('El correo ya está en uso');
      case 'invalid-email':
        return WFormatExceptions('Correo inválido');
      case 'operation-not-allowed':
        return WFormatExceptions('Operación no permitida');
      case 'weak-password':
        return WFormatExceptions('Contraseña débil');
      case 'user-disabled':
        return WFormatExceptions('Usuario deshabilitado');
      case 'too-many-requests':
        return WFormatExceptions('Demasiadas solicitudes');
      case 'network-request-failed':
        return WFormatExceptions('Error de red');
      default:
        return WFormatExceptions('Error desconocido');
    }
  }
}