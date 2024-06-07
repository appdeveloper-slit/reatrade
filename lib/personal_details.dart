import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storak/otp.dart';
import 'package:storak/sign_in.dart';
import 'kyc_details.dart';
import 'manage/static_method.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class PersonalDetails extends StatefulWidget {
  final mobile;

  const PersonalDetails({super.key, this.mobile});

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  late BuildContext ctx;

  String? genderValue;
  List<dynamic> genderlist = ['Male', 'Female', 'Other'];
  bool isChanged = true;
  bool loading = true;
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController dateofbirthCtrl = TextEditingController();
  TextEditingController referralCtrl = TextEditingController();

  Future datePicker() async {
    DateTime? picked = await showDatePicker(
      context: ctx,
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.light(primary: Clr().primaryColor),
          ),
          child: child!,
        );
      },
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      //Disabled past date
      // firstDate: DateTime.now().subtract(Duration(days: 1)),
      // Disabled future date
      // lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        String s = STM().dateFormat('yyyy-MM-dd', picked);
        dateofbirthCtrl = TextEditingController(text: s);
      });
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return WillPopScope(
      onWillPop: () async {
        STM().finishAffinity(ctx, SignIn());
        return false;
      },
      child: Scaffold(
          // extendBodyBehindAppBar: false,
          // resizeToAvoidBottomInset: false,
          backgroundColor: Clr().black,
          appBar: AppBar(
            leading: InkWell(
              onTap: () {
                STM().finishAffinity(ctx, SignIn());
              },
              child: Icon(
                Icons.arrow_back,
                color: Clr().white,
              ),
            ),
            backgroundColor: Clr().black,
            elevation: 0,
            title: SvgPicture.asset(
              'assets/progress_pg.svg',
              color: Clr().primaryColor,
            ),
          ),
          body: STM().Contat(
            ctx,
            Form(
              key: _formKey,
              child: Stack(
                children: [
                  // Positioned(
                  //   left: 0,
                  //   right: 0,
                  //   bottom: 0,
                  //   child: Image.asset('assets/bottom_chart.png'),
                  // ),
                  // SvgPicture.asset('assets/bottom_chart.svg')),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(Dim().d16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Personal Details',
                            style: Sty().extraLargeText.copyWith(),
                          ),
                          // SizedBox(
                          //   height: Dim().d12,
                          // ),
                          // Text(
                          //   'Lorem ipsum dolor sit amet consectetur.',
                          //   style: Sty().smallText.copyWith(
                          //         color: Clr().textcolor,
                          //       ),
                          // ),
                          SizedBox(
                            height: Dim().d32,
                          ),
                          TextFormField(
                            textCapitalization: TextCapitalization.words,
                            controller: nameCtrl,
                            cursorColor: Clr().primaryColor,
                            style:
                                Sty().mediumText.copyWith(color: Clr().white),
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
                                  // filled: true,
                                  // fillColor: Clr().white,
                                  hintText: "Enter Name",
                                  counterText: "",
                                  // prefixIcon: Icon(
                                  //   Icons.call,
                                  //   color: Clr().lightGrey,
                                  // ),
                                ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Name field is required';
                              }
                            },
                          ),
                          SizedBox(
                            height: Dim().d12,
                          ),
                          TextFormField(
                            controller: emailCtrl,
                            cursorColor: Clr().primaryColor,
                            style:
                                Sty().mediumText.copyWith(color: Clr().white),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                            decoration: Sty().textFieldOutlineStyle.copyWith(
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(Dim().d12),
                                    child: SvgPicture.asset('assets/mail.svg'),
                                  ),
                                  hintStyle: Sty().smallText.copyWith(
                                        color: Clr().grey,
                                      ),
                                  hintText: "Enter Email Address",
                                  counterText: "",
                                  // prefixIcon: Icon(
                                  //   Icons.call,
                                  //   color: Clr().lightGrey,
                                  // ),
                                ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Email is required';
                              }
                              if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                                return "Please enter a valid email address";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: Dim().d12,
                          ),
                          TextFormField(
                            controller: dateofbirthCtrl,
                            readOnly: true,
                            cursorColor: Clr().primaryColor,
                            style:
                                Sty().mediumText.copyWith(color: Clr().white),
                            onTap: () {
                              datePicker();
                            },
                            maxLength: 10,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                            decoration: Sty().textFieldOutlineStyle.copyWith(
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(Dim().d12),
                                    child:
                                        SvgPicture.asset('assets/calender.svg'),
                                  ),
                                  hintStyle: Sty().smallText.copyWith(
                                        color: Clr().grey,
                                      ),
                                  hintText: dateofbirthCtrl.text.isEmpty
                                      ? "Date Of Birth"
                                      : dateofbirthCtrl.text,
                                  counterText: "",
                                  // prefixIcon: Icon(
                                  //   Icons.call,
                                  //   color: Clr().lightGrey,
                                  // ),
                                ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Date of birth is required';
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(
                            height: Dim().d12,
                          ),
                          DropdownButtonHideUnderline(
                            child: DropdownButtonFormField<dynamic>(
                              // value: sState,
                              validator: (value) {
                                if (value == null) {
                                  return 'Gender is required';
                                }
                              },
                              hint: Text(
                                genderValue ?? 'Gender',
                                // 'Select State',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: genderValue != null
                                      ? Clr().white
                                      : Clr().white,
                                  // color: Color(0xff787882),
                                  fontFamily: 'Inter',
                                ),
                              ),
                              decoration: Sty()
                                  .TextFormFieldOutlineDarkStyle
                                  .copyWith(
                                      fillColor: Clr().black,
                                      filled: true,
                                      prefix: Padding(
                                        padding: EdgeInsets.only(right: 12.0),
                                        child: SvgPicture.asset(
                                            'assets/gender.svg'),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.zero,
                                          borderSide: BorderSide(
                                              color: Clr().lightGrey)),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.zero,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.zero,
                                          borderSide: BorderSide(
                                              color: Clr().lightGrey)),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.zero,
                                      )),
                              isExpanded: true,

                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Clr().primaryColor,
                              ),
                              dropdownColor: Clr().black,
                              style: TextStyle(
                                  color: genderValue != null
                                      ? Clr().white
                                      : Clr().white),
                              // style: TextStyle(color: Color(0xff787882)),
                              items: genderlist.map((string) {
                                return DropdownMenuItem<String>(
                                  value: string.toString(),
                                  // value: string['id'].toString(),
                                  child: Text(
                                    string,
                                    // string['name'],
                                    style: TextStyle(
                                        color: Clr().white, fontSize: 14),
                                  ),
                                );
                              }).toList(),
                              onChanged: (v) {
                                setState(() {
                                  genderValue = v.toString();
                                  // int postion = genderlist.indexWhere((element) => element['name'].toString() == v.toString());
                                  // stateId = genderlist[postion]['id'].toString();
                                  // cityValue = null;
                                  // cityList = genderlist[postion]['city'];
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: Dim().d12,
                          ),
                          TextFormField(
                            controller: referralCtrl,
                            cursorColor: Clr().primaryColor,
                            style:
                                Sty().mediumText.copyWith(color: Clr().white),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            decoration: Sty().textFieldOutlineStyle.copyWith(
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(Dim().d12),
                                    child: Icon(Icons.my_library_books_outlined,
                                        color: Color(0xffC2C2C2)),
                                  ),
                                  hintStyle: Sty().smallText.copyWith(
                                        color: Clr().grey,
                                      ),
                                  // filled: true,
                                  // fillColor: Clr().white,
                                  hintText: "Enter Referral Code",
                                  counterText: "",
                                  // prefixIcon: Icon(
                                  //   Icons.call,
                                  //   color: Clr().lightGrey,
                                  // ),
                                ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Referral code is required';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: Dim().d32,
                          ),
                          loading
                              ? AnimatedContainer(
                                  duration: Duration(milliseconds: 60),
                                  width:
                                      MediaQuery.of(context).size.width * 0.70,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Clr().primaryColor,
                                      borderRadius: isChanged
                                          ? BorderRadius.circular(5)
                                          : BorderRadius.circular(5)),
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          personalDetails();
                                        }
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
                                        'Next',
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
                                )
                              : CircularProgressIndicator(
                                  color: Clr().primaryColor),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }

  void personalDetails() async {
    setState(() {
      loading = false;
    });
    SharedPreferences sp = await SharedPreferences.getInstance();
    FormData body = FormData.fromMap({
      "phone": widget.mobile,
      "name": nameCtrl.text,
      "email": emailCtrl.text,
      "dob": dateofbirthCtrl.text, // date should be Y-m-d format
      "gender": genderValue == 'Male'
          ? 'male'
          : genderValue == 'Female'
              ? 'female'
              : 'other',
      'referral_code': referralCtrl.text,
    });
    var result = await STM().postWithoutDialog(ctx, 'register', body);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      STM().displayToast(message, ToastGravity.CENTER);
      setState(() {
        sp.setBool('personal', true);
        sp.setString('token', result['token']);
        loading = true;
      });
      STM().replacePage(ctx, KYCDetails());
    } else {
      setState(() {
        loading = true;
      });
      STM().errorDialog(ctx, message);
    }
  }
}
