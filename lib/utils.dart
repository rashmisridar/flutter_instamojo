import 'package:flutter/material.dart';

import 'flutter_instamojo.dart';

bool isSuccessful(int statusCode) {
  return statusCode >= 200 && statusCode < 300;
}

StylingDetails _stylingDetail = StylingDetails(
    buttonStyle: ButtonStyle(
        buttonColor: Colors.amber,
        buttonTextStyle: TextStyle(
          color: Colors.black,
        )),
    listItemStyle: ListItemStyle(
        borderColor: Colors.grey,
        textStyle: TextStyle(color: Colors.black, fontSize: 18),
        subTextStyle: TextStyle(color: Colors.grey, fontSize: 14)),
    loaderColor: Colors.amber,
    inputFieldTextStyle: InputFieldTextStyle(
        textStyle: TextStyle(color: Colors.black, fontSize: 18),
        hintTextStyle: TextStyle(color: Colors.grey, fontSize: 14),
        labelTextStyle: TextStyle(color: Colors.grey, fontSize: 14)),
    alertStyle: AlertStyle(
      headingTextStyle: TextStyle(color: Colors.black, fontSize: 14),
      messageTextStyle: TextStyle(color: Colors.black, fontSize: 12),
      positiveButtonTextStyle: TextStyle(color: Colors.redAccent, fontSize: 10),
      negativeButtonTextStyle: TextStyle(color: Colors.amber, fontSize: 10),
    ));

StylingDetails get stylingDetails => _stylingDetail;

set stylingDetails(StylingDetails details) {
  if (details != null) {
    _stylingDetail = details;
  }
}
