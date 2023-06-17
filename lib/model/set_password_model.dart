class ResetPasswordInput {
  ResetPasswordInput({
    this.userId,
    this.password,
  });

  final String? userId;
  final String? password;

  factory ResetPasswordInput.fromJson(Map<String, dynamic> json) =>
      ResetPasswordInput(
        userId: json["id"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "password": password,
      };
}