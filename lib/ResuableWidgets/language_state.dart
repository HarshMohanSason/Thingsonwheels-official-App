
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageState extends ChangeNotifier{

  LanguageState()
  {
    _loadLangState();
  }

  bool _isLangButtonPressed = false;
  bool get isLangButtonPressed => _isLangButtonPressed;
  set setLangButtonState(bool val)
  {
    _isLangButtonPressed = true;
    notifyListeners();
  }

  String _currLang = "en";
  String get currLang => _currLang;
  set setCurrLang(String val)
  {
    _currLang = val;
    _saveLangState();
    notifyListeners();
  }

  String _currLangCode = "US";
  String get currLangCode => _currLangCode;
  set setCurrLangCode(String val)
  {
    _currLangCode = val;
    _saveLangState();
    notifyListeners();
  }


  Future<void> _saveLangState() async
  {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setString('currLang', currLang);
    sharedPreferences.setString('currLangCode', currLangCode);
  }

  Future<void> _loadLangState() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _currLang = sharedPreferences.getString('currLang') ?? "en";
    _currLangCode = sharedPreferences.getString('currLangCode') ?? "US";
    notifyListeners();
  }


}