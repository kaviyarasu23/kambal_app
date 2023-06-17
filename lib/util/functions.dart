import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';


final NumberFormat numberFormat = NumberFormat("##,##,##,##,##0.00", "hi");

bool checkIsInfOrNullOrNanOrZero({String? value}) {
  if (value == null || value.isEmpty ||
      value.toLowerCase().startsWith('infi') ||
      value.toLowerCase().startsWith('nan') ||
      value.toLowerCase().startsWith('null') ||
      value.toLowerCase() == '0' ||
      value.toLowerCase() == '0.00' ||
      value.toLowerCase() == '0.0' ||
      value.toLowerCase() == '00.00') {
    return true;
  }
  return false;
}

bool isNumberNegative(String num) {
  return num.startsWith('-');
}

String formatCurrencyStandard({
  required String value,
  bool? isShowSign,
}) {
  String formatedCurrency = '';
  if (value.isNotEmpty) {
    if (value.indexOf(",") > 0) {
      value = value.replaceAll(',', '');
    }
    if (isShowSign != null && (!isShowSign) && value.startsWith("-")) {
      value = value.substring(1);
    }
    final double formatValue = double.parse(value);

    formatedCurrency = numberFormat.format(formatValue);
  }
  return formatedCurrency;
}

bool checkIsInfOrNullOrNan({String? value}) {
  if (value == null ||
      value.isEmpty ||
      value.toLowerCase().startsWith('infi') ||
      value.toLowerCase().startsWith('nan') ||
      value.toLowerCase().startsWith('null') ||
      value.toLowerCase() == '0' ||
      value.toLowerCase() == '0.00' ||
      value.toLowerCase() == '0.0' ||
      value.toLowerCase() == '00.00') {
    return true;
  }
  return false;
}

bool isValidPanNumber({required String panNumber}) {
  log(
      "IS VALID PAN NUMBER ::: ${RegExp("[A-Z]{5}[0-9]{4}[A-Z]?").hasMatch(panNumber)}");
  return (!RegExp(r"^[A-Z]{5}[0-9]{4}[A-Z]+$").hasMatch(panNumber));
}

String getFormatedNumValue(
  String num, {
  bool showSign = true,
  required int afterPoint,
}) {
  num = (num == 'null' ||
          num.toUpperCase() == 'NA' ||
          num.toLowerCase().startsWith('inf') ||
          num.toLowerCase().startsWith('nan') ||
          num.toLowerCase().isEmpty)
      ? '0'
      : num;
  final bool isNeg = num.startsWith('-');
  final double val = double.parse(isNeg
      ? num.toString().replaceAll(',', '').substring(1)
      : num.toString().replaceAll(',', ''));

  if (val == 0) {
    return afterPoint == 0 ? "0" : "0.00";
  } else {
    return isNeg
        ? "-${val.toStringAsFixed(afterPoint)}"
        : showSign
            ? "+${val.toStringAsFixed(afterPoint)}"
            : val.toStringAsFixed(afterPoint);
  }
}

String convertCurrencyHumanRead({required String value}) {
  value = checkIsInfOrNullOrNanOrZero(value: value) ? '0.00' : value;
  return NumberFormat.compactCurrency(
    decimalDigits: 2,
    locale: 'en_IN',
    symbol: '',
  ).format(double.parse(value)).toString();
}
