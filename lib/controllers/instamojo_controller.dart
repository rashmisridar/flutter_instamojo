import 'package:flutter/material.dart';

class InstamojoController {
  final InstamojoPaymentStatusListener listener;
  InstamojoController({@required this.listener});
}

abstract class InstamojoPaymentStatusListener {
  void paymentStatus({@required Map<String, String> status});
}
