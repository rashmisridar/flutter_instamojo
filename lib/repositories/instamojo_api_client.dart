import 'dart:convert';

import 'package:flutter_instamojo/models/models.dart';
import 'package:flutter_instamojo/repositories/respositories.dart';
import 'package:http/http.dart' as http;

import '../flutter_instamojo.dart';
import '../utils.dart';

class InstamojoApiClient {
  // var _baseUrl = 'https://test.instamojo.com/';
  http.Client httpClient = http.Client();
  final Environment environment;
  final String _baseUrl;
  var mRequestParam = new Map<String, dynamic>();

  InstamojoApiClient({this.environment = Environment.TEST})
      : _baseUrl = environment == Environment.PRODUCTION ? LIVE_URL : TEST_URL;
  Future<PaymentOptionModel> createOrder(CreateOrderBody body,
      {String orderCreationUrl}) async {
    mRequestParam["purpose"] =body.purpose;
    mRequestParam["amount"] =body.amount;
    mRequestParam["phone"] =body.phone;
    mRequestParam["buyer_name"] =body.buyerName;
    mRequestParam["redirect_url"] =body.redirectUrl;
    mRequestParam["webhook"] =body.webhook;
    mRequestParam["email"] =body.email;
    final url = orderCreationUrl ?? DEFAULT_ORDER_CREATION_URL;
    final response = await this.httpClient.post(url,
        body: mRequestParam);
    if (response.statusCode != 200) {
      throw new Exception('error creating order');
    }
    final json = jsonDecode(response.body);
    print(json);
    var model = CreatedOrderModel.fromJson(json);
    return await fetchOrder(model.orderId);
  }

  Future<PaymentOptionModel> fetchOrder(String orderId) async {
    print("orderId $orderId");
    final response =
    await this.httpClient.get(getpaymentMethods(_baseUrl, orderId));

    if (response.statusCode != 200) {
      throw new Exception('error creating order');
    }

    final json = jsonDecode(response.body);
    print(json);
    return PaymentOptionModel.fromJson(json);
  }

  Future<String> getUPIStatus(String url) async {
    final response = await this.httpClient.get(url);

    if (response.statusCode != 200) {
      throw new Exception('error creating order');
    }

    final json = jsonDecode(response.body);
    print(json);
    return response.body;
  }

  Future<String> collectCardpayment(
      String url, Map<String, String> cardPaymentRequest) async {
    final response = await this.httpClient.post(url,
        body: cardPaymentRequest,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        encoding: Encoding.getByName("utf-8"));

    if (response.statusCode != 200) {
      throw new Exception('error creating order');
    }
    final json = jsonDecode(response.body);
    print(json);
    return response.body;
  }

  Future<String> collectUPIPayment(String url, String vpa) async {
    final response = await this.httpClient.post(url,
        body: {"virtual_address": vpa},
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        encoding: Encoding.getByName("utf-8"));

    String result = response.body;

    if (!isSuccessful(response.statusCode)) {
      throw new Exception('error creating order');
    } else if (response.statusCode == 400) {
      result = jsonEncode('{"statusCode" : 400}');
    }
    final json = jsonDecode(result);
    print(json);
    return result;
  }
}
