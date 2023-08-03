import 'package:flutter/material.dart';

class OrderConfirmationText extends StatelessWidget {
  const OrderConfirmationText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'ご注文を承りました。\n到着まで、今しばらくお待ちください。',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 14,
        color: Colors.white,
        textBaseline: TextBaseline.alphabetic,
      ),
    );
  }
}
