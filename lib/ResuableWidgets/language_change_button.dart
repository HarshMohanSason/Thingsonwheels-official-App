import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'language_state.dart'; // Import your language state class

class LanguageSwitcherWidget extends StatefulWidget {
  final Color color;
  final BuildContext buttonContext;
  const LanguageSwitcherWidget({super.key, required this.color, required this.buttonContext});

  @override
  State<LanguageSwitcherWidget> createState() => _LanguageSwitcherWidgetState();
}

class _LanguageSwitcherWidgetState extends State<LanguageSwitcherWidget> {
  @override
  Widget build(BuildContext context) {
    var langStateProvider = Provider.of<LanguageState>(widget.buttonContext);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (langStateProvider.currLang == "en") {
            langStateProvider.setCurrLang = "es";
            langStateProvider.setCurrLangCode = "ES";
          } else {
            langStateProvider.setCurrLang = "en";
            langStateProvider.setCurrLangCode = "US";
          }
          context.setLocale(Locale(langStateProvider.currLang, langStateProvider.currLangCode));
        });
      },
      child: Text(
        langStateProvider.currLang == "en" ? "Español?" : "English?",
        style:  TextStyle(
          color: widget.color,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }
}
