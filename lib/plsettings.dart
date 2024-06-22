// ignore_for_file: prefer_const_constructors

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storak/manage/static_method.dart';
import 'package:storak/my_account.dart';
import 'package:storak/notification.dart';
import 'package:storak/values/colors.dart';
import 'package:storak/values/dimens.dart';
import 'package:storak/values/styles.dart';

class plSettings extends StatefulWidget {
  const plSettings({super.key});

  @override
  State<plSettings> createState() => _plSettingsState();
}

class _plSettingsState extends State<plSettings> {
  late BuildContext ctx;
  TextEditingController profitCtrl = TextEditingController();
  TextEditingController lossCtrl = TextEditingController();
  String? Token;
  final _formKey = GlobalKey<FormState>();

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      Token = sp.getString('token');
    });

    STM().checkInternet(context, widget).then(
      (value) {
        if (value) {
          apiCall(apiname: 'limit_setting', type: 'get');
        }
      },
    );
    print(Token);
  }

  @override
  void initState() {
    // TODO: implement initState
    getSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return WillPopScope(
      onWillPop: () async {
        STM().redirect2page(ctx, MyAccount(type: 0));
        return false;
      },
      child: Scaffold(
        backgroundColor: Clr().black,
        appBar: AppBar(
          elevation: 0,
          shadowColor: Clr().lightShadow,
          backgroundColor: Clr().black,
          leadingWidth: 40,
          leading: InkWell(
            onTap: () {
              STM().redirect2page(ctx, MyAccount(type: 0));
            },
            child: Padding(
              padding: EdgeInsets.only(left: Dim().d16),
              child: SvgPicture.asset(
                'assets/back.svg',
                color: Clr().white,
              ),
            ),
          ),
          centerTitle: true,
          title: Text(
            'P/L Limit Settings',
            style: Sty().mediumText.copyWith(
                color: Clr().primaryColor,
                fontSize: Dim().d20,
                fontWeight: FontWeight.w600),
          ),
          actions: [
            // Padding(
            //   padding: EdgeInsets.all(Dim().d16),
            //   child: InkWell(
            //       onTap: () {
            //         STM().redirect2page(ctx, Notifications());
            //       },
            //       child: SvgPicture.asset('assets/bell.svg')),
            // )
          ],
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Profit Limit:-',
                      style: Sty().mediumText.copyWith(color: Clr().white),
                    ),
                    SizedBox(width: Dim().d8),
                    Expanded(
                        child: TextFormField(
                      controller: profitCtrl,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please add profit limit';
                        }
                        if (int.parse(value.toString()) < 100) {
                          return 'Please put profit limit greater than 100';
                        }
                        if (int.parse(value.toString()) > 400) {
                          return 'Please put profit limit less than 400';
                        }
                      },
                      decoration: Sty().TextFormFieldOutlineDarkStyle.copyWith(
                            fillColor: Clr().background,
                            filled: true,
                            suffixText: '%',
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 0.5),
                                borderRadius: BorderRadius.all(Radius.zero)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 0.5),
                                borderRadius: BorderRadius.all(Radius.zero)),
                          ),
                    )),
                    SizedBox(width: Dim().d8),
                    Expanded(
                        child: Text('{Range: 100% - 400%}',
                            style:
                                Sty().mediumText.copyWith(color: Clr().white)))
                  ],
                ),
                SizedBox(height: Dim().d20),
                Row(
                  children: [
                    Text(
                      'Loss Limit:-',
                      style: Sty().mediumText.copyWith(color: Clr().white),
                    ),
                    SizedBox(width: Dim().d12),
                    Expanded(
                        child: TextFormField(
                      controller: lossCtrl,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please add loss limit';
                        }
                        if (int.parse(value.toString()) < 10) {
                          return 'Please put loss limit greater than -10';
                        }
                        if (int.parse(value.toString()) > 70) {
                          return 'Please put loss limit less than -70';
                        }
                      },
                      decoration: Sty().TextFormFieldOutlineDarkStyle.copyWith(
                            fillColor: Clr().background,
                            filled: true,
                            prefixText: '-',
                            suffixText: '%',
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 0.5),
                                borderRadius: BorderRadius.all(Radius.zero)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 0.5),
                                borderRadius: BorderRadius.all(Radius.zero)),
                          ),
                    )),
                    SizedBox(width: Dim().d8),
                    Expanded(
                      child: Text('{Range: -70% - -10%}',
                          style: Sty().mediumText.copyWith(
                              color: Clr().white,
                              fontSize: Dim().d14,
                              fontWeight: FontWeight.w400)),
                    ),
                  ],
                ),
                SizedBox(height: Dim().d20),
                Container(
                  width: MediaQuery.of(context).size.width * 100,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Clr().primaryColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          apiCall(
                              apiname: 'update_limit_setting', type: 'post');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Clr().transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                      child: Text(
                        'Update',
                        style: Sty().largeText.copyWith(
                            fontSize: 16,
                            color: Clr().white,
                            fontWeight: FontWeight.w600),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///getprofile
  apiCall({apiname, type, value}) async {
    var data = FormData.fromMap({});
    switch (apiname) {
      case 'update_limit_setting':
        data = FormData.fromMap({
          'profit_limit': profitCtrl.text,
          'stop_loss_limit': lossCtrl.text,
        });
        break;
    }
    FormData body = data;
    var result = type == 'post'
        ? await STM().postListWithoutDialog(ctx, apiname, Token, body)
        : await STM().getWithoutDialog(ctx, apiname, Token);
    switch (apiname) {
      case 'limit_setting':
        if (result['success']) {
          setState(() {
            profitCtrl = TextEditingController(
                text: result['data']['profit_limit'].toString());
            lossCtrl = TextEditingController(
                text: result['data']['stop_loss_limit'].toString());
          });
        } else {
          STM().errorDialog(ctx, result['message']);
        }
        break;
      case 'update_limit_setting':
        if (result['success']) {
          STM().successDialog(ctx, result['message'], widget);
        } else {
          STM().errorDialog(ctx, result['message']);
        }
        break;
    }
  }
}
