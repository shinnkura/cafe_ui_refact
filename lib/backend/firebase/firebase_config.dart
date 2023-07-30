import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyAWIES8x1hLjccW7QuDIvtL0J4nHt8YxfA",
            authDomain: "flutterflow-coffee-shop.firebaseapp.com",
            projectId: "flutterflow-coffee-shop",
            storageBucket: "flutterflow-coffee-shop.appspot.com",
            messagingSenderId: "12163141501",
            appId: "1:12163141501:web:11cf32ae93210a7addc614",
            measurementId: "G-L3Z9RZXJDP"));
  } else {
    await Firebase.initializeApp();
  }
}
