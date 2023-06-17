import '../api/core/api_links.dart';

class SessionCreateInvalidateInput {
  final String source;
  final String userId;
  SessionCreateInvalidateInput({
    this.source = ApiLinks.loginType,
    this.userId = "",
  });
  Map<String, dynamic> toJson() => {
        "source": source,
        "userId": userId,
      };
}