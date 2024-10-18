
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:easy_localization/easy_localization.dart';

void showToast(String msg, Color backgroundColor, Color textColor, String length) {
  Fluttertoast.showToast(
    msg: msg.tr(),
    toastLength: length == 'SHORT' ? Toast.LENGTH_SHORT : Toast.LENGTH_LONG,
    gravity: ToastGravity.CENTER,
    backgroundColor: backgroundColor,
    textColor: textColor,
    fontSize: 16.0,
  );
}