import 'package:cs308_ecommerce/models/products.dart';
import 'package:cs308_ecommerce/utils/color.dart';
import 'package:cs308_ecommerce/utils/dimension.dart';
import 'package:cs308_ecommerce/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cs308_ecommerce/productzoom.dart';
import '../models/products.dart';
import '../productzoom.dart';
import 'search.dart';
//import 'package:cs308_ecommerce/models/cart.dart';
import 'package:flutter_pay/flutter_pay.dart';

class payment extends StatefulWidget {
  @override
  _paymentState createState() => _paymentState();
}
class _paymentState extends State<payment> {
  FlutterPay flutterPay = FlutterPay();
  String result = "Result will be shown here";

  @override
  void initState() {
    super.initState();
  }

  void makePayment() async {
    Product product;
    List<PaymentItem> items = [
      PaymentItem(name: "Black T-shirt", price: 20.0),
      PaymentItem(name: "LOGO CANVAS SNEAKERS", price: 35.0),
      PaymentItem(name: "PAUL FLAKE AKM 542 CARGO PANTS", price: 40.0),
    ];

    flutterPay.setEnvironment(environment: PaymentEnvironment.Test);

    flutterPay.requestPayment(
      googleParameters: GoogleParameters(
        gatewayName: "example",
        gatewayMerchantId: "example_id",
      ),
      appleParameters:
      AppleParameters(merchantIdentifier: "merchant.flutterpay.example"),
      currencyCode: "USD",
      countryCode: "US",
      paymentItems: items,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
        backgroundColor: AppColors.primary,
      ),

      body: Container(
        padding: EdgeInsets.all(40.0),
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.payment_sharp, size: 50.0,semanticLabel: 'payment',),
                FlatButton(
                    child: Text("Click here to pay", style: TextStyle(fontSize: 30.0),),
                    onPressed: () {
                      makePayment();
                    })
              ]),
        ),
      ),
    );



  }
}
