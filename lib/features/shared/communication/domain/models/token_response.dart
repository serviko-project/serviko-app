class TokenResponse {
  const TokenResponse({required this.token, required this.expiresIn});

  final String token;
  final int expiresIn;

  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(
      token: json['token'] as String? ?? '',
      expiresIn: json['expires_in'] as int? ?? json['expiresIn'] as int? ?? 0,
    );
  }
}
