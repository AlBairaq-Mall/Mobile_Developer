class AddressModel {
  final String id;

  final String title;

  final String city;

  final String district;

  final String street;

  final String phone;

  final bool isDefault;

  const AddressModel({
    required this.id,
    required this.title,
    required this.city,
    required this.district,
    required this.street,
    required this.phone,
    this.isDefault = false,
  });
}
