import 'package:flutter/material.dart';
import 'package:flutter_instamojo/controllers/instamojo_controller.dart';
import 'package:flutter_instamojo/models/payment_option_model.dart';
import 'package:flutter_instamojo/repositories/instamojo_repository.dart';

import '../../utils.dart';
import '../browser.dart';
import '../trust_logo.dart';

class Wallet extends StatefulWidget {
  final String title;
  final WalletOptions walletOptions;
  final String amount;
  final InstamojoRepository repository;
  final InstamojoPaymentStatusListener listener;

  const Wallet(
      {Key key,
      this.title,
      this.walletOptions,
      this.amount,
      this.repository,
      this.listener})
      : super(key: key);
  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: _buildList(),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      itemCount: widget.walletOptions.choices.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index < widget.walletOptions.choices.length)
          return InkWell(
            child: Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: stylingDetails.listItemStyle.borderColor))),
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                widget.walletOptions.choices[index].name,
                style: stylingDetails.listItemStyle.textStyle,
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) => Browser(
                            listener: widget.listener,
                            url: widget.walletOptions.submissionUrl,
                            postData: "wallet_id=" +
                                widget.walletOptions.choices[index].id
                                    .toString(),
                          )));
            },
          );
        else
          return TrustLogo();
      },
    );
  }
}
