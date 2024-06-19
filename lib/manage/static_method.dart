import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../sign_in.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';
import 'app_url.dart';

class STM {
  void redirect2page(BuildContext context, Widget widget) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );
  }

  void replacePage(BuildContext context, Widget widget) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => widget,
      ),
    );
  }

  void back2Previous(BuildContext context) {
    Navigator.pop(context);
  }

  void displayToast(String string, gravity) {
    Fluttertoast.showToast(
        msg: string,
        toastLength: Toast.LENGTH_SHORT,
        gravity: gravity,
        textColor: Clr().black,
        backgroundColor: Clr().white);
  }

  openWeb(String url) async {
    await launchUrl(Uri.parse(url.toString()),
        mode: LaunchMode.externalNonBrowserApplication);
  }

  void finishAffinity(final BuildContext context, Widget widget) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => widget,
      ),
      (Route<dynamic> route) => false,
    );
  }

  void successDialog(context, message, widget) {
    AwesomeDialog(
            dismissOnBackKeyPress: false,
            dismissOnTouchOutside: false,
            context: context,
            dialogType: DialogType.SUCCES,
            animType: AnimType.SCALE,
            headerAnimationLoop: true,
            title: 'Success',
            desc: message,
            btnOkText: "OK",
            btnOkOnPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => widget),
              );
            },
            btnOkColor: Clr().successGreen)
        .show();
  }

  AwesomeDialog successWithButton(context, message, function) {
    return AwesomeDialog(
        dismissOnBackKeyPress: false,
        dismissOnTouchOutside: false,
        context: context,
        dialogType: DialogType.SUCCES,
        animType: AnimType.SCALE,
        headerAnimationLoop: true,
        title: 'Success',
        desc: message,
        btnOkText: "OK",
        btnOkOnPress: function,
        btnOkColor: Clr().successGreen);
  }

  void successDialogWithAffinity(
      BuildContext context, String message, Widget widget) {
    AwesomeDialog(
            dismissOnBackKeyPress: false,
            dismissOnTouchOutside: false,
            context: context,
            dialogType: DialogType.SUCCES,
            animType: AnimType.SCALE,
            headerAnimationLoop: true,
            title: 'Success',
            desc: message,
            btnOkText: "OK",
            btnOkOnPress: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => widget,
                ),
                (Route<dynamic> route) => false,
              );
            },
            btnOkColor: Clr().successGreen)
        .show();
  }

  void successDialogWithReplace(
      BuildContext context, String message, Widget widget) {
    AwesomeDialog(
            dismissOnBackKeyPress: false,
            dismissOnTouchOutside: false,
            context: context,
            dialogType: DialogType.SUCCES,
            animType: AnimType.SCALE,
            headerAnimationLoop: true,
            title: 'Success',
            desc: message,
            btnOkText: "OK",
            btnOkOnPress: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => widget,
                ),
              );
            },
            btnOkColor: Clr().successGreen)
        .show();
  }

  void errorDialog(BuildContext context, String message) {
    if (message.contains('Inactive')) {
      errorDialogWithAffinity(context, message, const SignIn());
    } else {
      AwesomeDialog(
              context: context,
              dismissOnBackKeyPress: false,
              dismissOnTouchOutside: false,
              dialogType: DialogType.ERROR,
              animType: AnimType.SCALE,
              headerAnimationLoop: true,
              title: 'Note',
              desc: message,
              btnOkText: "OK",
              btnOkOnPress: () {},
              btnOkColor: Clr().errorRed)
          .show();
    }
  }

  void errorDialogWithAffinity(
      BuildContext context, String message, Widget widget) {
    AwesomeDialog(
            dismissOnBackKeyPress: false,
            dismissOnTouchOutside: false,
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.SCALE,
            headerAnimationLoop: true,
            title: 'Error',
            desc: message,
            btnOkText: "OK",
            btnOkOnPress: () async {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => widget,
                ),
                (Route<dynamic> route) => false,
              );
              SharedPreferences sp = await SharedPreferences.getInstance();
              sp.clear();
            },
            btnOkColor: Clr().errorRed)
        .show();
  }

  void errorDialogWithReplace(
      BuildContext context, String message, Widget widget) {
    AwesomeDialog(
            dismissOnBackKeyPress: false,
            dismissOnTouchOutside: false,
            context: context,
            dialogType: DialogType.ERROR,
            animType: AnimType.SCALE,
            headerAnimationLoop: true,
            title: 'Note',
            desc: message,
            btnOkText: "OK",
            btnOkOnPress: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => widget,
                ),
              );
            },
            btnOkColor: Clr().errorRed)
        .show();
  }

  AwesomeDialog loadingDialog(BuildContext context, String title) {
    AwesomeDialog dialog = AwesomeDialog(
      width: 250,
      context: context,
      dismissOnBackKeyPress: false,
      dismissOnTouchOutside: false,
      dialogType: DialogType.NO_HEADER,
      animType: AnimType.SCALE,
      body: WillPopScope(
        onWillPop: () async {
          displayToast('Something went wrong try again.', ToastGravity.BOTTOM);
          return true;
        },
        child: Container(
          height: Dim().d160,
          padding: EdgeInsets.all(Dim().d16),
          decoration: BoxDecoration(
            color: Clr().white,
            borderRadius: BorderRadius.circular(Dim().d32),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(Dim().d12),
                child: SpinKitSquareCircle(
                  color: Clr().primaryColor,
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.all(Dim().d4),
              //   child:Lottie.asset('animation/ShrmaAnimation.json',height: 90,
              //       fit: BoxFit.cover),
              // ),
              // SizedBox(
              //   height: Dim().d16,
              // ),
              Text(
                title,
                style: Sty().mediumBoldText,
              ),
            ],
          ),
        ),
      ),
    );
    return dialog;
  }

  Widget sb({
    double? h,
    double? w,
  }) {
    return SizedBox(
      height: h,
      width: w,
    );
  }

  void alertDialog(context, message, widget) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        AlertDialog dialog = AlertDialog(
          title: Text(
            "Confirmation",
            style: Sty().largeText,
          ),
          content: Text(
            message,
            style: Sty().smallText,
          ),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {},
            ),
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
        return dialog;
      },
    );
  }

  AwesomeDialog modalDialog(context, widget, color) {
    AwesomeDialog dialog = AwesomeDialog(
      dialogBackgroundColor: color,
      context: context,
      dialogType: DialogType.NO_HEADER,
      animType: AnimType.SCALE,
      body: widget,
    );
    return dialog;
  }

  void mapDialog(BuildContext context, Widget widget) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.NO_HEADER,
      padding: EdgeInsets.zero,
      animType: AnimType.SCALE,
      body: widget,
      btnOkText: 'Done',
      btnOkColor: Clr().successGreen,
      btnOkOnPress: () {},
    ).show();
  }

  Widget setSVG(name, size, color) {
    return SvgPicture.asset(
      'assets/$name.svg',
      height: size,
      width: size,
      color: color,
    );
  }

  Widget emptyData(message) {
    return Center(
      child: Text(
        message,
        style: Sty().smallText.copyWith(
              color: Clr().primaryColor,
              fontSize: 18.0,
            ),
      ),
    );
  }

  List<BottomNavigationBarItem> getBottomList(index, b) {
    return [
      BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset(
            index == 0 ? "assets/home_fill.svg" : "assets/bn_home.svg",
            color: index == 0 ? Clr().primaryColor : Clr().white,
          ),
        ),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset(
            index == 1
                ? "assets/portfolio_fill.svg"
                : "assets/bn_portfolio.svg",
            color: index == 1 ? Clr().primaryColor : Clr().white,
          ),
        ),
        label: 'Portfolio',
      ),
      BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset(
            index == 2
                ? "assets/watchlist_fill.svg"
                : "assets/bn_watchlist.svg",
            color: index == 2 ? Clr().primaryColor : Clr().white,
          ),
        ),
        label: 'Watchlist',
      ),
      BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset(
            index == 3 ? "assets/orders_fill.svg" : "assets/bn_orders.svg",
            color: index == 3 ? Clr().primaryColor : Clr().white,
          ),
        ),
        label: 'Orders',
      ),
      BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset(
            index == 4 ? "assets/account_fill.svg" : "assets/bn_account.svg",
            color: index == 4 ? Clr().primaryColor : Clr().white,
          ),
        ),
        label: 'Account',
      ),
    ];
  }

  // List<BottomNavigationBarItem> getBottomList(index) {
  //   return [
  //     BottomNavigationBarItem(
  //       icon: SvgPicture.asset(
  //         "assets/bn_home.svg",
  //       ),
  //       label: 'Home',
  //     ),
  //     BottomNavigationBarItem(
  //       icon: SvgPicture.asset(
  //         "assets/bn_courses.svg",
  //       ),
  //       label: 'My Courses',
  //     ),
  //     BottomNavigationBarItem(
  //       icon: SvgPicture.asset(
  //         "assets/bn_profile.svg",
  //       ),
  //       label: 'My Profile',
  //     ),
  //   ];
  // }

  //Dialer
  Future<void> openDialer(String phoneNumber) async {
    Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(Uri.parse(launchUri.toString()));
  }

  //WhatsApp
  Future<void> openWhatsApp(String phoneNumber) async {
    if (Platform.isIOS) {
      await launchUrl(Uri.parse("whatsapp:wa.me/$phoneNumber"));
    } else {
      await launchUrl(Uri.parse("whatsapp:send?phone=$phoneNumber"));
    }
  }

  Future<bool> checkInternet(context, widget) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      internetAlert(context, widget);
      return false;
    }
  }

  internetAlert(context, widget) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.NO_HEADER,
      animType: AnimType.SCALE,
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      body: Padding(
        padding: EdgeInsets.all(Dim().d20),
        child: Column(
          children: [
            // SizedBox(child: Lottie.asset('assets/no_internet_alert.json')),
            Text(
              'Connection Error',
              style: Sty().largeText.copyWith(
                    color: Clr().primaryColor,
                    fontSize: 18.0,
                  ),
            ),
            SizedBox(
              height: Dim().d8,
            ),
            Text(
              'No Internet connection found.',
              style: Sty().smallText,
            ),
            SizedBox(
              height: Dim().d32,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: Sty().primaryButton,
                onPressed: () async {
                  var connectivityResult =
                      await (Connectivity().checkConnectivity());
                  if (connectivityResult == ConnectivityResult.mobile ||
                      connectivityResult == ConnectivityResult.wifi) {
                    Navigator.pop(context);
                    STM().replacePage(context, widget);
                  }
                },
                child: Text(
                  "Try Again",
                  style: Sty().largeText.copyWith(
                        color: Clr().white,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    ).show();
  }

  // Future<bool> checkInternet(context, widget) async {
  //   var connectivityResult = await (Connectivity().checkConnectivity());
  //   if (connectivityResult == ConnectivityResult.mobile) {
  //     return true;
  //   } else if (connectivityResult == ConnectivityResult.wifi) {
  //     return true;
  //   } else {
  //     internetAlert(context, widget);
  //     return false;
  //   }
  // }

  // internetAlert(context, widget) {
  //   AwesomeDialog(
  //     context: context,
  //     dialogType: DialogType.NO_HEADER,
  //     animType: AnimType.SCALE,
  //     dismissOnTouchOutside: false,
  //     dismissOnBackKeyPress: false,
  //     body: Padding(
  //       padding: EdgeInsets.all(Dim().d20),
  //       child: Column(
  //         children: [
  //           // SizedBox(child: Lottie.asset('assets/no_internet_alert.json')),
  //           Text(
  //             'Connection Error',
  //             style: Sty().largeText.copyWith(
  //                   color: Clr().primaryColor,
  //                   fontSize: 18.0,
  //                 ),
  //           ),
  //           SizedBox(
  //             height: Dim().d8,
  //           ),
  //           Text(
  //             'No Internet connection found.',
  //             style: Sty().smallText,
  //           ),
  //           SizedBox(
  //             height: Dim().d32,
  //           ),
  //           SizedBox(
  //             width: double.infinity,
  //             child: ElevatedButton(
  //               style: Sty().primaryButton,
  //               onPressed: () {
  //                 STM().checkInternet(context, widget).then((value) {
  //                   if (value) {
  //                     Navigator.pop(context);
  //                     STM().replacePage(context, widget);
  //                   }
  //                 });
  //               },
  //               child: Text(
  //                 "Try Again",
  //                 style: Sty().largeText.copyWith(
  //                       color: Clr().white,
  //                     ),
  //                 textAlign: TextAlign.center,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   ).show();
  // }

  String dateFormat(format, date) {
    return DateFormat(format).format(date).toString();
  }

  Future<dynamic> get(ctx, title, name) async {
    //Dialog
    AwesomeDialog dialog = STM().loadingDialog(ctx, title);
    dialog.show();
    Dio dio = Dio(
      BaseOptions(
        contentType: Headers.jsonContentType,
        responseType: ResponseType.plain,
      ),
    );
    String url = AppUrl.mainUrl + name;
    dynamic result;
    try {
      Response response = await dio.get(url);
      if (kDebugMode) {
        print("Url = $url\nResponse = $response");
      }
      if (response.statusCode == 200) {
        dialog.dismiss();
        result = json.decode(response.data.toString());
      }
    } on DioError catch (e) {
      debugPrint(e.message);
    }
    return result;
  }

  Future<dynamic> getWithoutDialog(ctx, name, token) async {
    Dio dio = Dio(
      BaseOptions(headers: {
        "contentType": Headers.jsonContentType,
        "responseType": ResponseType.plain,
        "Authorization": "Bearer $token",
      }),
    );
    String url = AppUrl.mainUrl + name;
    dynamic result;
    try {
      Response response = await dio.get(url);
      if (kDebugMode) {
        print("Url = $url\nResponse = $response");
      }
      if (response.statusCode == 200) {
        result = response.data;
        // result = json.decode(response.data.toString());
      }
    } on DioError catch (e) {
      debugPrint(e.message);
    }
    return result;
  }

  Future<dynamic> postWithToken(ctx, title, name, body, token) async {
    //Dialog
    AwesomeDialog dialog = STM().loadingDialog(ctx, title);
    dialog.show();
    Dio dio = Dio(
      BaseOptions(
        headers: {
          "Content-Type": "application/json",
          "responseType": "ResponseType.plain",
          "Authorization": "Bearer $token",
        },
      ),
    );
    String url = AppUrl.mainUrl + name;
    if (kDebugMode) {
      print("Url = $url\nBody = ${body.fields}");
    }
    dynamic result;
    try {
      Response response = await dio.post(url, data: body);
      if (kDebugMode) {
        print("Response = $response");
      }
      if (response.statusCode == 200) {
        dialog.dismiss();
        result = response.data;
        // result = json.decode(response.data.toString());
      }
    } on DioError catch (e) {
      dialog.dismiss();
      STM().errorDialog(ctx, e.message);
    }
    return result;
  }

  Future<dynamic> getcat(ctx, title, name, token) async {
    Dio dio = Dio(
      BaseOptions(
        headers: {
          "Content-Type": "application/json",
          "responseType": "ResponseType.plain",
          "Authorization": "Bearer $token",
        },
      ),
    );
    String url = AppUrl.mainUrl + name;
    if (kDebugMode) {
      // print("Url = $url\nBody = ${body.fields}");
    }
    dynamic result;
    try {
      Response response = await dio.get(url);
      if (kDebugMode) {
        print("Response = $response");
      }
      if (response.statusCode == 200) {
        result = response.data;
      }
    } on DioError catch (e) {
      STM().errorDialog(ctx, e.message);
    }
    return result;
  }

  Future<dynamic> getStock(ctx, name) async {
    Dio dio = Dio(
      BaseOptions(
        headers: {
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Methods": "GET,PUT,PATCH,POST,DELETE",
          "Access-Control-Allow-Headers":
              "Origin, X-Requested-With, Content-Type, Accept",
          "Content-Type": 'application/json',
          "responseType": "ResponseType.plain",
          "Api-Version": "2.0",
        },
      ),
    );
    String url = name;
    if (kDebugMode) {
      // print("Url = $url\nBody = ${body.fields}");
    }
    dynamic result;
    try {
      Response response = await dio.get(url);
      if (kDebugMode) {
        print("Response = $response");
      }
      if (response.statusCode == 200) {
        result = response.data;
      }
    } on DioError catch (e) {
      STM().errorDialog(ctx, e.message);
    }
    return result;
  }

  Future<dynamic> postget(ctx, title, name, body, token) async {
    //Dialog
    AwesomeDialog dialog = STM().loadingDialog(ctx, title);
    dialog.show();
    Dio dio = Dio(
      BaseOptions(
        headers: {
          "Content-Type": "application/json",
          "responseType": "ResponseType.plain",
          "Authorization": "Bearer $token",
        },
      ),
    );
    String url = AppUrl.mainUrl + name;
    if (kDebugMode) {
      print("Url = $url\nBody = ${body.fields}");
    }
    dynamic result;
    try {
      Response response = await dio.post(url, data: body);
      if (kDebugMode) {
        print("Response = $response");
      }
      if (response.statusCode == 200) {
        dialog.dismiss();
        result = response.data;
        // result = json.decode(response.data.toString());
      }
    } on DioError catch (e) {
      debugPrint(e.message);
      // dialog.dismiss();
      // STM().errorDialog(ctx, e.message);
    }
    return result;
  }

  Future<dynamic> post(ctx, title, name, body) async {
    //Dialog
    AwesomeDialog dialog = STM().loadingDialog(ctx, title);
    dialog.show();
    Dio dio = Dio(
      BaseOptions(
        contentType: Headers.jsonContentType,
        responseType: ResponseType.plain,
      ),
    );
    String url = AppUrl.mainUrl + name;
    if (kDebugMode) {
      print("Url = $url\nBody = ${body.fields}");
    }
    dynamic result;
    try {
      Response response = await dio.post(url, data: body);
      if (kDebugMode) {
        print("Response = $response");
      }
      if (response.statusCode == 200) {
        dialog.dismiss();
        result = json.decode(response.data.toString());
      }
    } on DioError catch (e) {
      debugPrint(e.message);
      // STM().errorDialog(ctx, e.message);
    }
    return result;
  }

  Future<dynamic> postWithoutDialog(ctx, name, body) async {
    //Dialog
    Dio dio = Dio(
      BaseOptions(
        contentType: Headers.jsonContentType,
        responseType: ResponseType.plain,
      ),
    );
    String url = AppUrl.mainUrl + name;
    dynamic result;
    try {
      Response response = await dio.post(url, data: body);
      if (kDebugMode) {
        print("Url = $url\nBody = ${body.fields}\nResponse = $response");
      }
      if (response.statusCode == 200) {
        result = json.decode(response.data.toString());
      }
    } on DioError catch (e) {
      debugPrint(e.message);
    }
    return result;
  }

  Future<dynamic> postListWithoutDialog(
    ctx,
    name,
    token,
    body,
  ) async {
    Dio dio = Dio(
      BaseOptions(
        headers: {
          "Content-Type": "application/json",
          "responseType": "ResponseType.plain",
          "Authorization": "Bearer $token",
        },
      ),
    );
    String url = AppUrl.mainUrl + name;
    if (kDebugMode) {
      print("Url = $url\nBody = ${body.fields}");
    }
    dynamic result;
    try {
      Response response = await dio.post(url, data: body);
      if (kDebugMode) {
        print("Response = $response");
      }
      if (response.statusCode == 200) {
        // result = json.decode(response.data.toString());
        result = response.data;
      }
    } on DioError catch (e) {
      // STM().errorDialog(ctx, e.message);
    }
    return result;
  }

  Widget loadingPlaceHolder() {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 0.6,
        color: Clr().primaryColor,
      ),
    );
  }

  Widget imageView(Map<String, dynamic> v) {
    return v['url'].toString().contains('assets')
        ? Image.asset(
            '${v['url']}',
            width: v['width'],
            height: v['height'],
            fit: v['fit'] ?? BoxFit.fill,
          )
        : CachedNetworkImage(
            width: v['width'],
            height: v['height'],
            fit: v['fit'] ?? BoxFit.fill,
            imageUrl: v['url'] ??
                'https://www.famunews.com/wp-content/themes/newsgamer/images/dummy.png',
            placeholder: (context, url) => STM().loadingPlaceHolder(),
          );
  }

  CachedNetworkImage networkimg(url) {
    return url == null
        ? CachedNetworkImage(
            imageUrl:
                'https://liftlearning.com/wp-content/uploads/2020/09/default-image.png',
            fit: BoxFit.cover,
            imageBuilder: (context, imageProvider) => Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Clr().lightGrey),
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
          )
        : CachedNetworkImage(
            imageUrl: '$url',
            fit: BoxFit.cover,
            imageBuilder: (context, imageProvider) => Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                // borderRadius: BorderRadius.all(Radius.circular(10)),
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
          );
  }

  hexStringToColor(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  SingleChildScrollView Contat(ctx, child) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(ctx).size.height / 1.1,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Clr().black,
            // image: const DecorationImage(
            //     image: AssetImage('assets/bgscreen.png'), fit: BoxFit.cover)
          ),
          child: child,
        ),
      ),
    );
  }

  /// update mobile
  Future mobileUpdate(ctx, token) async {
    TextEditingController mobilectrl = TextEditingController();
    TextEditingController otpctrl = TextEditingController();
    bool loading = false;
    final _formKey = GlobalKey<FormState>();
    bool? checkStatus;
    bool? checkStatus1;
    return AwesomeDialog(
        dismissOnBackKeyPress: false,
        dismissOnTouchOutside: false,
        dialogType: DialogType.noHeader,
        width: 600.0,
        isDense: true,
        context: ctx,
        body: StatefulBuilder(builder: (ctx, setState) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                loading == false
                    ? Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Text('Enter Mobile Number',
                                style: Sty()
                                    .mediumText
                                    .copyWith(fontWeight: FontWeight.w600)),
                            SizedBox(height: Dim().d20),
                            TextFormField(
                              controller: mobilectrl,
                              maxLength: 10,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return 'Mobile number is required';
                                }
                                if (v.length != 10) {
                                  return 'Mobile number digits must be 10';
                                }
                                return null;
                              },
                              decoration: Sty()
                                  .TextFormFieldOutlineDarkStyle
                                  .copyWith(
                                      hintText: 'Enter Mobile Number',
                                      counterText: "",
                                      hintStyle: Sty()
                                          .mediumText
                                          .copyWith(color: Clr().hintColor)),
                            ),
                            SizedBox(height: Dim().d20),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Clr().primaryColor),
                                      onPressed: () {
                                        STM().back2Previous(ctx);
                                      },
                                      child: Center(
                                        child: Text('Cancel',
                                            style: Sty()
                                                .mediumText
                                                .copyWith(color: Clr().white)),
                                      )),
                                ),
                                SizedBox(width: Dim().d8),
                                checkStatus == true
                                    ? CircularProgressIndicator(
                                        color: Clr().primaryColor)
                                    : Expanded(
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Clr().primaryColor),
                                            onPressed: () async {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                setState(() {
                                                  checkStatus = true;
                                                });
                                                FormData body =
                                                    FormData.fromMap({
                                                  'phone': mobilectrl.text,
                                                });
                                                var result = await STM()
                                                    .postListWithoutDialog(
                                                        ctx,
                                                        'update_mobile',
                                                        token,
                                                        body);
                                                if (result['success'] == true) {
                                                  setState(() {
                                                    loading = true;
                                                    checkStatus = false;
                                                  });
                                                } else {
                                                  setState(() {
                                                    checkStatus = false;
                                                    loading = false;
                                                    mobilectrl.clear();
                                                    AwesomeDialog(
                                                            context: ctx,
                                                            dismissOnBackKeyPress:
                                                                false,
                                                            dismissOnTouchOutside:
                                                                false,
                                                            dialogType:
                                                                DialogType
                                                                    .ERROR,
                                                            animType:
                                                                AnimType.SCALE,
                                                            headerAnimationLoop:
                                                                true,
                                                            title: 'Note',
                                                            desc: result[
                                                                'message'],
                                                            btnOkText: "OK",
                                                            btnOkOnPress: () {
                                                              Navigator.pop(
                                                                  ctx);
                                                            },
                                                            btnOkColor:
                                                                Clr().errorRed)
                                                        .show();
                                                  });
                                                }
                                              }
                                            },
                                            child: Center(
                                              child: Text('Send OTP',
                                                  style: Sty()
                                                      .mediumText
                                                      .copyWith(
                                                          color: Clr().white)),
                                            )),
                                      )
                              ],
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          Text('Enter OTP',
                              style: Sty()
                                  .mediumText
                                  .copyWith(fontWeight: FontWeight.w600)),
                          SizedBox(height: Dim().d20),
                          TextFormField(
                            controller: otpctrl,
                            maxLength: 4,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            decoration: Sty()
                                .TextFormFieldOutlineDarkStyle
                                .copyWith(
                                    hintText: 'Enter OTP',
                                    counterText: '',
                                    hintStyle: Sty()
                                        .mediumText
                                        .copyWith(color: Clr().hintColor)),
                          ),
                          SizedBox(height: Dim().d20),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Clr().primaryColor),
                                    onPressed: () {
                                      setState(() {
                                        loading = false;
                                        otpctrl.clear();
                                        mobilectrl.clear();
                                      });
                                    },
                                    child: Center(
                                      child: Text('Back',
                                          style: Sty()
                                              .mediumText
                                              .copyWith(color: Clr().white)),
                                    )),
                              ),
                              SizedBox(width: Dim().d12),
                              checkStatus1 == true
                                  ? CircularProgressIndicator(
                                      color: Clr().primaryColor)
                                  : Expanded(
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Clr().primaryColor),
                                          onPressed: () async {
                                            setState(() {
                                              checkStatus1 = true;
                                            });
                                            FormData body = FormData.fromMap({
                                              'phone': mobilectrl.text,
                                              'otp': otpctrl.text,
                                            });
                                            var result = await STM()
                                                .postListWithoutDialog(
                                                    ctx,
                                                    'update_mobile_verify_otp',
                                                    token,
                                                    body);
                                            if (result['success']) {
                                              setState(() {
                                                checkStatus1 = false;
                                                otpctrl.clear();
                                                mobilectrl.clear();
                                              });
                                              STM().back2Previous(ctx);
                                            } else {
                                              setState(() {
                                                checkStatus1 = false;
                                                otpctrl.clear();
                                              });
                                              STM().errorDialog(
                                                  ctx, result['message']);
                                            }
                                          },
                                          child: Center(
                                            child: Text('Submit',
                                                style: Sty()
                                                    .mediumText
                                                    .copyWith(
                                                        color: Clr().white)),
                                          )),
                                    )
                            ],
                          ),
                        ],
                      ),
              ],
            ),
          );
        })).show();
  }

  /// update mobile
  Future emailUpdate(ctx, token) async {
    TextEditingController emailctrl = TextEditingController();
    TextEditingController otpctrl = TextEditingController();
    bool loading = false;
    final _formKey = GlobalKey<FormState>();
    bool? checkStatus;
    bool? checkStatus1;
    return AwesomeDialog(
        dismissOnBackKeyPress: false,
        dismissOnTouchOutside: false,
        dialogType: DialogType.noHeader,
        width: 800.0,
        isDense: true,
        context: ctx,
        body: StatefulBuilder(builder: (ctx, setState) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text('Enter Email Address',
                          style: Sty()
                              .mediumText
                              .copyWith(fontWeight: FontWeight.w600)),
                      SizedBox(height: Dim().d20),
                      TextFormField(
                        controller: emailctrl,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        validator: (v) {
                          if (v!.isEmpty) {
                            return 'Email is required';
                          }
                          if (!RegExp(r'\S+@\S+\.\S+').hasMatch(v)) {
                            return "Please enter a valid email address";
                          }
                          return null;
                        },
                        decoration: Sty()
                            .TextFormFieldOutlineDarkStyle
                            .copyWith(
                                hintText: 'Enter Email Address',
                                counterText: "",
                                hintStyle: Sty()
                                    .mediumText
                                    .copyWith(color: Clr().hintColor)),
                      ),
                      SizedBox(height: Dim().d20),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Clr().primaryColor),
                                onPressed: () {
                                  STM().back2Previous(ctx);
                                },
                                child: Center(
                                  child: Text('Cancel',
                                      style: Sty()
                                          .mediumText
                                          .copyWith(color: Clr().white)),
                                )),
                          ),
                          SizedBox(width: Dim().d12),
                          checkStatus == true
                              ? CircularProgressIndicator(
                                  color: Clr().primaryColor)
                              : Expanded(
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Clr().primaryColor),
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          setState(() {
                                            checkStatus = true;
                                          });
                                          FormData body = FormData.fromMap({
                                            'email': emailctrl.text,
                                          });
                                          var result = await STM()
                                              .postListWithoutDialog(ctx,
                                                  'update_email', token, body);
                                          if (result['success']) {
                                            setState(() {
                                              checkStatus = false;
                                              emailctrl.clear();
                                              AwesomeDialog(
                                                      dismissOnBackKeyPress:
                                                          false,
                                                      dismissOnTouchOutside:
                                                          false,
                                                      context: ctx,
                                                      dialogType:
                                                          DialogType.SUCCES,
                                                      animType: AnimType.SCALE,
                                                      headerAnimationLoop: true,
                                                      title: 'Success',
                                                      desc: result['message'],
                                                      btnOkText: "OK",
                                                      btnOkOnPress: () {
                                                        Navigator.pop(ctx);
                                                      },
                                                      btnOkColor:
                                                          Clr().successGreen)
                                                  .show();
                                            });
                                          } else {
                                            setState(() {
                                              checkStatus = false;
                                              emailctrl.clear();
                                              AwesomeDialog(
                                                      context: ctx,
                                                      dismissOnBackKeyPress:
                                                          false,
                                                      dismissOnTouchOutside:
                                                          false,
                                                      dialogType:
                                                          DialogType.ERROR,
                                                      animType: AnimType.SCALE,
                                                      headerAnimationLoop: true,
                                                      title: 'Note',
                                                      desc: result['message'],
                                                      btnOkText: "OK",
                                                      btnOkOnPress: () {
                                                        Navigator.pop(ctx);
                                                      },
                                                      btnOkColor:
                                                          Clr().errorRed)
                                                  .show();
                                            });
                                          }
                                        }
                                      },
                                      child: Center(
                                        child: Text('Save',
                                            style: Sty()
                                                .mediumText
                                                .copyWith(color: Clr().white)),
                                      )),
                                )
                        ],
                      ),
                    ],
                  ),
                ),
                // : Column(
                //     children: [
                //       Text('Enter OTP',
                //           style: Sty()
                //               .mediumText
                //               .copyWith(fontWeight: FontWeight.w600)),
                //       SizedBox(height: Dim().d20),
                //       TextFormField(
                //         controller: otpctrl,
                //         maxLength: 4,
                //         keyboardType: TextInputType.number,
                //         textInputAction: TextInputAction.done,
                //         decoration: Sty()
                //             .TextFormFieldOutlineDarkStyle
                //             .copyWith(
                //                 hintText: 'Enter OTP',
                //                 counterText: '',
                //                 hintStyle: Sty()
                //                     .mediumText
                //                     .copyWith(color: Clr().hintColor)),
                //       ),
                //       SizedBox(height: Dim().d20),
                //       Row(
                //         children: [
                //           Expanded(
                //             child: ElevatedButton(
                //                 style: ElevatedButton.styleFrom(
                //                     backgroundColor: Clr().primaryColor),
                //                 onPressed: () {
                //                   setState(() {
                //                     loading = false;
                //                     otpctrl.clear();
                //                     emailctrl.clear();
                //                   });
                //                 },
                //                 child: Center(
                //                   child: Text('Back',
                //                       style: Sty()
                //                           .mediumText
                //                           .copyWith(color: Clr().white)),
                //                 )),
                //           ),
                //           SizedBox(width: Dim().d12),
                //           checkStatus1 == true
                //               ? CircularProgressIndicator(
                //                   color: Clr().primaryColor)
                //               : Expanded(
                //                   child: ElevatedButton(
                //                       style: ElevatedButton.styleFrom(
                //                           backgroundColor:
                //                               Clr().primaryColor),
                //                       onPressed: () async {
                //                         setState(() {
                //                           checkStatus1 = true;
                //                         });
                //                         FormData body = FormData.fromMap({
                //                           'email': emailctrl.text,
                //                           'otp': otpctrl.text,
                //                         });
                //                         var result = await STM()
                //                             .postListWithoutDialog(
                //                                 ctx,
                //                                 'Verify_email_otp',
                //                                 token,
                //                                 body);
                //                         if (result['success']) {
                //                           setState(() {
                //                             checkStatus1 = false;
                //                             otpctrl.clear();
                //                             emailctrl.clear();
                //                           });
                //                           STM().back2Previous(ctx);
                //                         } else {
                //                           setState(() {
                //                             checkStatus1 = false;
                //                             otpctrl.clear();
                //                           });
                //                           STM().errorDialog(
                //                               ctx, result['message']);
                //                         }
                //                       },
                //                       child: Center(
                //                         child: Text('Submit',
                //                             style: Sty()
                //                                 .mediumText
                //                                 .copyWith(
                //                                     color: Clr().white)),
                //                       )),
                //                 )
                //         ],
                //       ),
                //     ],
                //   ),
              ],
            ),
          );
        })).show();
  }

  Future<dynamic> post2(ctx, title, name, body) async {
    //Dialog
    AwesomeDialog dialog = STM().loadingDialog(ctx, title);
    dialog.show();
    Dio dio = Dio(
      BaseOptions(
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
      ),
    );
    String url = 'https://api.emptra.com/$name';
    if (kDebugMode) {
      debugPrint("Url = $url\nBody = ${body}");
    }
    dynamic result;
    try {
      Response response = await dio.post(
        url,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          'clientId':
              'c7071fc90ac75515c0b78504127e5e76:d8219239a751c96ee5d552cb255a5097',
          'secretKey':
              'HGS0otILr8t8yb6E06cC1RuYmuSESQcmjdGXsR5JuEy6pw0ivnvUXnW6wMLAFN7lB',
        }),
        data: jsonEncode(body),
      );
      if (kDebugMode) {
        debugPrint("Response = $response");
      }
      if (response.statusCode == 200) {
        dialog.dismiss();
        result = response.data;
      }
    } on DioError catch (e) {
      debugPrint(e.message);
      dialog.dismiss();
      result = e.response!.data;
    }
    return result;
  }
}
