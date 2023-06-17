class ErrorJson {
  final String errorMessage;
  final String stat;
  ErrorJson({
    this.errorMessage = "",
    this.stat = "",
  });
  Map<String, dynamic> toErrorJson() => {
        "emsg": errorMessage,
        "stat": stat,
      };
  Map<String, dynamic> toErrorFormatJson() => {
        "message": errorMessage,
        "status": stat,
      };
}
