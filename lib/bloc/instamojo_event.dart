import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instamojo/models/models.dart';

abstract class InstamojoEvent extends Equatable {
  const InstamojoEvent();
}

class CreateOrder extends InstamojoEvent {
  final CreateOrderBody createOrderBody;
  final String orderCreationUrl;
  CreateOrder({@required this.createOrderBody, this.orderCreationUrl});

  @override
  List<Object> get props => [];
}

class InitPayment extends InstamojoEvent {
  final String orderId;
  InitPayment({@required this.orderId});
  @override
  List<Object> get props => [];
}

class CollectCardPayment extends InstamojoEvent {
  final String url;
  final Map<String, String> cardPaymentRequest;
  CollectCardPayment({this.url, this.cardPaymentRequest});
  @override
  List<Object> get props => [];
}

class SearchBankEvent extends InstamojoEvent {
  final List<NetbankingOptionsChoice> banks;
  final String query;
  SearchBankEvent({this.banks, this.query});
  @override
  List<Object> get props => [];
}

class CollectUPIPaymentEvent extends InstamojoEvent {
  final String url;
  final String vpa;
  CollectUPIPaymentEvent({this.url, this.vpa});
  @override
  List<Object> get props => [];
}

class GetUPIStatusEvent extends InstamojoEvent {
  final String url;
  GetUPIStatusEvent({this.url});
  @override
  List<Object> get props => [];
}
