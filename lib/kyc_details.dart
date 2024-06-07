import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storak/home.dart';
import 'package:storak/otp.dart';
import 'package:storak/sign_in.dart';
import 'bank_details.dart';
import 'manage/static_method.dart';
import 'my_account.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'viewimage.dart';

class KYCDetails extends StatefulWidget {
  var name, type, data;

  KYCDetails({super.key, this.name, this.type, this.data});

  @override
  State<KYCDetails> createState() => _KYCDetailsState();
}

class _KYCDetailsState extends State<KYCDetails> {
  late BuildContext ctx;

  bool isChanged = true;
  TextEditingController panNum = TextEditingController();
  TextEditingController panName = TextEditingController();
  TextEditingController aadharNum = TextEditingController();
  TextEditingController otpCtrl = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final formKey = GlobalKey<FormState>();
  String? Token, sClientID;
  bool? aadhar, panCheck;
  bool isOtp = false;
  bool again = false;
  List<String> aa = [];
  var panImgTxt, aadharFrtTxt, aadharBckTxt, panVerify, aadhaarVerify;

  validates(type) {
    bool check = _formKey.currentState!.validate();
    if (widget.type != 'edit') {
      /// validation for pan card image is required
      if (profile == null) {
        setState(() {
          panImgTxt = 'Pan image is required';
          check = false;
        });
      } else {
        setState(() {
          panImgTxt = '';
          check = true;
        });
      }

      /// validation for aadhaar card front image is required
      if (aadharFrt == null) {
        setState(() {
          aadharFrtTxt = 'Aadhaar card front image is required';
          check = false;
        });
      } else {
        setState(() {
          aadharFrtTxt = '';
          check = true;
        });
      }

      /// validation for aadhaar card back image is required
      if (aadharBck == null) {
        setState(() {
          aadharBckTxt = 'Aadhaar card back image is required';
          check = false;
        });
      } else {
        setState(() {
          aadharBckTxt = '';
          check = true;
        });
      }

      /// if all fields is fill then this funtion excurte
      if (check) {
        if (type == 1) {
          kycDetail();
        } else {
          if (widget.type == 'bank') {
            kycDetail();
          } else {
            if (aadhar == true) {
              verifyPan();
            } else {
              verifyAdharCheck();
            }
          }
        }
      }
    } else {
      /// when user come this page for update then this condition work!!!
      /// if user already verify pan and aadhaar then if condition work or all first verify aadhaar then check pan
      if (panVerify == 1 && aadhaarVerify == 1) {
        kycDetail();
      } else {
        if (aadhar == true) {
          verifyPan();
        } else {
          requestOtp(false);
        }
      }
    }
  }

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      Token = sp.getString('token');
    });
    if (widget.type != 'edit') {
      setState(() {
        aa = sp.getStringList('kycdetailslist') == null
            ? []
            : sp.getStringList('kycdetailslist')!;
        panNum = TextEditingController(text: aa[0]);
        profile = aa[1];
        aadharNum = TextEditingController(text: aa[2]);
        panName = TextEditingController(text: aa[5]);
        aadharFrt = aa[6];
        aadharBck = aa[7];
        verify = int.parse(aa[3].toString());
        veriPan = int.parse(aa[4].toString());
        panUrl = aa[8];
        aadharFrtUrl = aa[9];
        aadharBckUrl = aa[10];
        if (int.parse(aa[3].toString()) == 1) {
          aadhar = true;
        } else {
          aadhar = false;
        }
        if (int.parse(aa[4].toString()) == 1) {
          panCheck = true;
        } else {
          panCheck = false;
        }
        imageFile = File(aa[8].toString());
        aadharFrtFile = File(aa[9].toString());
        aadharBckFile = File(aa[10].toString());
      });
    } else {
      setState(() {
        panNum = TextEditingController(text: widget.data[0]['number']);
        aadharNum = TextEditingController(text: widget.data[1]['number']);
        panName = TextEditingController(text: widget.data[0]['pan_name']);
        panVerify = widget.data[0]['is_verify'];
        aadhaarVerify = widget.data[1]['is_verify'];
        panVerify == 1 ? panCheck = true : panCheck = false;
        aadhaarVerify == 1 ? aadhar = true : aadhar = false;
      });
    }
    print(Token);
  }

  var verify = 0;
  var veriPan = 0;

  @override
  void initState() {
    // TODO: implement initState
    getSession();
    super.initState();
  }

  File? imageFile, aadharBckFile, aadharFrtFile;
  var profile,
      aadharFrt,
      aadharBck,
      shiphide,
      panUrl,
      aadharFrtUrl,
      aadharBckUrl;
  Uint8List? webimge;

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return WillPopScope(
      onWillPop: () async {
        widget.type == 'edit'
            ? STM().back2Previous(ctx)
            : SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
          // extendBodyBehindAppBar: false,
          // resizeToAvoidBottomInset: false,
          backgroundColor: Clr().black,
          appBar: AppBar(
            leading: widget.type == 'edit'
                ? InkWell(
                    onTap: () {
                      STM().back2Previous(ctx);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Clr().white,
                    ),
                  )
                : Container(),
            backgroundColor:
                widget.type == 'edit' ? Clr().background : Clr().transparent,
            elevation: 0,
            centerTitle: true,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                widget.type == 'edit'
                    ? Container()
                    : SvgPicture.asset(
                        'assets/progress_pg2.svg',
                        color: Clr().primaryColor,
                      ),
                Text('KYC Details',
                    style: Sty().mediumText.copyWith(
                        color: Clr().primaryColor,
                        fontSize: Dim().d24,
                        fontWeight: FontWeight.w600)),
              ],
            ),
            actions: [
              widget.type != 'edit'
                  ? shiphide == true
                      ? Container()
                      : InkWell(
                          onTap: () {
                            validates(1);
                          },
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Skip',
                                style: Sty().smallText.copyWith(
                                    color: Clr().white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: Dim().d14),
                              ),
                            ),
                          ),
                        )
                  : Container(),
              SizedBox(width: Dim().d4),
            ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(Dim().d16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dim().d4),
                        color: Clr().black,
                        boxShadow: const [
                          BoxShadow(blurRadius: 5, color: Colors.black38)
                        ]),
                    child: Padding(
                      padding: EdgeInsets.all(Dim().d14),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: aadharNum,
                            cursorColor: Clr().primaryColor,
                            style:
                                Sty().mediumText.copyWith(color: Clr().white),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            readOnly: aadhar == true ? true : false,
                            maxLength: 12,
                            decoration: Sty().textFieldOutlineStyle.copyWith(
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(Dim().d12),
                                    child: SvgPicture.asset('assets/pan.svg'),
                                  ),
                                  hintStyle: Sty().smallText.copyWith(
                                        color: Clr().grey,
                                      ),
                                  // filled: true,
                                  // fillColor: Clr().white,
                                  hintText: "Aadhaar Card Number",
                                  counterText: "",
                                  suffixIcon: aadhar == true
                                      ? Icon(
                                          Icons.check_circle,
                                          color: Clr().green,
                                        )
                                      : null,
                                  // prefixIcon: Icon(
                                  //   Icons.call,
                                  //   color: Clr().lightGrey,
                                  // ),
                                ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Aadhaar card number is required';
                              }
                              if (!RegExp(r'^[2-9]\d{11}').hasMatch(value)) {
                                return "Please enter a valid aadhaar card number";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: Dim().d12,
                          ),
                          InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Clr().background1,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(Dim().d14),
                                          topRight:
                                              Radius.circular(Dim().d14))),
                                  builder: (index) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: Dim().d12,
                                              vertical: Dim().d20),
                                          child: Text('Aadhaar Front Photo',
                                              style: Sty().mediumBoldText),
                                        ),
                                        SizedBox(height: Dim().d28),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                _getProfile(ImageSource.camera,
                                                    'aadhar front');
                                              },
                                              child: Icon(
                                                Icons.camera_alt_outlined,
                                                color: Clr().primaryColor,
                                                size: Dim().d32,
                                              ),
                                            ),
                                            InkWell(
                                                onTap: () {
                                                  _getProfile(
                                                      ImageSource.gallery,
                                                      'aadhar front');
                                                },
                                                child: Icon(
                                                  Icons.yard_outlined,
                                                  size: Dim().d32,
                                                  color: Clr().primaryColor,
                                                )),
                                          ],
                                        ),
                                        SizedBox(height: Dim().d40),
                                      ],
                                    );
                                  });
                            },
                            child: DottedBorder(
                              color: Clr().borderColor,
                              //color of dotted/dash line
                              strokeWidth: 1,
                              //thickness of dash/dots
                              dashPattern: [6, 4],
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 14),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/upload.svg',
                                        color: Clr().grey,
                                      ),
                                      SizedBox(
                                        width: Dim().d16,
                                      ),
                                      Text(
                                        aadharFrt != null
                                            ? 'Aadhaar front card Image selected'
                                            : 'Upload Aadhaar Front Card',
                                        style: Sty().smallText.copyWith(
                                              color: aadharFrt != null
                                                  ? Clr().white
                                                  : Clr().grey,
                                            ),
                                      )
                                    ],
                                  )),
                            ),
                          ),
                          if (aadharFrtTxt != '' && aadharFrtTxt != null)
                            Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: Dim().d20),
                                child: Text('${aadharFrtTxt}',
                                    style: Sty()
                                        .smallText
                                        .copyWith(color: Clr().errorRed))),
                          if (aadharFrtTxt != '' && aadharFrtTxt != null)
                            SizedBox(height: Dim().d12),
                          SizedBox(height: Dim().d12),
                          imageLayout(
                              'Front Side',
                              widget.type == 'edit'
                                  ? widget.data[1]['aadhar_front']
                                  : aadharFrtFile),
                          SizedBox(height: Dim().d12),
                          InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Clr().background1,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(Dim().d14),
                                          topRight:
                                              Radius.circular(Dim().d14))),
                                  builder: (index) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: Dim().d12,
                                              vertical: Dim().d20),
                                          child: Text('Aadhaar Back Photo',
                                              style: Sty().mediumBoldText),
                                        ),
                                        SizedBox(height: Dim().d28),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                _getProfile(ImageSource.camera,
                                                    'aadhar back');
                                              },
                                              child: Icon(
                                                Icons.camera_alt_outlined,
                                                color: Clr().primaryColor,
                                                size: Dim().d32,
                                              ),
                                            ),
                                            InkWell(
                                                onTap: () {
                                                  _getProfile(
                                                      ImageSource.gallery,
                                                      'aadhar back');
                                                },
                                                child: Icon(
                                                  Icons.yard_outlined,
                                                  size: Dim().d32,
                                                  color: Clr().primaryColor,
                                                )),
                                          ],
                                        ),
                                        SizedBox(height: Dim().d40),
                                      ],
                                    );
                                  });
                            },
                            child: DottedBorder(
                              color: Clr().borderColor,
                              //color of dotted/dash line
                              strokeWidth: 1,
                              //thickness of dash/dots
                              dashPattern: [6, 4],
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 14),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/upload.svg',
                                        color: Clr().grey,
                                      ),
                                      SizedBox(
                                        width: Dim().d16,
                                      ),
                                      Text(
                                        aadharBck != null
                                            ? 'Aadhaar back card Image selected'
                                            : 'Upload Aadhaar Back Card',
                                        style: Sty().smallText.copyWith(
                                              color: aadharBck != null
                                                  ? Clr().white
                                                  : Clr().grey,
                                            ),
                                      )
                                    ],
                                  )),
                            ),
                          ),
                          if (aadharBckTxt != '' && aadharBckTxt != null)
                            Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: Dim().d20),
                                child: Text('${aadharBckTxt}',
                                    style: Sty()
                                        .smallText
                                        .copyWith(color: Clr().errorRed))),
                          if (aadharBckTxt != '' && aadharBckTxt != null)
                            SizedBox(height: Dim().d12),
                          SizedBox(height: Dim().d12),
                          imageLayout(
                              'Back Side',
                              widget.type == 'edit'
                                  ? widget.data[1]['aadhar_back']
                                  : aadharBckFile),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: Dim().d24),
                  TextFormField(
                    controller: panName,
                    readOnly: panCheck == true ? true : false,
                    cursorColor: Clr().primaryColor,
                    style: Sty().mediumText.copyWith(color: Clr().white),
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.done,
                    decoration: Sty().textFieldOutlineStyle.copyWith(
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(Dim().d12),
                            child: SvgPicture.asset('assets/pan.svg'),
                          ),
                          hintStyle: Sty().smallText.copyWith(
                                color: Clr().grey,
                              ),
                          // filled: true,
                          // fillColor: Clr().white,
                          hintText: "Enter the same name on the PAN card",
                          counterText: "",
                        ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter the same name on the PAN card";
                      }
                    },
                  ),
                  SizedBox(
                    height: Dim().d12,
                  ),
                  TextFormField(
                    controller: panNum,
                    readOnly: panCheck == true ? true : false,
                    cursorColor: Clr().primaryColor,
                    style: Sty().mediumText.copyWith(color: Clr().white),
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.done,
                    decoration: Sty().textFieldOutlineStyle.copyWith(
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(Dim().d12),
                            child: SvgPicture.asset('assets/pan.svg'),
                          ),
                          hintStyle: Sty().smallText.copyWith(
                                color: Clr().grey,
                              ),
                          // filled: true,
                          // fillColor: Clr().white,
                          hintText: "Pan Card Number",
                          counterText: "",
                          suffixIcon: panCheck == true
                              ? Icon(
                                  Icons.check_circle,
                                  color: Clr().green,
                                )
                              : null,
                        ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Pan card number is required";
                      }
                    },
                  ),
                  SizedBox(
                    height: Dim().d12,
                  ),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          backgroundColor: Clr().background1,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(Dim().d14),
                                  topRight: Radius.circular(Dim().d14))),
                          builder: (index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Dim().d12,
                                      vertical: Dim().d20),
                                  child: Text('Profile Photo',
                                      style: Sty().mediumBoldText),
                                ),
                                SizedBox(height: Dim().d28),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        _getProfile(ImageSource.camera, 'kyc');
                                      },
                                      child: Icon(
                                        Icons.camera_alt_outlined,
                                        color: Clr().primaryColor,
                                        size: Dim().d32,
                                      ),
                                    ),
                                    InkWell(
                                        onTap: () {
                                          _getProfile(
                                              ImageSource.gallery, 'kyc');
                                        },
                                        child: Icon(
                                          Icons.yard_outlined,
                                          size: Dim().d32,
                                          color: Clr().primaryColor,
                                        )),
                                  ],
                                ),
                                SizedBox(height: Dim().d40),
                              ],
                            );
                          });
                    },
                    child: DottedBorder(
                      color: Clr().borderColor, //color of dotted/dash line
                      strokeWidth: 1, //thickness of dash/dots
                      dashPattern: [6, 4],
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/upload.svg',
                                color: Clr().grey,
                              ),
                              SizedBox(
                                width: Dim().d16,
                              ),
                              Text(
                                profile != null
                                    ? 'Pan card Image selected'
                                    : 'Upload PAN Card',
                                style: Sty().smallText.copyWith(
                                      color: profile != null
                                          ? Clr().white
                                          : Clr().grey,
                                    ),
                              )
                            ],
                          )),
                    ),
                  ),
                  if (panImgTxt != '' && panImgTxt != null)
                    SizedBox(height: Dim().d12),
                  if (panImgTxt != '' && panImgTxt != null)
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: Dim().d20),
                        child: Text('${panImgTxt}',
                            style: Sty()
                                .smallText
                                .copyWith(color: Clr().errorRed))),
                  SizedBox(height: Dim().d12),
                  imageLayout(
                      'Pan Card',
                      widget.type == 'edit'
                          ? widget.data[0]['image']
                          : imageFile),
                  SizedBox(
                    height: Dim().d32,
                  ),
                  Row(
                    children: [
                      isChanged
                          ? Expanded(
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 60),
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Clr().primaryColor,
                                ),
                                child: ElevatedButton(
                                    onPressed: () {
                                      validates(0);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        primary: Colors.transparent,
                                        onSurface: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5))),
                                    child: Text(
                                      isOtp
                                          ? aadhar == true
                                              ? 'Next'
                                              : 'Submit OTP'
                                          : 'Verify KYC Details',
                                      style: Sty().largeText.copyWith(
                                          fontSize: 16,
                                          color: Clr().white,
                                          fontWeight: FontWeight.w600),
                                    )

                                    //     : Lottie.asset('animations/tick.json',
                                    //     height: 100,
                                    //     reverse: false,
                                    //     repeat: true,
                                    //     fit: BoxFit.cover
                                    // ),
                                    ),
                              ),
                            )
                          : Align(
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(
                                  color: Clr().primaryColor),
                            ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }

  verifyAdharCheck() async {
    print(Token);
    FormData body = FormData.fromMap({
      'aadhaar': aadharNum.text,
    });
    var result = await STM()
        .postWithToken(ctx, Str().processing, 'aadhar-check', body, Token);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      STM().errorDialog(ctx, message);
    } else {
      requestOtp(false);
    }
  }

  //Request For Aadhaar
  void requestOtp(click) async {
    var body = {
      'aadhaarNumber': aadharNum.text,
    };
    var result = await STM()
        .post2(ctx, Str().loading, 'aadhaarVerification/requestOtp', body);
    if (!mounted) return;
    if (result.containsKey('result')) {
      var success = result['result']['success'];
      if (success) {
        setState(() {
          // isOtp = true;
          sClientID = result['result']['data']['client_id'];
          isOtp = true;
          click ? Container() : otpPopLayout();
          otpCtrl.clear();
        });
      } else {
        STM().errorDialog(ctx,
            'Failed to verify the details, kindly enter the aadhar number properly');
      }
    } else {
      var message = result['message'];
      result['message'].toString().contains("Error: Sorry For Inconvenience !")
          ? STM().errorDialog(ctx, 'Aadhaar card number is not valid!!')
          : STM().errorDialog(ctx, message);
    }
  }

  //Submit For Aadhaar
  void submitOtp() async {
    var body = {
      "client_id": sClientID,
      "otp": otpCtrl.text.trim(),
    };
    var result = await STM()
        .post2(ctx, Str().loading, 'aadhaarVerification/submitOtp', body);
    if (!mounted) return;
    if (result.containsKey('result')) {
      var success = result['result']['success'];
      setState(() {
        if (success) {
          setState(() {
            aadhar = true;
            verify = 1;
            shiphide = true;
            STM().back2Previous(ctx);
            STM().displayToast(
                'Aadhar verified Successfully!!! Press Next Button',
                ToastGravity.CENTER);
          });
        } else {
          STM().back2Previous(ctx);
          setState(() {
            aadhar = false;
          });
          var message = result['result']['message'];
          Fluttertoast.showToast(
            msg: message,
            backgroundColor: Clr().errorRed,
            textColor: Clr().white,
          );
        }
      });
    } else {
      STM().errorDialog(ctx, result['message']);
    }
  }

  /// otp popup
  otpPopLayout() {
    return AwesomeDialog(
        dismissOnBackKeyPress: false,
        dismissOnTouchOutside: false,
        dialogType: DialogType.noHeader,
        width: 600.0,
        isDense: true,
        context: ctx,
        body: Form(
          key: formKey,
          child: StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: Dim().d20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('OTP Verification',
                        style: Sty().mediumBoldText.copyWith(
                            fontWeight: FontWeight.w800, fontSize: Dim().d28)),
                    SizedBox(height: Dim().d8),
                    Text(
                        "Code has been sent to a mobile number which is linked to your Aadhaar card",
                        style: Sty()
                            .smallText
                            .copyWith(fontWeight: FontWeight.w200),
                        textAlign: TextAlign.center),
                    SizedBox(height: Dim().d12),
                    TextFormField(
                      cursorColor: Clr().primaryColor,
                      style: Sty().mediumText,
                      controller: otpCtrl,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: Sty().textFieldOutlineStyle.copyWith(
                            counterText: "",
                            hintStyle: Sty().smallText.copyWith(
                                  color: Clr().grey,
                                ),
                            hintText: "Enter OTP sent on linked mobile",
                            border: InputBorder.none,
                            // suffixIcon: aadhar == true
                            //     ? Icon(
                            //         Icons.check_circle,
                            //         color: Clr().green,
                            //       )
                            //     : null,
                          ),
                      validator: (value) {
                        if (value!.isEmpty ||
                            !RegExp(r'(.{6,})').hasMatch(value)) {
                          return Str().invalidOtp;
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: Dim().d12),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.70,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(-1.0, 0.0),
                          end: Alignment(1.0, 0.0),
                          colors: [
                            Color(0xFF30B530),
                            Color(0xFF36B235),
                            Color(0xFF8CDE89),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              submitOtp();
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
                    SizedBox(height: Dim().d8),
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
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
                              requestOtp(true);
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
                    SizedBox(height: Dim().d8),
                  ],
                ),
              );
            },
          ),
        )).show();
  }

  /// verify Pan Card Status
  void verifyPan() async {
    var body = {
      "name": panName.text,
      "pan": panNum.text.toString(),
    };
    var result =
        await STM().post2(ctx, Str().loading, 'panKyc/individualPan', body);
    if (result['message'] == 'User Pan Card Success Verified') {
      setState(() {
        panCheck = true;
        veriPan = 1;
      });
      kycDetail();
    } else {
      if (result['result'] == null) {
        setState(() {
          panCheck = false;
        });
        STM().errorDialog(ctx, result['message']);
      } else {
        setState(() {
          panCheck = false;
        });
        STM().errorDialog(ctx, result['result']['error']['message']);
      }
    }
    // else if (result['result']['error'] != null) {
    //   setState(() {
    //     panCheck = false;
    //   });
    //   STM().errorDialog(ctx, result['result']['error']['message']);
    // } else {
    //   setState(() {
    //     panCheck = false;
    //   });
    //   STM().errorDialog(ctx, result['message']);
    // }
  }

  /// get profile photo for Teacher
  _getProfile(source, type) async {
    if (!kIsWeb) {
      final pickedFile = await ImagePicker().getImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
      );
      if (pickedFile != null) {
        setState(() {
          STM().back2Previous(ctx);
          switch (type) {
            case 'kyc':
              {
                panUrl = pickedFile.path.toString();
                imageFile = File(pickedFile.path.toString());
                var image = imageFile!.readAsBytesSync();
                profile = base64Encode(image);
              }
              break;
            case 'aadhar front':
              {
                aadharFrtUrl = pickedFile.path.toString();
                aadharFrtFile = File(pickedFile.path.toString());
                var image = aadharFrtFile!.readAsBytesSync();
                aadharFrt = base64Encode(image);
              }
              break;
            case 'aadhar back':
              {
                aadharBckUrl = pickedFile.path.toString();
                aadharBckFile = File(pickedFile.path.toString());
                var image = aadharBckFile!.readAsBytesSync();
                aadharBck = base64Encode(image);
              }
              break;
          }
        });
      }
    } else {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          profile = base64Encode(f);
          STM().back2Previous(ctx);
          print(profile);
        });
      }
    }
  }

  // Future<void> getMultipleImageInfos() async {
  //   var bytesFromPicker = await ImagePickerWeb.getImageAsBytes();
  //   setState(() {
  //     var image = bytesFromPicker;
  //     profile = base64Encode(image as List<int>);
  //     STM().back2Previous(ctx);
  //     print(profile);
  //   });
  // }

  imageLayout(side, data) {
    return InkWell(
      onTap: () {
        if (data != null) STM().redirect2page(ctx, viewImage(img: data));
      },
      child: Container(
        height: Dim().d160,
        width: double.infinity,
        decoration: BoxDecoration(border: Border.all(color: Color(0xff6C6C6C))),
        child: data != null
            ? data.toString().contains('https://')
                ? Image.network(data, fit: BoxFit.fitWidth)
                : Image.file(data, fit: BoxFit.fitWidth)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: Dim().d4),
                  SvgPicture.asset('assets/home.svg'),
                  Text(side,
                      style: Sty().mediumText.copyWith(
                            color: Color(0xff6C6C6C),
                            fontSize: Dim().d14,
                            fontWeight: FontWeight.w600,
                          )),
                  SizedBox(height: Dim().d4),
                  Text('You will see uploaded image of your card.',
                      style: Sty().mediumText.copyWith(
                          color: Color(0xff6C6C6C),
                          fontWeight: FontWeight.w400,
                          fontSize: Dim().d12)),
                  SizedBox(height: Dim().d4),
                ],
              ),
      ),
    );
  }

  void kycDetail() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (widget.type == 'edit') {
      FormData body = FormData.fromMap({
        'pan': {
          'number': panNum.text,
          'pan_name': panName.text,
          'image': profile,
          'is_verify': veriPan.toString(),
        },
        'aadhaar': {
          'number': aadharNum.text,
          'is_verify': verify.toString(),
          'aadhar_front': aadharFrt,
          'aadhar_back': aadharBck,
        },
      });
      var result = await STM()
          .postWithToken(ctx, Str().processing, 'kyc-update', body, Token);
      var success = result['success'];
      var message = result['message'];
      if (success) {
        setState(() {
          isChanged = true;
        });
        STM().successDialog(ctx, message, MyAccount());
      } else {
        setState(() {
          isChanged = true;
        });
        STM().errorDialog(ctx, message);
      }
    } else {
      setState(() {
        verify == 0 ? null : isChanged = false;
        sp.setStringList('kycdetailslist', [
          panNum.text,
          profile,
          aadharNum.text,
          verify.toString(),
          veriPan.toString(),
          panName.text,
          aadharFrt,
          aadharBck,
          panUrl.toString(),
          aadharFrtUrl.toString(),
          aadharBckUrl.toString(),
        ]);
        sp.setBool('kyc', true);
        STM().redirect2page(ctx, BankDetails());
        isChanged = true;
      });
    }
  }
}
