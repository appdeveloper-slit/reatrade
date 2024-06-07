import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storak/manage/static_method.dart';
import 'package:storak/values/colors.dart';
import 'package:storak/values/dimens.dart';
import 'package:storak/values/styles.dart';

import 'my_account.dart';

class paymentPage extends StatefulWidget {
  final String price;

  const paymentPage({super.key, required this.price});

  @override
  State<paymentPage> createState() => _paymentPageState();
}

class _paymentPageState extends State<paymentPage> {
  late BuildContext ctx;
  List imgList = [];
  String? Token;
  TextEditingController refereealcodeCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      Token = sp.getString('token');
    });
    STM().checkInternet(context, widget).then(
      (value) {
        if (value) {
          getProfile(apiname: 'barcode_details', type: 'get');
        }
      },
    );
    print(Token);
  }

  bool check = false;
  @override
  void initState() {
    // TODO: implement initState
    getSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;

    return Scaffold(
      backgroundColor: Clr().black,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            STM().back2Previous(ctx);
          },
          child: Icon(Icons.arrow_back, color: Clr().white),
        ),
        title: Text('Payment Page',
            style: Sty().mediumText.copyWith(color: Clr().white)),
        backgroundColor: Clr().black,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: Dim().d32,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dim().d12),
                    child: RichText(
                        text: TextSpan(
                            text: '₹',
                            style: Sty()
                                .mediumBoldText
                                .copyWith(color: Clr().white),
                            children: [
                          TextSpan(
                              text: '${widget.price}',
                              style: Sty()
                                  .mediumText
                                  .copyWith(color: Clr().white)
                                  .copyWith(fontWeight: FontWeight.w400))
                        ])),
                  ),
                ],
              ),
              // SizedBox(height: Dim().d20),
              // imgList.isEmpty
              //     ? Container()
              //     : Align(
              //         alignment: Alignment.center,
              //         child: SizedBox(
              //           height: Dim().d200,
              //           child: Image.network(
              //             '${imgList[0]['image']}',
              //             fit: BoxFit.contain,
              //           ),
              //         ),
              //       ),
              // SizedBox(height: Dim().d20),
              // imgList.isEmpty
              //     ? Container()
              //     : Padding(
              //         padding: EdgeInsets.symmetric(horizontal: Dim().d12),
              //         child: RichText(
              //           text: TextSpan(
              //             text: 'UPI ID : ',
              //             style:
              //                 Sty().mediumBoldText.copyWith(color: Clr().white),
              //             children: [
              //               TextSpan(
              //                 text: '${imgList[0]['upi_id']}',
              //                 style: Sty().mediumText.copyWith(
              //                       fontWeight: FontWeight.w400,
              //                       color: Clr().white,
              //                     ),
              //               )
              //             ],
              //           ),
              //         ),
              //       ),
              // SizedBox(height: Dim().d20),
              // imgList.isEmpty
              //     ? Container()
              //     : Padding(
              //         padding: EdgeInsets.symmetric(horizontal: Dim().d12),
              //         child: RichText(
              //           text: TextSpan(
              //             text: 'Bank Name : ',
              //             style: Sty().mediumBoldText.copyWith(
              //                   color: Clr().white,
              //                 ),
              //             children: [
              //               TextSpan(
              //                 text: '${imgList[0]['name']}',
              //                 style: Sty().mediumText.copyWith(
              //                       fontWeight: FontWeight.w400,
              //                       color: Clr().white,
              //                     ),
              //               )
              //             ],
              //           ),
              //         ),
              //       ),
              // imgList.isEmpty
              //     ? Container()
              //     : Padding(
              //         padding: EdgeInsets.symmetric(horizontal: Dim().d12),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             RichText(
              //               text: TextSpan(
              //                 text: 'Account No. : ',
              //                 style: Sty().mediumBoldText.copyWith(
              //                       color: Clr().white,
              //                     ),
              //                 children: [
              //                   TextSpan(
              //                     text: '${imgList[0]['account_no']}',
              //                     style: Sty().mediumText.copyWith(
              //                           fontWeight: FontWeight.w400,
              //                           color: Clr().white,
              //                         ),
              //                   )
              //                 ],
              //               ),
              //             ),
              //             IconButton(
              //                 onPressed: () async {
              //                   await Clipboard.setData(ClipboardData(
              //                       text: '${imgList[0]['account_no']}'));
              //                   STM().displayToast(
              //                       'Code Copied!', ToastGravity.BOTTOM);
              //                 },
              //                 icon: Icon(Icons.copy, color: Clr().white)),
              //           ],
              //         ),
              //       ),
              // imgList.isEmpty
              //     ? Container()
              //     : Padding(
              //         padding: EdgeInsets.symmetric(horizontal: Dim().d12),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             RichText(
              //               text: TextSpan(
              //                 text: 'IFSC No. : ',
              //                 style: Sty().mediumBoldText.copyWith(
              //                       color: Clr().white,
              //                     ),
              //                 children: [
              //                   TextSpan(
              //                     text: '${imgList[0]['ifsc_code']}',
              //                     style: Sty().mediumText.copyWith(
              //                           fontWeight: FontWeight.w400,
              //                           color: Clr().white,
              //                         ),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //             IconButton(
              //               onPressed: () async {
              //                 await Clipboard.setData(ClipboardData(
              //                     text: '${imgList[0]['ifsc_code']}'));
              //                 STM().displayToast(
              //                     'Code Copied!', ToastGravity.BOTTOM);
              //               },
              //               icon: Icon(Icons.copy, color: Clr().white),
              //             ),
              //           ],
              //         ),
              //       ),
              // imgList.isEmpty
              //     ? Container()
              //     : Padding(
              //         padding: EdgeInsets.symmetric(horizontal: Dim().d12),
              //         child: RichText(
              //           text: TextSpan(
              //             text: 'Branch Name : ',
              //             style: Sty().mediumBoldText.copyWith(
              //                   color: Clr().white,
              //                 ),
              //             children: [
              //               TextSpan(
              //                 text: '${imgList[0]['branch']}',
              //                 style: Sty().mediumText.copyWith(
              //                       fontWeight: FontWeight.w400,
              //                       color: Clr().white,
              //                     ),
              //               )
              //             ],
              //           ),
              //         ),
              //       ),
              // SizedBox(height: Dim().d20),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: Dim().d12),
              //   child: Container(
              //       height: Dim().d60,
              //       child: ElevatedButton(
              //           onPressed: () async {
              //             await Clipboard.setData(
              //                 ClipboardData(text: '${imgList[0]['upi_id']}'));
              //             STM().displayToast(
              //                 'Code Copied!', ToastGravity.BOTTOM);
              //           },
              //           style: ElevatedButton.styleFrom(
              //               shape: RoundedRectangleBorder(
              //                   borderRadius: BorderRadius.circular(Dim().d12)),
              //               backgroundColor: Clr().primaryColor),
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               Padding(
              //                 padding: EdgeInsets.only(left: 12.0),
              //                 child: Icon(
              //                   Icons.copy,
              //                   color: Clr().white,
              //                 ),
              //               ),
              //               Text(
              //                 'Copy UPI ID',
              //                 style:
              //                     Sty().mediumText.copyWith(color: Clr().white),
              //               ),
              //               SizedBox(width: Dim().d56)
              //             ],
              //           ))),
              // ),
              SizedBox(height: Dim().d20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dim().d12),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dim().d12),
                      border: Border.all(color: Clr().primaryColor)),
                  child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Text(
                            '1.Open your UPI app and complete the payment',
                            style: Sty().mediumText.copyWith(
                                  color: Clr().white,
                                ),
                          ),
                          SizedBox(height: Dim().d12),
                          Text(
                            '2.Copy your reference No.(Ref No.) after transfer',
                            style: Sty().mediumText.copyWith(
                                  color: Clr().white,
                                ),
                          )
                        ],
                      )),
                ),
              ),
              SizedBox(height: Dim().d20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dim().d12),
                child: TextFormField(
                  controller: refereealcodeCtrl,
                  decoration: Sty().TextFormFieldOutlineDarkStyle.copyWith(
                      fillColor: Clr().white,
                      filled: true,
                      hintText: 'Enter UTR No./UPI ID/Reference No.',
                      hintStyle:
                          Sty().smallText.copyWith(color: Clr().hintColor)),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the UTR No./UPI ID/Reference No.';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: Dim().d20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dim().d12),
                child: Container(
                    height: Dim().d60,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          refereealcodeCtrl.text.isEmpty
                              ? STM().displayToast(
                                  'Please enter the UTR No./UPI ID/Reference No.',
                                  ToastGravity.BOTTOM)
                              : getProfile(
                                  apiname: 'recharge_request', type: 'post');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Dim().d12)),
                          backgroundColor: Clr().primaryColor),
                      child: Text(
                        'Submit',
                        style: Sty().mediumText.copyWith(color: Clr().white),
                      ),
                    )),
              ),
              SizedBox(height: Dim().d20),
            ],
          ),
        ),
      ),
    );
  }

  ///getprofile
  getProfile({apiname, type, value}) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var data = FormData.fromMap({});
    switch (apiname) {
      case 'recharge_request':
        data = FormData.fromMap({
          'amount': widget.price,
          'utr_number': refereealcodeCtrl.text,
        });
        break;
    }
    FormData body = data;
    var result = type == 'post'
        ? await STM().postListWithoutDialog(ctx, apiname, Token, body)
        : await STM().getWithoutDialog(ctx, apiname, Token);
    switch (apiname) {
      case 'barcode_details':
        if (result['success']) {
          setState(() {
            imgList = result['data'];
          });
        } else {
          STM().errorDialog(ctx, result['message']);
        }
        break;
      case 'recharge_request':
        if (result['success']) {
          STM().successDialogWithReplace(ctx, result['message'], MyAccount());
        } else {
          STM().errorDialog(ctx, result['message']);
        }
        break;
    }
  }
}
