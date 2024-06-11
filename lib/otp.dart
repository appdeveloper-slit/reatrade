// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storak/bank_details.dart';
import 'package:storak/kyc_details.dart';
import 'home.dart';
import 'manage/static_method.dart';
import 'personal_details.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class Verification extends StatefulWidget {
  final sMobile;
  final type;
  const Verification(this.sMobile, this.type, {Key? key}) : super(key: key);

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  late BuildContext ctx;

  bool again = false;

  TextEditingController otpCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
        // resizeToAvoidBottomInset: false,
        backgroundColor: Clr().black,
        body: SingleChildScrollView(
          padding: EdgeInsets.all(Dim().d16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: Dim().d40,
                ),
                Padding(
                  padding: EdgeInsets.only(left: Dim().d20),
                  child: Image.asset(
                    'assets/logo.jpg',
                    height: Dim().d200,
                    width: Dim().d250,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: Dim().d60,
                ),
                Text(
                  'OTP Verification',
                  style: Sty().extraLargeText.copyWith(),
                ),
                SizedBox(
                  height: Dim().d12,
                ),
                Text(
                  'Code has sent to +91 ${widget.sMobile}',
                  style: Sty().smallText.copyWith(
                        color: Clr().textcolor,
                      ),
                ),
                SizedBox(
                  height: Dim().d32,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width > 600
                      ? Dim().d300
                      : null,
                  child: PinCodeTextField(
                    controller: otpCtrl,
                    // errorAnimationController: errorController,
                    appContext: context,
                    enableActiveFill: true,
                    textStyle:
                        Sty().largeText.copyWith(color: Clr().primaryColor),
                    length: 4,
                    obscureText: false,
                    keyboardType: TextInputType.number,
                    animationType: AnimationType.scale,
                    cursorColor: Clr().accentColor,
                    errorTextSpace: 25.0,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderWidth: 0.2,
                      borderRadius: BorderRadius.circular(Dim().d4),
                      fieldWidth: Dim().d60,
                      fieldHeight: Dim().d56,
                      selectedFillColor: Clr().transparent,
                      activeFillColor: Clr().transparent,
                      inactiveFillColor: Clr().transparent,
                      inactiveColor: Clr().borderColor,
                      activeColor: Clr().accentColor,
                      selectedColor: Clr().accentColor,
                    ),
                    animationDuration: const Duration(milliseconds: 200),
                    onChanged: (value) {},
                    validator: (value) {
                      if (value!.isEmpty ||
                          !RegExp(r'(.{4,})').hasMatch(value)) {
                        return Str().invalidOtp;
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: Dim().d24,
                ),
                Container(
                  width: MediaQuery.of(context).size.width > 600
                      ? Dim().d200
                      : MediaQuery.of(context).size.width * 0.70,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Clr().primaryColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ElevatedButton(
                      onPressed: () {
                        // updateProfile();
                        if (_formKey.currentState!.validate()) {
                          verifyOtp();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          primary: Colors.transparent,
                          onSurface: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                      child: Text(
                        'Verify',
                        style: Sty().largeText.copyWith(
                            fontSize: 16,
                            color: Clr().white,
                            fontWeight: FontWeight.w600),
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn't receive code? ",
                      style: Sty().smallText.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Clr().textcolor),
                    ),
                    Visibility(
                      visible: !again,
                      child: TweenAnimationBuilder<Duration>(
                          duration: const Duration(seconds: 60),
                          tween: Tween(
                              begin: const Duration(seconds: 60),
                              end: Duration.zero),
                          onEnd: () {
                            // ignore: avoid_print
                            // print('Timer ended');
                            setState(() {
                              again = true;
                            });
                          },
                          builder: (BuildContext context, Duration value,
                              Widget? child) {
                            final minutes = value.inMinutes;
                            final seconds = value.inSeconds % 60;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Text(
                                " $minutes:$seconds",
                                textAlign: TextAlign.center,
                                style: Sty().smallText.copyWith(
                                    color: Clr().accentColor,
                                    fontWeight: FontWeight.w600),
                              ),
                            );
                          }),
                    ),
                    // Visibility(
                    //   visible: !isResend,
                    //   child: Text("I didn't receive a code! ${(  sTime  )}",
                    //       style: Sty().mediumText),
                    // ),
                    Visibility(
                      visible: again,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            again = false;
                          });
                          resendotp();
                          // STM.checkInternet().then((value) {
                          //   if (value) {
                          //     sendOTP();
                          //   } else {
                          //     STM.internetAlert(ctx, widget);
                          //   }
                          // });
                        },
                        child: Text(
                          'Resend',
                          style: Sty().smallText.copyWith(
                              color: Clr().accentColor,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  void resendotp() async {
    FormData body = FormData.fromMap({
      'phone': widget.sMobile,
    });
    var result = await STM().post(ctx, Str().verifying, 'resend_otp', body);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      STM().displayToast(message, ToastGravity.BOTTOM);
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  void verifyOtp() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var step;
    FormData body = FormData.fromMap({
      'phone': widget.sMobile,
      'otp': otpCtrl.text,
      'action': widget.type,
    });
    var result = await STM().post(ctx, Str().verifying, 'otp-verify', body);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      if (widget.type == 'register') {
        // ignore: use_build_context_synchronously
        STM().successDialog(
            ctx,
            message,
            PersonalDetails(
              mobile: widget.sMobile,
            ));
      } else {
        sp.setString('token', result['token']);
        switch (result['data']['step']) {
          case 1:
            STM().redirect2page(ctx, KYCDetails());
            break;
          case 2:
            STM().redirect2page(ctx, BankDetails());
            break;
          case null:
            setState(() {
              sp.setBool('login', true);
            });
            STM().finishAffinity(
                ctx,
                const Home(
                  b: true,
                ));
            break;
        }
      }
    } else {
      STM().errorDialog(ctx, message);
    }
  }
}
