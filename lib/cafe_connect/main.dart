import 'package:cafe/cafe_connect/screens/order_lists/order_list.dart';
import 'package:cafe/cafe_connect/screens/order_screen/order_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'constants.dart';
import 'screens/home/home_screen.dart';
import 'package:device_preview/device_preview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    DevicePreview(
      enabled: !kReleaseMode, // Ensure that it is disabled in release mode
      builder: (context) => MyApp(), // Wrap your app
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: DevicePreview.locale(context), // Add the locale here
      builder: DevicePreview.appBuilder, // Add the builder here
      debugShowCheckedModeBanner: false,
      title: 'Coffee Order',
      theme: _buildThemeData(context),
      home: const HomeScreen(),
      routes: _buildRoutes(),
    );
  }

  ThemeData _buildThemeData(BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor: kBackgroundColor,
      primaryColor: kBackgroundColor,
      textTheme:
          Theme.of(context).textTheme.apply(bodyColor: kTextColor).copyWith(
                bodyMedium: const TextStyle(
                  color: kTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
                titleMedium: const TextStyle(color: kTextColor),
              ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  Map<String, WidgetBuilder> _buildRoutes() {
    return {
      '/order': (context) => const OrderPage(
            key: Key('order'),
            title: 'Coffee Order',
          ),
      '/orderList': (context) => const OrderListPage(),
    };
  }
}
