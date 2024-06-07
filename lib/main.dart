import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storak/bank_details.dart';
import 'package:storak/home.dart';
import 'package:storak/kyc_details.dart';
import 'package:upgrader/upgrader.dart';

// import 'package:sharma_interior/sign_in.dart';
import 'buy_stock.dart';
import 'sign_in.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Upgrader.clearSavedSettings();
  // MediaQueryData windowData = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
  // windowData = windowData.copyWith(textScaleFactor: 1.0,);
  // SharedPreferences sp = await SharedPreferences.getInstance();
  // bool isLogin =
  // sp.getBool('is_login') != null ? sp.getBool("is_login")! : false;
  // bool isID = sp.getString('user_id') != null ? true : false;
  // OneSignal.shared.setAppId('cae3483f-464a-4ef9-b9e1-a772c3968ba9');
  // GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  // OneSignal.shared.setNotificationOpenedHandler((value) {
  //   navigatorKey.currentState!.push(
  //     MaterialPageRoute(
  //       builder: (context) => NotificationPage(),
  //     ),
  //   );
  // });
  SharedPreferences sp = await SharedPreferences.getInstance();
  bool isLogin = sp.getBool('login') ?? false;
  bool personal = sp.getBool('personal') ?? false;
  bool kyc = sp.getBool('kyc') ?? false;
  bool bank = sp.getBool('bank') ?? false;
  await Future.delayed(const Duration(seconds: 3));
  runApp(
    MaterialApp(
      builder: (context, child) {
        return MediaQuery(
          child: child!,
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        );
      },
      // navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: isLogin
          ? Home(
              b: true,
            )
          : kyc
              ? BankDetails()
              : personal
                  ? KYCDetails()
                  : SignIn(),
    ),
  );
}
