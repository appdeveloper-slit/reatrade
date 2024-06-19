import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:storak/otp.dart';
import 'package:storak/sign_in.dart';
import 'commonText/commontext.dart';
import 'manage/static_method.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late BuildContext ctx;

  bool _ischanged = true;
  TextEditingController mobileCtrl2 = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
        backgroundColor: Clr().black,
        // extendBodyBehindAppBar: false,
        resizeToAvoidBottomInset: false,
        // backgroundColor: Clr().white,
        // bottomNavigationBar: Image.asset('assets/bottom_chart.png'),
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
                  height: Dim().d40,
                ),
                Text(
                  'Sign Up',
                  style: Sty().extraLargeText.copyWith(),
                ),
                SizedBox(
                  height: Dim().d12,
                ),
                Text(
                  'Enter mobile number to create an account',
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
                  child: TextFormField(
                    controller: mobileCtrl2,
                    cursorColor: Clr().primaryColor,
                    style: Sty().mediumText.copyWith(color: Clr().white),
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    decoration: Sty().textFieldOutlineStyle.copyWith(
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(Dim().d12),
                            child: SvgPicture.asset('assets/phone.svg'),
                          ),
                          hintStyle: Sty().smallText.copyWith(
                                color: Clr().grey,
                              ),
                          hintText: "Enter Mobile Number",
                          counterText: "",
                          // prefixIcon: Icon(
                          //   Icons.call,
                          //   color: Clr().lightGrey,
                          // ),
                        ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Mobile field is required';
                      }
                      if (value.length != 10) {
                        return 'Mobile number must be 10 digits';
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: Dim().d32,
                ),
                RichText(
                  text: TextSpan(
                    text: 'By clicking, you have agreed to our',
                    style: Sty().smallText.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Clr().white,
                        fontFamily: ''),
                    children: [
                      WidgetSpan(
                        child: InkWell(
                          onTap: () {
                            STM()
                                .openWeb('https://reatrade.in/terms&condition');
                          },
                          child: Text(
                            ' Terms & Conditions',
                            style: Sty().mediumText.copyWith(
                                color: Clr().accentColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                fontFamily: ''),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: Dim().d2,
                ),
                Text(
                  'read before going further.',
                  style: Sty().smallText.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Clr().white,
                      fontFamily: ''),
                ),
                SizedBox(
                  height: Dim().d16,
                ),
                _ischanged
                    ? Container(
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
                              if (_formKey.currentState!.validate()) {
                                sendOtp();
                              }
                              // updateProfile();
                            },
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Clr().transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                            child: Text(
                              'Send OTP',
                              style: Sty().largeText.copyWith(
                                  fontSize: 16,
                                  color: Clr().white,
                                  fontWeight: FontWeight.w600),
                            )),
                      )
                    : CircularProgressIndicator(color: Clr().primaryColor),
                SizedBox(
                  height: Dim().d8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an Account?",
                      style: Sty().smallText.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Clr().white,
                            fontFamily: '',
                          ),
                    ),
                    TextButton(
                      onPressed: () {
                        STM().redirect2page(ctx, SignIn());
                      },
                      child: Text(
                        'Sign In',
                        style: Sty().mediumText.copyWith(
                            color: Clr().accentColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            fontFamily: ''),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  void sendOtp() async {
    setState(() {
      _ischanged = false;
    });
    FormData body = FormData.fromMap({
      'phone': mobileCtrl2.text,
      'action': 'register',
    });
    var result = await STM().postWithoutDialog(ctx, 'otp-send', body);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      setState(() {
        _ischanged = true;
      });
      STM().displayToast(message, ToastGravity.CENTER);
      STM().redirect2page(
          ctx, Verification(mobileCtrl2.text.toString(), 'register'));
    } else {
      setState(() {
        _ischanged = true;
      });
      STM().errorDialog(ctx, message);
    }
  }
}
