class ReceiptResponse {
  final String lastName;
  final String email;
  final String firstName;

  ReceiptResponse({this.lastName, this.email, this.firstName});

  static List<ReceiptResponse> fromJson(Map<String, dynamic> json) {
    List<dynamic> items = json["data"] as List<dynamic>;
    return items
        .map((e) => ReceiptResponse(
            email: e["email"],
            firstName: e["first_name"],
            lastName: e["last_name"]))
        .toList();
  }
}
