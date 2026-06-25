class ApiException implements Exception {
  ApiException({required this.message, required this.code});

  final String message;
  final int? code;

  @override
  String toString() {
    return message;
  }
}
