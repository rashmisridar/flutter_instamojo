import 'package:flutter/material.dart';

class TrustLogo extends StatefulWidget {
  @override
  _TrustLogoState createState() => _TrustLogoState();
}

class _TrustLogoState extends State<TrustLogo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Image.asset(
        "assets/images/ic_trust.png",
        package: "flutter_instamojo",
      ),
    );
  }
}
