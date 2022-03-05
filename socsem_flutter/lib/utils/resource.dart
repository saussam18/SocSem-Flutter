// ignore_for_file: constant_identifier_names

class Resource {
  final Status status;
  Resource({required this.status});
}

enum Status { Success, Error, Cancelled }
enum LoginType {
  Google,
  Twitter,
}
