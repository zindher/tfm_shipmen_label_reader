class ResponseMessage {
  final bool hasError;
  final String message;
  final String extraData;

  ResponseMessage({
    required this.hasError,
    required this.message,
    required this.extraData,
  });

}