import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_instamojo/controllers/instamojo_controller.dart';
import 'package:flutter_instamojo/flutter_instamojo.dart';
import 'package:flutter_instamojo/models/create_order_body.dart';

import 'model/data_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
        color: Colors.black,
        routes: {},
        title: 'Styli',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            appBarTheme: AppBarTheme(brightness: Brightness.dark),
            primarySwatch: Colors.amber,
            canvasColor: Colors.white,
            backgroundColor: Colors.white,
            brightness: Brightness.light,
            cupertinoOverrideTheme: CupertinoThemeData(
              brightness: Brightness.light,
              scaffoldBackgroundColor: Colors.white,
              barBackgroundColor: Colors.white,
              primaryColor: Colors.amber,
            )),
        darkTheme: ThemeData(
            appBarTheme: AppBarTheme(brightness: Brightness.dark),
            primarySwatch: Colors.amber,
            canvasColor: Colors.black,
            brightness: Brightness.dark,
            cupertinoOverrideTheme: CupertinoThemeData(
              primaryColor: Colors.amber,
            )),
        home: PaymentScreen());
  }
}

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with SingleTickerProviderStateMixin {
  String _paymentResponse = 'Unknown';
  bool isLive, apiCalled;
  final _formKey = GlobalKey<FormState>();
  final _data = DataModel();
  bool _autoValidate = false;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    isLive = false;
    apiCalled = false;
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.5,
      duration: Duration(milliseconds: 500),
    )..repeat();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  startInstamojo() async {
    dynamic result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (ctx) => InstamojoScreen(
                  isLive: _data.isLive,
                  body: CreateOrderBody(
                      buyerName: _data.name,
                      buyerEmail: _data.email,
                      buyerPhone: _data.number,
                      amount: _data.amount,
                      description: _data.description),
                  orderCreationUrl:
                      "https://sample-sdk-server.instamojo.com", // The sample server of instamojo to create order id.
                )));

    setState(() {
      _paymentResponse = result.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instamojo Flutter'),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Builder(
                  builder: (context) => Form(
                      key: _formKey,
                      autovalidate: _autoValidate,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              initialValue: "Test Payments",
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(labelText: 'Name'),
                              // ignore: missing_return
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter the name';
                                }
                              },
                              onSaved: (val) =>
                                  setState(() => _data.name = val),
                            ),
                            TextFormField(
                                initialValue: "test@test.com",
                                keyboardType: TextInputType.emailAddress,
                                decoration:
                                    InputDecoration(labelText: 'Email Id'),
                                // ignore: missing_return
                                validator: validateEmail,
                                onSaved: (val) =>
                                    setState(() => _data.email = val)),
                            TextFormField(
                                initialValue: "1234567890",
                                keyboardType: TextInputType.phone,
                                maxLength: 10,
                                decoration:
                                    InputDecoration(labelText: 'Mobile Number'),
                                // ignore: missing_return
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter the phone number.';
                                  } else if (value.length < 10) {
                                    return "Please enter a valid phone number";
                                  }
                                },
                                onSaved: (val) =>
                                    setState(() => _data.number = val)),
                            TextFormField(
                                initialValue: "33",
                                keyboardType: TextInputType.number,
                                maxLength: 4,
                                decoration:
                                    InputDecoration(labelText: 'Amount'),
                                // ignore: missing_return
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter the amount.';
                                  }
                                },
                                onSaved: (val) =>
                                    setState(() => _data.amount = val)),
                            TextFormField(
                                initialValue: "test description",
                                keyboardType: TextInputType.text,
                                decoration:
                                    InputDecoration(labelText: 'Description'),
                                onSaved: (val) =>
                                    setState(() => _data.description = val)),
                            SwitchListTile(
                                title: Text(_data.isLive
                                    ? 'Live Account'
                                    : 'Test Account'),
                                value: _data.isLive,
                                onChanged: (bool val) =>
                                    setState(() => _data.isLive = val)),
                            Container(
                              height: 50,
                              child: RaisedButton(
                                  onPressed: () {
                                    final form = _formKey.currentState;
                                    if (form.validate()) {
                                      form.save();
                                      startInstamojo();
                                    } else {
                                      _autoValidate = true;
                                    }
                                  },
                                  child: apiCalled
                                      ? animation()
                                      : Text('Make Payment')),
                            ),
                          ])))),
          SizedBox(
            height: 20,
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text("Response: $_paymentResponse")),
          SizedBox(
            height: 30,
          ),
        ],
      )),
    );
  }

  Widget animation() {
    return AnimatedBuilder(
      animation:
          CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            _buildContainer(15 * _controller.value),
            _buildContainer(20 * _controller.value),
            _buildContainer(25 * _controller.value),
            _buildContainer(30 * _controller.value),
            _buildContainer(35 * _controller.value),
          ],
        );
      },
    );
  }

  Widget _buildContainer(double radius) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            Theme.of(context).primaryColor.withOpacity(1 - _controller.value) ??
                Colors.amber.withOpacity(1 - _controller.value),
      ),
    );
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }
}

class InstamojoScreen extends StatefulWidget {
  final CreateOrderBody body;
  final String orderCreationUrl;
  final bool isLive;

  const InstamojoScreen(
      {Key key, this.body, this.orderCreationUrl, this.isLive = false})
      : super(key: key);

  @override
  _InstamojoScreenState createState() => _InstamojoScreenState();
}

class _InstamojoScreenState extends State<InstamojoScreen>
    implements InstamojoPaymentStatusListener {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Instamojo Flutter'),
        ),
        body: SafeArea(
            child: Instamojo(
          isConvenienceFeesApplied: false,
          listener: this,
          environment:
              widget.isLive ? Environment.PRODUCTION : Environment.TEST,
          apiCallType: ApiCallType.createOrder(
              createOrderBody: widget.body,
              orderCreationUrl: widget.orderCreationUrl),
          stylingDetails: StylingDetails(
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
                positiveButtonTextStyle:
                    TextStyle(color: Colors.redAccent, fontSize: 10),
                negativeButtonTextStyle:
                    TextStyle(color: Colors.amber, fontSize: 10),
              )),
        )));
  }

  @override
  void paymentStatus({Map<String, String> status}) {
    Navigator.pop(context, status);
  }
}

print(String message) {
  debugPrint(message);
}
