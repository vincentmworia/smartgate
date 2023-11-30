class LoggedInUser {
  String? username;
  String? password;

  LoggedInUser({
    this.username,
    this.password,
  });

  Map<String, String?> asMap() => {'username': username, 'password': password};
}
