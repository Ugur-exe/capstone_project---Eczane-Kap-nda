import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressSettingModel with ChangeNotifier {
  GoogleMapController? _mapController;
  GoogleMapController get mapController => _mapController!;

  set mapController(GoogleMapController value) {
    _mapController = value;
    notifyListeners();
  }

  bool _isBottomSheetShown = false;
  bool get isBottomSheetShown => _isBottomSheetShown;

  set isBottomSheetShown(bool value) {
    _isBottomSheetShown = value;
    notifyListeners();
  }

  LatLng _markerLocation = const LatLng(37.5665, 37.0128);
  LatLng get markerLocation => _markerLocation;

  set markerLocation(LatLng value) {
    _markerLocation = value;
    notifyListeners();
  }

  String _selectedAddress = "";
  String get selectedAddress => _selectedAddress;

  set selectedAddress(String value) {
    _selectedAddress = value;
    notifyListeners();
  }

  Set<Marker> _markers = {};
  Set<Marker> get markers => _markers;

  set markers(Set<Marker> value) {
    _markers = value;
    notifyListeners();
  }

  String _bottomSheetTextAddress = '';
  String get bottomSheetTextAddress => _bottomSheetTextAddress;

  set bottomSheetTextAddress(String value) {
    _bottomSheetTextAddress = value;
    notifyListeners();
  }

  TextEditingController _addressController = TextEditingController();
  TextEditingController get addressController => _addressController;
  set addressController(TextEditingController value) {
    _addressController = value;
    notifyListeners();
  }

  TextEditingController _structure = TextEditingController();
  TextEditingController get structure => _structure;
  set structure(TextEditingController value) {
    _structure = value;
    notifyListeners();
  }

  TextEditingController _floor = TextEditingController();
  TextEditingController get floor => _floor;
  set floor(TextEditingController value) {
    _floor = value;
    notifyListeners();
  }

  TextEditingController _apartmentNumber = TextEditingController();
  TextEditingController get apartmentNumber => _apartmentNumber;
  set apartmentNumber(TextEditingController value) {
    _apartmentNumber = value;
    notifyListeners();
  }

  TextEditingController _forDirections = TextEditingController();
  TextEditingController get forDirections => _forDirections;
  set forDirections(TextEditingController value) {
    _forDirections = value;
    notifyListeners();
  }

  double _latitude = 0.0;
  double get latitude => _latitude;

  set latitude(double value) {
    _latitude = value;
    notifyListeners();
  }

  double _longitude = 0.0;
  double get longitude => _longitude;

  set longitude(double value) {
    _longitude = value;
    notifyListeners();
  }

  void getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    latitude = position.latitude;
    longitude = position.longitude;

    _selectedAddress =
        "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
    notifyListeners();
  }

  Future<void> findUserLocation() async {
    print('findUserLocation function started.');
    DateTime startTime = DateTime.now();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium);

    LatLng userLocation = LatLng(position.latitude, position.longitude);

    // Call the new function
    await getAddressAndMarkOnMap(userLocation, 'userLocation');

    DateTime endTime = DateTime.now();
    print(
        'findUserLocation function took ${endTime.difference(startTime).inSeconds} seconds to complete.');
  }

  Future<void> findAddress(LatLng location) async {
    // Call the new function
    await getAddressAndMarkOnMap(location, '1');
  }

  Future<void> getAddressAndMarkOnMap(LatLng location, String markerId) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(location.latitude, location.longitude);
    Placemark place = placemarks[0];

    bottomSheetTextAddress =
        " ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.country}";
    // Build the address string

    selectedAddress =
        "Mahalle: ${place.street}, Cad/Sokak: ${place.thoroughfare},No:${place.name},İlçe:${place.subAdministrativeArea},Şehir:${place.administrativeArea}, Ülke: ${place.country}";
    addressController.text =
        "${place.street}, ${place.thoroughfare}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.country}";
    floor.text = '${place.name}';

    print(selectedAddress);

    // Update the map to zoom in on the selected location
    mapController.animateCamera(
      CameraUpdate.newLatLngZoom(location, 18), // 18 is the zoom level
    );

    notifyListeners();
  }

  void addAddressToFirebase(String userId, List newAddresses) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).set(
        {'address': FieldValue.arrayUnion(newAddresses)},
        SetOptions(merge: true));
  }
}
