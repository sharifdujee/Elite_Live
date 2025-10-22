String? validateAddress(String? name) {
  if (name!.trim().isEmpty) {
    return "Address cannot be empty";
  }
  return null;
}