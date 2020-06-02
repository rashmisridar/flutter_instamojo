import 'package:flutter/material.dart';
import 'package:flutter_instamojo/controllers/instamojo_controller.dart';
import 'package:flutter_instamojo/models/payment_option_model.dart';
import 'package:flutter_instamojo/repositories/instamojo_repository.dart';
import 'package:flutter_instamojo/widgets/card/card_layout.dart';
import 'package:flutter_instamojo/widgets/emi/emi_layout.dart';
import 'package:flutter_instamojo/widgets/net_banking/net_banking.dart';
import 'package:flutter_instamojo/widgets/trust_logo.dart';
import 'package:flutter_instamojo/widgets/upi/upi_layout.dart';
import 'package:flutter_instamojo/widgets/wallet/wallet.dart';

import '../utils.dart';

class PaymentModes extends StatelessWidget {
  final PaymentOptions paymentOptions;
  final Order order;
  final InstamojoRepository repository;
  final InstamojoPaymentStatusListener listener;
  final bool isConvenienceFeesApplied;

  const PaymentModes(
      {Key key,
      @required this.isConvenienceFeesApplied,
      this.paymentOptions,
      this.order,
      this.repository,
      this.listener})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool expanded = false;
    String amountTotal = isConvenienceFeesApplied
        ? order.totalOrderAmountDetails.orderWithConvinenceFees
        : order.amount;

    card({String name, Function onTap}) {
      return InkWell(
        child: Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: stylingDetails.listItemStyle.borderColor ??
                          Color(0XFFCCD1D9)))),
          margin: EdgeInsets.symmetric(horizontal: 16),
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text(
            name,
            style: stylingDetails.listItemStyle.textStyle,
          ),
        ),
        onTap: () {
          onTap();
        },
      );
    }

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(child: StatefulBuilder(
            builder: (ctx, setState) {
              return Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: stylingDetails.listItemStyle.borderColor ??
                                Color(0XFFCCD1D9)))),
                padding: EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Amount",
                            style: stylingDetails.listItemStyle.textStyle ??
                                TextStyle(color: Colors.black, fontSize: 18)),
                        Text("₹ " + order.amount,
                            style: stylingDetails.listItemStyle.textStyle ??
                                TextStyle(color: Colors.black, fontSize: 18))
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    if (isConvenienceFeesApplied)
                      InkWell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Icon(
                              expanded
                                  ? Icons.keyboard_arrow_down
                                  : Icons.chevron_right,
                              size: 20,
                              color: Colors.grey,
                            ),
                            Text("Convinience Fees",
                                style:
                                    stylingDetails.listItemStyle.subTextStyle ??
                                        TextStyle(color: Colors.grey)),
                            Spacer(),
                            Text(
                                "₹ " +
                                    order.totalOrderAmountDetails
                                        .totalConvinenceFees,
                                style:
                                    stylingDetails.listItemStyle.subTextStyle ??
                                        TextStyle(color: Colors.grey))
                          ],
                        ),
                        onTap: () {
                          setState(() {
                            expanded = !expanded;
                          });
                        },
                      ),
                    if (isConvenienceFeesApplied)
                      Visibility(
                          visible: expanded,
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                      width: 20,
                                      child: Center(
                                          child: Text("|",
                                              style: stylingDetails
                                                      .listItemStyle
                                                      .subTextStyle ??
                                                  TextStyle(
                                                      color: Colors.grey)))),
                                  Text("Fees",
                                      style: stylingDetails
                                              .listItemStyle.subTextStyle ??
                                          TextStyle(color: Colors.grey)),
                                  Spacer(),
                                  Text(
                                      "₹ " +
                                          order.totalOrderAmountDetails
                                              .convinenceFees,
                                      style: stylingDetails
                                              .listItemStyle.subTextStyle ??
                                          TextStyle(color: Colors.grey))
                                ],
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                      width: 20,
                                      child: Center(
                                          child: Text("|",
                                              style: stylingDetails
                                                      .listItemStyle
                                                      .subTextStyle ??
                                                  TextStyle(
                                                      color: Colors.grey)))),
                                  Text(
                                      "GST @ ${double.parse(order.totalOrderAmountDetails.getGSTPercent).floor()}%",
                                      style: stylingDetails
                                              .listItemStyle.subTextStyle ??
                                          TextStyle(color: Colors.grey)),
                                  Spacer(),
                                  Text(
                                      "₹ " +
                                          order.totalOrderAmountDetails.gstFees,
                                      style: stylingDetails
                                              .listItemStyle.subTextStyle ??
                                          TextStyle(color: Colors.grey))
                                ],
                              ),
                            ],
                          )),
                    if (isConvenienceFeesApplied)
                      SizedBox(
                        height: 16,
                      ),
                    if (isConvenienceFeesApplied)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Total",
                            style: stylingDetails.listItemStyle.subTextStyle ??
                                TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                              "₹ " +
                                  order.totalOrderAmountDetails
                                      .orderWithConvinenceFees,
                              style:
                                  stylingDetails.listItemStyle.subTextStyle ??
                                      TextStyle(fontWeight: FontWeight.bold))
                        ],
                      ),
                  ],
                ),
              );
            },
          )),
          SingleChildScrollView(
            child: Container(
                width: double.maxFinite,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //debit card
                    if (paymentOptions.cardOptions != null)
                      card(
                          name: "Debit Card",
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => CardLayout(
                                        listener: listener,
                                        repository: repository,
                                        title: "Debit Card",
                                        amount: amountTotal,
                                        cardOptions:
                                            paymentOptions.cardOptions)));
                          }),

                    // net banking
                    if (paymentOptions.netbankingOptions != null)
                      card(
                          name: "Net banking",
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => NetBanking(
                                        listener: listener,
                                        repository: repository,
                                        title: "Net Banking",
                                        amount: amountTotal,
                                        netBankingOptions:
                                            paymentOptions.netbankingOptions)));
                          }),

                    // credit card
                    if (paymentOptions.cardOptions != null)
                      card(
                          name: "Credit Card",
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => CardLayout(
                                        listener: listener,
                                        repository: repository,
                                        title: "Credit Card",
                                        amount: amountTotal,
                                        cardOptions:
                                            paymentOptions.cardOptions)));
                          }),

                    //emi
                    if (paymentOptions.emiOptions != null)
                      card(
                          name: "EMI",
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => EmiLayout(
                                        listener: listener,
                                        repository: repository,
                                        title: "EMI",
                                        amount: amountTotal,
                                        emiOptions:
                                            paymentOptions.emiOptions)));
                          }),

                    //wallet
                    if (paymentOptions.walletOptions != null)
                      card(
                          name: "Wallets",
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => Wallet(
                                        listener: listener,
                                        repository: repository,
                                        title: "Net Banking",
                                        amount: amountTotal,
                                        walletOptions:
                                            paymentOptions.walletOptions)));
                          }),

                    //upi
                    if (paymentOptions.upiOptions != null)
                      card(
                          name: "UPI",
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => UpiLayout(
                                        listener: listener,
                                        repository: repository,
                                        title: "Enter VPA",
                                        amount: amountTotal,
                                        upiOptions:
                                            paymentOptions.upiOptions)));
                          }),

                    TrustLogo()
                  ],
                )),
          )
        ]);
  }
}
