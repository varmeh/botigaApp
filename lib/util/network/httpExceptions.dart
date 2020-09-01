class HttpServiceException implements Exception {
  final dynamic message;

  HttpServiceException(this.message);

  @override
  String toString() {
    return message;
  }
}

class BadRequestException extends HttpServiceException {
  BadRequestException() : super('Bad Request');
}

class UanuthorizedException extends HttpServiceException {
  UanuthorizedException() : super('Unauthorized');
}

class ServerErrorException extends HttpServiceException {
  ServerErrorException() : super('Server Error');
}
