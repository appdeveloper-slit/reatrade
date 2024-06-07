import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:storak/home.dart';
import 'package:storak/otp.dart';
import 'package:storak/sign_in.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'manage/static_method.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class UpdateBankDetails extends StatefulWidget {
  const UpdateBankDetails({super.key});

  @override
  State<UpdateBankDetails> createState() => _UpdateBankDetailsState();
}

class _UpdateBankDetailsState extends State<UpdateBankDetails> {
  late BuildContext ctx;

  String? accountValue;
  List<dynamic> accountlist = [];

  bool isChanged = true;

  TextEditingController mobileCtrl2 = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Clr().black,
      bottomNavigationBar: bottomBarLayout(ctx, 0, '', b: true),
      appBar: AppBar(
        elevation: 1,
        shadowColor: Clr().lightShadow,
        backgroundColor: Color(0xffF8F9F8),
        leadingWidth: 40,
        leading: InkWell(
          onTap: () {
            STM().back2Previous(ctx);
          },
          child: Padding(
            padding: EdgeInsets.only(left: Dim().d16),
            child: SvgPicture.asset('assets/back.svg'),
          ),
        ),
        title: Text(
          'Bank Details',
          style: Sty()
              .mediumText
              .copyWith(color: Clr().textcolor, fontWeight: FontWeight.w600),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(Dim().d16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: Dim().d20,
                  ),
                  TextFormField(
                    controller: mobileCtrl2,
                    cursorColor: Clr().primaryColor,
                    style: Sty().mediumText,
                    maxLength: 10,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.done,
                    decoration: Sty().textFieldOutlineStyle.copyWith(
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(Dim().d12),
                            child: SvgPicture.asset('assets/user.svg'),
                          ),
                          hintStyle: Sty().smallText.copyWith(
                                color: Clr().grey,
                              ),
                          filled: true,
                          fillColor: Clr().white,

                          hintText: "Enter Name",
                          counterText: "",
                          // prefixIcon: Icon(
                          //   Icons.call,
                          //   color: Clr().lightGrey,
                          // ),
                        ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return Str().invalidMobile;
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: Dim().d4,
                  ),
                  RichText(
                    text: TextSpan(
                      text: '*',
                      style: Sty().smallText.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Clr().red,
                          fontFamily: ''),
                      children: <TextSpan>[
                        TextSpan(
                          text:
                              ' as mentioned in your passbook or bank account  ',
                          style: Sty().mediumText.copyWith(
                              color: Clr().grey,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              fontFamily: ''),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Dim().d8,
                  ),
                  TextFormField(
                    controller: mobileCtrl2,
                    cursorColor: Clr().primaryColor,
                    style: Sty().mediumText,
                    maxLength: 10,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    decoration: Sty().textFieldOutlineStyle.copyWith(
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(Dim().d12),
                            child: SvgPicture.asset('assets/bank.svg'),
                          ),
                          hintStyle: Sty().smallText.copyWith(
                                color: Clr().grey,
                              ),
                          filled: true,
                          fillColor: Clr().white,

                          hintText: "Enter Bank Name",
                          counterText: "",
                          // prefixIcon: Icon(
                          //   Icons.call,
                          //   color: Clr().lightGrey,
                          // ),
                        ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return Str().invalidEmail;
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: Dim().d12,
                  ),
                  TextFormField(
                    controller: mobileCtrl2,
                    cursorColor: Clr().primaryColor,
                    style: Sty().mediumText,
                    maxLength: 10,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    decoration: Sty().textFieldOutlineStyle.copyWith(
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(Dim().d12),
                            child:
                                SvgPicture.asset('assets/account_number.svg'),
                          ),
                          hintStyle: Sty().smallText.copyWith(
                                color: Clr().grey,
                              ),
                          filled: true,
                          fillColor: Clr().white,

                          hintText: "Enter Account Number",
                          counterText: "",
                          // prefixIcon: Icon(
                          //   Icons.call,
                          //   color: Clr().lightGrey,
                          // ),
                        ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return Str().invalidEmail;
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: Dim().d12,
                  ),
                  TextFormField(
                    controller: mobileCtrl2,
                    cursorColor: Clr().primaryColor,
                    style: Sty().mediumText,
                    maxLength: 10,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    decoration: Sty().textFieldOutlineStyle.copyWith(
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(Dim().d12),
                            child: SvgPicture.asset('assets/ifsc.svg'),
                          ),
                          hintStyle: Sty().smallText.copyWith(
                                color: Clr().grey,
                              ),
                          filled: true,
                          fillColor: Clr().white,

                          hintText: "Enter IFSC Code",
                          counterText: "",
                          // prefixIcon: Icon(
                          //   Icons.call,
                          //   color: Clr().lightGrey,
                          // ),
                        ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return Str().invalidEmail;
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: Dim().d12,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Clr().borderColor)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dim().d12),
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/account.svg',
                              color: Clr().grey, width: 25),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: Dim().d12,
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<dynamic>(
                                  // value: sState,
                                  hint: Text(
                                    accountValue ?? 'Current Account',
                                    // 'Select State',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: accountValue != null
                                          ? Clr().black
                                          : Color(0xff787882),
                                      // color: Color(0xff787882),
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  isExpanded: true,
                                  icon: Icon(Icons.arrow_drop_down),
                                  style: TextStyle(
                                      color: accountValue != null
                                          ? Clr().black
                                          : Color(0xff000000)),
                                  // style: TextStyle(color: Color(0xff787882)),
                                  items: accountlist.map((string) {
                                    return DropdownMenuItem<String>(
                                      value: string[''],
                                      // value: string['id'].toString(),
                                      child: Text(
                                        string['name'],
                                        // string['name'],
                                        style: TextStyle(
                                            color: Clr().black, fontSize: 14),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (v) {
                                    setState(() {
                                      // accountValue = v.toString();
                                      // int postion = accountlist.indexWhere((element) => element['name'].toString() == v.toString());
                                      // stateId = accountlist[postion]['id'].toString();
                                      // cityValue = null;
                                      // cityList = accountlist[postion]['city'];
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Dim().d12,
                  ),
                  DottedBorder(
                    color: Clr().accentColor, //color of dotted/dash line
                    strokeWidth: 1, //thickness of dash/dots
                    dashPattern: [6, 4],
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 14),
                        child: Row(
                          children: [
                            SvgPicture.asset('assets/upload.svg'),
                            SizedBox(
                              width: Dim().d20,
                            ),
                            Text(
                              'Upload Cheque / Passbook',
                              style: Sty().smallText.copyWith(
                                    color: Clr().grey,
                                  ),
                            )
                          ],
                        )),
                  ),
                  SizedBox(
                    height: Dim().d32,
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 60),
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
                        borderRadius: isChanged
                            ? BorderRadius.circular(5)
                            : BorderRadius.circular(5)),
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          isChanged = !isChanged;
                        });
                        await Future.delayed(Duration(milliseconds: 60));
                        STM().redirect2page(ctx, Home());
                        // updateProfile();
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          primary: Colors.transparent,
                          onSurface: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                      child: isChanged
                          ? Text(
                              'Update',
                              style: Sty().largeText.copyWith(
                                  fontSize: 16,
                                  color: Clr().white,
                                  fontWeight: FontWeight.w600),
                            )
                          : Icon(Icons.done, size: 35),

                      //     : Lottie.asset('animations/tick.json',
                      //     height: 100,
                      //     reverse: false,
                      //     repeat: true,
                      //     fit: BoxFit.cover
                      // ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

// void sendOtp() async {
//   FormData body = FormData.fromMap({
//     'phone': mobileCtrl.text,
//     'action': 'login',
//   });
//   var result = await STM().post(ctx, Str().sendingOtp, 'send_otp', body);
//   var success = result['success'];
//   var message = result['message'];
//   if (success) {
//     STM().displayToast(message);
//     // STM().redirect2page(
//     //   ctx,
//     //   Verification(
//     //     semailCtrl: '',
//     //     snameCtrl: '',
//     //     sAction: 'login',
//     //     smobileCtrl: mobileCtrl.text,
//     //   ),
//     // );
//   } else {
//     STM().errorDialog(ctx, message);
//   }
// }
}
