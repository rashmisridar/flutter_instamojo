// To parse this JSON data, do
//
//     final createOrderBody = createOrderBodyFromJson(jsonString);

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

CreateOrderBody createOrderBodyFromJson(String str) =>
    CreateOrderBody.fromJson(json.decode(str));

String createOrderBodyToJson(CreateOrderBody data) =>
    json.encode(data);

class CreateOrderBody extends Equatable {
  String purpose;
  String amount;
  String phone;
  String buyerName;
  String redirectUrl;
  String webhook;
  String email;

  CreateOrderBody({
    @required this.purpose,
    @required this.amount,
    @required this.phone,
    @required this.buyerName,
    @required this.redirectUrl,
    @required this.webhook,
    @required this.email,

  });

  factory CreateOrderBody.fromJson(Map<String, dynamic> json) =>
      CreateOrderBody(
        purpose: json["purpose"] == null ? "" : json["purpose"],
        amount: json["amount"] == null ? null : json["amount"],
        phone: json["phone"] == null ? null : json["phone"],
        buyerName: json["buyerName"] == null ? null : json["buyerName"],
        redirectUrl: json["redirectUrl"] == null ? null : json["redirectUrl"],
        webhook: json["webhook"] == null ? null : json["webhook"],
        email: json["email"] == null ? null : json["email"],

      );

  Map<String, String> toJson(String env) => {
    "purpose": purpose == null ? null : purpose,
    "amount": amount == null ? null : amount,
    "phone": phone == null ? null : phone,
    "buyerName": buyerName == null ? null : buyerName,
    "redirectUrl": redirectUrl == null ? null : redirectUrl,
    "webhook": webhook == null ? null : webhook,
    "email": email == null ? null : email,

  };

  @override
  List<Object> get props => [purpose,amount,phone,buyerName,redirectUrl,webhook,email ];
}
