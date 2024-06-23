import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationService extends ChangeNotifier {
  String _location = "Santa Maria";
  String get location => _location;

  LocationService() {
    loadLocation();
  }

  void setLocation(String location) async {
    _location = location;
    notifyListeners();

  }

  Future<void> saveLocation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('location', _location);
  }

  Future<void> loadLocation() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedLocation = prefs.getString('location');
    if (savedLocation != null) {
      _location = savedLocation;
    } else {
      _location = "Fresno";
    }
    notifyListeners();
  }
}
