// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:typed_data';
import 'package:intl/intl.dart' as k;

class DataConverter {
  static Uint8List? image(String base_64) {
    try {
      var im = base64.decode(base_64);
      return im;
    } catch (e) {
      return null;
    }
  }

  static String currencyConvert(double number) {
    final oCcy =
        k.NumberFormat.currency(locale: "fr_MA", symbol: " درهم", decimalDigits: 2);

    return oCcy.format(number);
  }

  static String numberConvert(double number) {
    var f = k.NumberFormat("###.0#", "en_US");
    return f.format(number);
  }
}