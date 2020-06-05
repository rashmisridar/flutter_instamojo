import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instamojo/bloc/instamojo_bloc.dart';
import 'package:flutter_instamojo/bloc/instamojo_event.dart';
import 'package:flutter_instamojo/bloc/instamojo_state.dart';
import 'package:flutter_instamojo/controllers/instamojo_controller.dart';
import 'package:flutter_instamojo/models/payment_option_model.dart';
import 'package:flutter_instamojo/models/populate_card_request.dart';
import 'package:flutter_instamojo/repositories/instamojo_repository.dart';
import 'package:flutter_instamojo/widgets/browser.dart';
import 'package:flutter_instamojo/widgets/card/payment_card.dart';
import 'package:flutter_instamojo/widgets/trust_logo.dart';

import '../../utils.dart';
import '../loader.dart';
import 'input_formatters.dart';
import 'my_strings.dart';

class CardLayout extends StatefulWidget {
  final String title;
  final Options cardOptions;
  final String amount;
  final InstamojoRepository repository;
  final InstamojoPaymentStatusListener listener;
  final EmiOptions emiOptions;
  const CardLayout(
      {Key key,
      this.title,
      this.cardOptions,
      this.amount,
      this.repository,
      this.listener,
      this.emiOptions})
      : super(key: key);

  @override
  _CardLayoutState createState() => _CardLayoutState();
}

class _CardLayoutState extends State<CardLayout> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _formKey = new GlobalKey<FormState>();
  var numberController = new TextEditingController();
  var _paymentCard = PaymentCard();
  var _autoValidate = false;
  BuildContext _context;
  bool apiCalling;

  @override
  void initState() {
    super.initState();
    _paymentCard.type = CardType.Others;
    numberController.addListener(_getCardTypeFrmNumber);
    apiCalling = false;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle hintStyle = stylingDetails.inputFieldTextStyle.hintTextStyle;
    TextStyle labelStyle = stylingDetails.inputFieldTextStyle.labelTextStyle;
    TextStyle textStyle = stylingDetails.inputFieldTextStyle.labelTextStyle;
    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: new Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: new Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: new ListView(
                children: <Widget>[
                  new SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    style: textStyle,
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        suffixIcon: const Icon(
                          Icons.person,
                          size: 30.0,
                        ),
                        hintText: 'What name is written on card?',
                        labelText: 'Name on card',
                        hintStyle: hintStyle,

                        labelStyle: labelStyle),
                    onSaved: (String value) {
                      _paymentCard.name = value;
                    },
                    enabled: !apiCalling,
                    keyboardType: TextInputType.text,
                    validator: (String value) =>
                        value.isEmpty ? Strings.fieldReq : null,
                  ),
                  new SizedBox(
                    height: 10.0,
                  ),
                  new TextFormField(
                    style: textStyle,

                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                      new LengthLimitingTextInputFormatter(19),
                      new CardNumberInputFormatter()
                    ],
                    controller: numberController,
                    decoration: new InputDecoration(
                        border: const UnderlineInputBorder(),
                        suffixIcon: CardUtils.getCardIcon(_paymentCard.type),
                        hintText: 'What number is written on card?',
                        labelText: 'Number',
                        hintStyle: hintStyle,
                        labelStyle: labelStyle),
                    enabled: !apiCalling,
                    onSaved: (String value) {
                      print('onSaved = $value');
                      print('Num controller has = ${numberController.text}');
                      _paymentCard.number = CardUtils.getCleanedNumber(value);
                    },
                    validator: CardUtils.validateCardNum,
                  ),
                  new SizedBox(
                    height: 10.0,
                  ),
                  Row(children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                        style: textStyle,

                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly,
                          new LengthLimitingTextInputFormatter(4),
                        ],
                        decoration: new InputDecoration(
                            border: const UnderlineInputBorder(),
                            hintText: 'Number behind the card',
                            labelText: 'CVV',
                            hintStyle: hintStyle,
                            labelStyle: labelStyle),
                        validator: CardUtils.validateCVV,
                        keyboardType: TextInputType.number,
                        enabled: !apiCalling,
                        onSaved: (value) {
                          _paymentCard.cvv = int.parse(value);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 16.0,
                    ),
                    Flexible(
                        child: TextFormField(
                          style: textStyle,
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly,
                        new LengthLimitingTextInputFormatter(4),
                        new CardMonthInputFormatter()
                      ],
                      decoration: new InputDecoration(
                          border: const UnderlineInputBorder(),
                          hintText: 'MM/YY',
                          labelText: 'Expiry Date',
                          hintStyle: hintStyle,
                          labelStyle: labelStyle),
                      validator: CardUtils.validateDate,
                      keyboardType: TextInputType.number,
                      enabled: !apiCalling,
                      onSaved: (value) {
                        List<int> expiryDate = CardUtils.getExpiryDate(value);
                        _paymentCard.month = expiryDate[0];
                        _paymentCard.year = expiryDate[1];
                      },
                    )),
                  ]),
                  SizedBox(
                    height: 50.0,
                  ),
                  new Container(
                    alignment: Alignment.center,
                    child: _getPayButton(widget.amount),
                  ),
                  SizedBox(
                    width: 16.0,
                  ),
                  TrustLogo()
                ],
              )),
        ));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    numberController.removeListener(_getCardTypeFrmNumber);
    numberController.dispose();
    super.dispose();
  }

  void _getCardTypeFrmNumber() {
    String input = CardUtils.getCleanedNumber(numberController.text);
    CardType cardType = CardUtils.getCardTypeFrmNumber(input);
    setState(() {
      this._paymentCard.type = cardType;
    });
  }

  void _validateInputs() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      setState(() {
        _autoValidate = true; // Start validating on every change.
      });
      _showInSnackBar('Please fix the errors in red before submitting.', null);
    } else {
      form.save();
      // Encrypt and send send payment details to payment gateway
      setState(() {
        apiCalling = true;
      });
      Map<String, String> cardPaymentRequest = populateCardRequest(
          merchandId: widget.cardOptions.submissionData.merchantId,
          orderId: widget.cardOptions.submissionData.orderId,
          card: _paymentCard,
          emiOptions: widget.emiOptions);
      BlocProvider.of<InstamojoBloc>(_context).add(CollectCardPayment(
          url: widget.cardOptions.submissionUrl,
          cardPaymentRequest: cardPaymentRequest));
    }
  }

  Widget _getPayButton(String amount) {
    return Container(
        height: 50,
        width: double.maxFinite,
        child: RaisedButton(
          onPressed: _validateInputs,
          color: stylingDetails.buttonStyle.buttonColor ??
              Theme.of(context).primaryColor ??
              Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
          ),
          textColor: Colors.white,
          child: BlocProvider(
            create: (context) => InstamojoBloc(repository: widget.repository),
            child: BlocConsumer<InstamojoBloc, InstamojoState>(
              builder: (context, state) {
                _context = context;
                if (state is InstamojoLoading) {
                  return Loader();
                }
                return Text(
                  "Pay ₹ $amount".toUpperCase(),
                  style: stylingDetails.buttonStyle.buttonTextStyle,
                );
              },
              listenWhen: (prev, current) {
                if (current is InstamojoLoaded || current is InstamojoError)
                  return true;
                return false;
              },
              listener: (context, state) {
                setState(() {
                  apiCalling = false;
                });
                if (state is InstamojoLoaded) {
                  if (state.loadType == LoadType.CollectCardPayment) {
                    dynamic response = jsonDecode(state.collectCardRequest);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => Browser(
                                  listener: widget.listener,
                                  url: response['payment']['authentication']
                                      ['url'],
                                )));
                  }
                } else if (state is InstamojoError) {
                  _showInSnackBar(
                      'Failed to start the payment',
                      SnackBarAction(
                          label: "Retry",
                          onPressed: () {
                            Map<String, String> cardPaymentRequest =
                                populateCardRequest(
                                    merchandId: widget
                                        .cardOptions.submissionData.merchantId,
                                    orderId: widget
                                        .cardOptions.submissionData.orderId,
                                    card: _paymentCard);

                            BlocProvider.of<InstamojoBloc>(_context).add(
                                CollectCardPayment(
                                    url: widget.cardOptions.submissionUrl,
                                    cardPaymentRequest: cardPaymentRequest));
                          }));
                }
              },
            ),
          ),
        ));
  }

  void _showInSnackBar(String value, SnackBarAction action) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
      duration: new Duration(seconds: 3),
      action: action,
    ));
  }
}
