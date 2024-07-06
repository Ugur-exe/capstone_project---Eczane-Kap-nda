class PharmacyModel {
  final String name;
  final int id;
  final String address;
  final String phoneNumber;
  final String documentId;
  final double latitude;
  final double longitude;

  PharmacyModel(
      {required this.name,
      required this.id,
      required this.address,
      required this.phoneNumber,
      required this.documentId,
      required this.latitude,
      required this.longitude});

  factory PharmacyModel.fromMap(Map<String, dynamic> map) {
    return PharmacyModel(
        name: map['name'],
        id: map['id'],
        address: map['address'],
        phoneNumber: map['phoneNumber'],
        documentId: map['documentId'],
        latitude: map['latitude'],
        longitude: map['longitude']);
  }
}
