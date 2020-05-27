import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_instamojo/controllers/instamojo_controller.dart';

import 'loader.dart';

class Browser extends StatefulWidget {
  final String url;
  final InstamojoPaymentStatusListener listener;
  final String postData;
  const Browser({Key key, this.url, this.listener, this.postData})
      : super(key: key);

  @override
  _BrowserState createState() => _BrowserState();
}

class _BrowserState extends State<Browser> {
  InAppWebViewController webView;
  String url = "";
  int webProgress;
  bool showLoader;

  @override
  void initState() {
    webProgress = 0;
    showLoader = true;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text("Payment"),
        ),
        body: WillPopScope(
            onWillPop: () {
              _showDialog(context, widget.listener);
              return Future.value(false);
            },
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Expanded(
                      child: InAppWebView(
                          // initialUrl: widget.url,
                          initialHeaders: {},
                          initialOptions: InAppWebViewGroupOptions(
                            crossPlatform: InAppWebViewOptions(
                                debuggingEnabled: false,
                                disableContextMenu: true,
                                useShouldOverrideUrlLoading: false,
                                javaScriptEnabled: true),
                          ),
                          onWebViewCreated:
                              (InAppWebViewController controller) async {
                            webView = controller;
                            Future.delayed(Duration(milliseconds: 200), () {
                              if (widget.postData != null) {
                                controller.postUrl(
                                    url: widget.url,
                                    postData: Uint8List.fromList(
                                        widget.postData.codeUnits));
                              } else {
                                controller.loadUrl(url: widget.url);
                              }
                            });
                            print("onWebViewCreated");
                          },
                          onLoadStart:
                              (InAppWebViewController controller, String url) {
                            print("onLoadStart $url");
                            setState(() {
                              this.url = url;
                            });
                          },
                          onLoadStop: (InAppWebViewController controller,
                              String url) async {
                            print("onLoadStop $url");
                            setState(() {
                              this.url = url;
                            });
                            if (url.contains("payment_id") &&
                                url.contains("transaction_id")) {
                              String value = url.split("?")[1];
                              List<String> values = value.split("&");
                              Map<String, String> map = new Map();
                              for (int i = 0; i < values.length; i++) {
                                map[values[i].split("=")[0]] =
                                    values[i].split("=")[1];
                              }
                              if (map.containsKey("payment_status") &&
                                  map["payment_status"].toLowerCase() ==
                                      "failed") {
                                map["statusCode"] = "201";
                                map["response"] = "Payment Failed";
                              } else {
                                map["statusCode"] = "200";
                                map["response"] = "Payment Successful";
                              }

                              print(map.toString());
                              Navigator.pop(context);
                              Navigator.pop(context);
                              widget.listener.paymentStatus(status: map);
                            }
                          },
                          onProgressChanged: (InAppWebViewController controller,
                              int progress) {
                            // if (webProgress < 90)
                            setState(() {
                              webProgress = progress;
                              print(webProgress);
                            });
                          },
                          onUpdateVisitedHistory:
                              (InAppWebViewController controller, String url,
                                  bool androidIsReload) {
                            print("onUpdateVisitedHistory $url");
                            setState(() {
                              this.url = url;
                            });
                          }),
                    ),
                  ],
                ),
                Visibility(
                  visible: webProgress < 90,
                  child: Container(
                    width: double.maxFinite,
                    height: double.maxFinite,
                    color: Colors.white,
                    child: Loader(),
                  ),
                )
              ],
            )));
  }
}

_showDialog(
    BuildContext context, InstamojoPaymentStatusListener listener) async {
  englishButtons() {
    return <Widget>[
      FlatButton(
          child: Text(
            "Yes",
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
            listener.paymentStatus(status: {
              "statusCode": "201",
              "response": "Payment Cancelled By User"
            });
          }),
      FlatButton(
          child: Text(
            "No",
          ),
          onPressed: () {
            Navigator.pop(context);
          }),
    ];
  }

  String result = await showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      titleWidget() {
        return Text(
          "Alert",
        );
      }

      messageWidget() {
        return Text(
          "Are you sure you want to cancel this payment?",
        );
      }

      actionWidget() {
        return englishButtons();
      }

      return WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: Platform.isIOS
              ? CupertinoAlertDialog(
                  title: titleWidget(),
                  content: messageWidget(),
                  actions: actionWidget(),
                )
              : AlertDialog(
                  title: titleWidget(),
                  content: messageWidget(),
                  actions: actionWidget(),
                ));
    },
  );
  if (result == "failed") {}
}
