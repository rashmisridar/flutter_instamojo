import 'package:flutter/material.dart';
import 'package:flutter_instamojo/controllers/instamojo_controller.dart';
import 'package:flutter_instamojo/models/payment_option_model.dart';
import 'package:flutter_instamojo/models/populate_card_request.dart';
import 'package:flutter_instamojo/repositories/respositories.dart';
import 'package:flutter_instamojo/widgets/card/card_layout.dart';
import 'package:flutter_instamojo/widgets/emi/emi_utils.dart';
import 'package:flutter_instamojo/widgets/trust_logo.dart';

class EmiLayout extends StatefulWidget {
  final String title;
  final Options emiOptions;
  final String amount;
  final InstamojoRepository repository;
  final InstamojoPaymentStatusListener listener;

  const EmiLayout(
      {Key key,
      this.title,
      this.emiOptions,
      this.amount,
      this.repository,
      this.listener})
      : super(key: key);
  @override
  _EmiLayoutState createState() => _EmiLayoutState();
}

class _EmiLayoutState extends State<EmiLayout> {
  List<DropdownMenuItem<EmiList>> _bankList;
  EmiList _selectedBank;

  @override
  void initState() {
    _bankList = buildDropDownMenuItems(widget.emiOptions.emiList);
    _selectedBank = _bankList[0].value;
    super.initState();
  }

  List<DropdownMenuItem<EmiList>> buildDropDownMenuItems(
      List<EmiList> bankList) {
    List<DropdownMenuItem<EmiList>> items = new List();
    for (EmiList bank in bankList) {
      items.add(DropdownMenuItem(
        value: bank,
        child: Text(bank.bankName),
      ));
    }
    return items;
  }

  onChangedDropDownItem(EmiList selectedBank) {
    setState(() {
      _selectedBank = selectedBank;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        widget.title,
      )),
      body: SingleChildScrollView(
          child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text("Select your credit card provider"),
            SizedBox(
              height: 8,
            ),
            Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                    color: Colors.black87.withOpacity(0.1),
                    border: Border.all(
                      color: Color(0XFFCCD1D9),
                    ),
                    borderRadius: BorderRadius.circular(2.0)),
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: DropdownButton(
                  items: _bankList,
                  value: _selectedBank,
                  onChanged: onChangedDropDownItem,
                  isExpanded: true,
                  underline: Container(),
                )),
            SizedBox(
              height: 16,
            ),
            Text("Select an EMI option"),
            SizedBox(
              height: 8,
            ),
            Column(
              children: _selectedBank.rates.map((value) {
                double emiAmount = getEmiAmount(
                    widget.amount, value.interest.toString(), value.tenure);
                String emiAmountString = "₹" +
                    emiAmount.toString() +
                    " x " +
                    value.tenure.toString() +
                    " Months";
                String finalAmountString = "Total ₹" +
                    getTotalAmount(emiAmount, value.tenure).toString() +
                    " @ " +
                    value.interest.toString() +
                    "% pa";

                return InkWell(
                  child: Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0XFFCCD1D9),
                          ),
                          borderRadius: BorderRadius.circular(2.0)),
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                      margin: EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                Text(
                                  emiAmountString,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  finalAmountString,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12),
                                )
                              ])),
                          Icon(Icons.chevron_right)
                        ],
                      )),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => CardLayout(
                                  amount: widget.amount,
                                  title: widget.title,
                                  cardOptions: widget.emiOptions,
                                  listener: widget.listener,
                                  repository: widget.repository,
                                  emiOptions: EmiOptions(
                                      emiTenure: value.tenure,
                                      emibankCode: _selectedBank.bankCode),
                                )));
                  },
                );
              }).toList(),
            ),
            TrustLogo()
          ],
        ),
      )),
    );
  }
}
