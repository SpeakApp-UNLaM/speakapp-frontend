class NoBackendConnectionException implements Exception {
  final String message;

  NoBackendConnectionException(
      [this.message = "No pudo establecer la conexión"]);

  @override
  String toString() => message;
}
