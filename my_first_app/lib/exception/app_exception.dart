class AppException implements Exception {
  final String message;

  AppException(this.message);

  @override
  String toString() {
    return message;
  }
}

class InvalidInputException extends AppException {
  InvalidInputException(String message) : super(message);
}
