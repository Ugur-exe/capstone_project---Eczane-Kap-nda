class PackageModel {
  String isim;
  String adres;
  String ilce;
  String telefon;
  String adresTarifi;

  PackageModel({
    required this.isim,
    required this.adres,
    required this.ilce,
    required this.telefon,
    required this.adresTarifi,
  });

  factory PackageModel.fromMap(Map<String, dynamic> map) {
    return PackageModel(
      isim: map['isim'] as String,
      adres: map['adres'] as String,
      ilce: map['ilce'] as String,
      telefon: map['telefon'] as String,
      adresTarifi: map['adresTarifi'] as String,
    );
  }
}
