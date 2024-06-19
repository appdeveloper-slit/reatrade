import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storak/home.dart';
import 'package:storak/manage/static_method.dart';
import 'package:storak/values/colors.dart';
import 'package:storak/values/dimens.dart';
import 'package:storak/values/styles.dart';

import 'bottom_navigation/bottom_navigation.dart';
import 'demo.dart';
import 'values/strings.dart';

class SellStock extends StatefulWidget {
  final details;

  const SellStock({super.key, required this.details});

  @override
  State<SellStock> createState() => _SellStockState();
}

class _SellStockState extends State<SellStock> {
  late BuildContext ctx;

  String marketValue = '1x';
  dynamic profileList;
  String markettypevalue = 'Market';
  dynamic data;
  var totalAmount;
  List marketList = [
    '1x',
    '2x',
    '3x',
    '4x',
    '5x',
    '6x',
    '7x',
    '8x',
    '9x',
    '10x'
  ];
  List marketype = ['Market', 'Limit'];
  int isSelected = 2;
  String? Token;
  bool? loading;
  TextEditingController priceCtrl = TextEditingController();
  TextEditingController shareCtrl = TextEditingController();

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      Token = sp.getString('token');
    });
    STM().checkInternet(context, widget).then(
      (value) {
        if (value) {
          stockfunt(apiname: 'get_profile', type: 'get', value: null);
          apitype();
          priceCtrl = TextEditingController(
              text: widget.details['last_price'].toString());
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

  late Stream stream = Stream.periodic(Duration(seconds: 5))
      .asyncMap((event) async => await apitype());

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      bottomNavigationBar: bottomBarLayout(ctx, 0, stream, b: true),
      backgroundColor: Clr().white,
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
        title: data == null
            ? Container()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${widget.details['symbol']}',
                        style: Sty().smallText.copyWith(
                              color: Clr().textcolor,
                            ),
                      ),
                      // SizedBox(
                      //   width: Dim().d4,
                      // ),
                      // Container(
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(5),
                      //     color: Clr().white,
                      //   ),
                      //   width: 40,
                      //   height: 20,
                      //   child: Center(
                      //     child: Text(
                      //       'NSE',
                      //       style: Sty().microText.copyWith(
                      //           color: Clr().textcolor, fontWeight: FontWeight.w300),
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                  SizedBox(
                    height: Dim().d4,
                  ),
                  Text(
                    '${widget.details['company_name']}',
                    style: Sty().microText.copyWith(
                          color: Clr().grey,
                        ),
                  ),
                ],
              ),
        actions: [
          data == null
              ? Container()
              : Padding(
                  padding: EdgeInsets.only(right: Dim().d16),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            data['net_change'].toString().contains('-')
                                ? Icon(Icons.arrow_downward_outlined,
                                    color: Clr().red)
                                : Icon(Icons.arrow_upward_outlined,
                                    color: Clr().green),
                            SizedBox(
                              width: Dim().d8,
                            ),
                            Text(
                              '${data['last_price']}',
                              style: Sty().smallText.copyWith(
                                  color: data['net_change']
                                          .toString()
                                          .contains('-')
                                      ? Clr().red
                                      : Clr().green),
                            )
                          ],
                        ),
                        SizedBox(
                          height: Dim().d8,
                        ),
                        Text(
                          '${data['net_change']} (${data['net_change_ercentage']})',
                          style: Sty().microText.copyWith(color: Clr().grey),
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
      body: data == null
          ? Center(
              child: CircularProgressIndicator(color: Clr().primaryColor),
            )
          : StreamBuilder(
              stream: stream,
              builder: (context, AsyncSnapshot snapshot) {
                return Padding(
                  padding: EdgeInsets.all(Dim().d16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex:
                            1, // Adjust flex value to control how much space it takes
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'No. of shares',
                                style: Sty()
                                    .microText
                                    .copyWith(color: Clr().textcolor),
                              ),
                              SizedBox(
                                height: Dim().d12,
                              ),
                              TextFormField(
                                controller: shareCtrl,
                                cursorColor: Clr().primaryColor,
                                style: Sty().mediumText,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.done,
                                decoration:
                                    Sty().textFieldOutlineStyle.copyWith(
                                          hintStyle: Sty().smallText.copyWith(
                                                color: Clr().grey,
                                              ),
                                          filled: true,
                                          fillColor: Clr().white,
                                          hintText: "0",
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
                                onChanged: (v) {
                                  setState(() {
                                    var bb = v.toString();
                                    totalAmountlayut(
                                        share: int.parse(bb.toString()));
                                  });
                                },
                              ),
                              SizedBox(
                                height: Dim().d20,
                              ),
                              Text(
                                'Price',
                                style: Sty()
                                    .microText
                                    .copyWith(color: Clr().textcolor),
                              ),
                              SizedBox(
                                height: Dim().d12,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: priceCtrl,
                                      // readOnly: markettypevalue == 'Market'
                                      //     ? true
                                      //     : false,
                                      cursorColor: Clr().primaryColor,
                                      style: Sty().mediumText,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.done,
                                      decoration: Sty()
                                          .textFieldOutlineStyle
                                          .copyWith(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: Dim().d0,
                                                    horizontal: Dim().d8),
                                            hintStyle: Sty().smallText.copyWith(
                                                  color: Clr().grey,
                                                ),
                                            filled: true,
                                            fillColor: Clr().white,

                                            hintText: "Price",
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
                                      onChanged: (v) {
                                        setState(() {
                                          var bb = v.toString();
                                          totalAmountlayut(
                                              price: int.parse(bb.toString()));
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(width: Dim().d12),
                                  Expanded(
                                    child: Container(
                                      width: 60,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                              color: Clr().borderColor)),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: Dim().d16),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<dynamic>(
                                            // value: sState,
                                            hint: Text(
                                              markettypevalue ??
                                                  'Select Market',
                                              // 'Select State',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: markettypevalue != null
                                                    ? Clr().black
                                                    : Color(0xff787882),
                                                // color: Color(0xff787882),
                                                fontFamily: 'Inter',
                                              ),
                                            ),
                                            isExpanded: true,
                                            icon: SvgPicture.asset(
                                                'assets/dropdown.svg'),
                                            style: TextStyle(
                                                color: markettypevalue != null
                                                    ? Clr().black
                                                    : Color(0xff000000)),
                                            // style: TextStyle(color: Color(0xff787882)),
                                            items: marketype.map((string) {
                                              return DropdownMenuItem<String>(
                                                value: string,
                                                // value: string['id'].toString(),
                                                child: Text(
                                                  string,
                                                  // string['name'],
                                                  style: TextStyle(
                                                      color: Clr().black,
                                                      fontSize: 14),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (v) {
                                              setState(() {
                                                markettypevalue = v.toString();
                                                priceCtrl =
                                                    TextEditingController(
                                                        text: widget.details[
                                                        'last_price']
                                                            .toString());
                                                totalAmountlayut(
                                                    lev: marketValue,
                                                    price: widget
                                                        .details['last_price']
                                                        .toString());
                                              });
                                              // setState(() {
                                              //   // genderValue = v.toString();
                                              //   // int postion = genderlist.indexWhere((element) => element['name'].toString() == v.toString());
                                              //   // stateId = genderlist[postion]['id'].toString();
                                              //   // cityValue = null;
                                              //   // cityList = genderlist[postion]['city'];
                                              // });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: Dim().d20,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Leverage:',
                                    style: Sty()
                                        .microText
                                        .copyWith(color: Clr().textcolor),
                                  ),
                                  SizedBox(
                                    width: Dim().d12,
                                  ),
                                  Container(
                                    width: 60,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: Clr().borderColor)),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: Dim().d8),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<dynamic>(
                                          // value: sState,
                                          hint: Text(
                                            marketValue ?? '1x',
                                            // 'Select State',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: marketValue != null
                                                  ? Clr().black
                                                  : Color(0xff787882),
                                              // color: Color(0xff787882),
                                              fontFamily: 'Inter',
                                            ),
                                          ),
                                          isExpanded: true,
                                          icon: SvgPicture.asset(
                                              'assets/dropdown.svg'),
                                          style: TextStyle(
                                              color: marketValue != null
                                                  ? Clr().black
                                                  : Color(0xff000000)),
                                          // style: TextStyle(color: Color(0xff787882)),
                                          items: marketList.map((string) {
                                            return DropdownMenuItem<String>(
                                              value: string,
                                              // value: string['id'].toString(),
                                              child: Text(
                                                string,
                                                // string['name'],
                                                style: TextStyle(
                                                    color: Clr().black,
                                                    fontSize: 14),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (v) {
                                            setState(() {
                                              marketValue = v.toString();
                                              totalAmountlayut(
                                                  lev: marketValue);
                                            });
                                            // setState(() {
                                            //   // genderValue = v.toString();
                                            //   // int postion = genderlist.indexWhere((element) => element['name'].toString() == v.toString());
                                            //   // stateId = genderlist[postion]['id'].toString();
                                            //   // cityValue = null;
                                            //   // cityList = genderlist[postion]['city'];
                                            // });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: RichText(
                                text: TextSpan(
                                  text: 'Required Amount :',
                                  style: Sty().smallText.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Clr().textcolor,
                                      fontFamily: ''),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text:
                                          ' ₹ ${totalAmount.toString().contains('.') ? double.parse(totalAmount.toString()).toStringAsFixed(2) : totalAmount ?? 00}',
                                      style: Sty().smallText.copyWith(
                                          color: Clr().textcolor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          fontFamily: ''),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: Dim().d12),
                            if (profileList != null)
                              Align(
                                alignment: Alignment.centerRight,
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Funds available :',
                                    style: Sty().smallText.copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Clr().textcolor,
                                        fontFamily: ''),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            ' ₹ ${profileList['wallet'] != null ? profileList['wallet'].toString() : '0'}',
                                        style: Sty().smallText.copyWith(
                                            color: Clr().textcolor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                            fontFamily: ''),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            SizedBox(
                              height: Dim().d12,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 100,
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment(-1.0, 0.0),
                                  end: Alignment(1.0, 0.0),
                                  colors: [
                                    Clr().red,
                                    Clr().errorRed,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: ElevatedButton(
                                  onPressed: () {
                                    // STM().redirect2page(
                                    //     ctx,
                                    //     Verification(
                                    //       mobileCtrl2.text.toString(),
                                    //     ));
                                    totalAmount != null
                                        ? sellStocklayout()
                                        : null;
                                  },
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: Clr().transparent,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5))),
                                  child: Text(
                                    'Sell',
                                    style: Sty().largeText.copyWith(
                                        fontSize: 16,
                                        color: Clr().white,
                                        fontWeight: FontWeight.w600),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
    );
  }

  /// awsome dialog for buying status
  sellStocklayout({value}) {
    var select;
    AwesomeDialog(
        width: double.infinity,
        isDense: true,
        context: ctx,
        dialogType: DialogType.NO_HEADER,
        animType: AnimType.BOTTOMSLIDE,
        body: StatefulBuilder(builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: Dim().d16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Investment',
                      style: Sty().microText.copyWith(color: Clr().grey),
                    ),
                    Text(
                      'Total Quantity',
                      style: Sty().microText.copyWith(color: Clr().grey),
                    ),
                  ],
                ),
                SizedBox(
                  height: Dim().d8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      ' ₹ ${totalAmount.toString().contains('.') ? double.parse(totalAmount.toString()).toStringAsFixed(2) : totalAmount ?? 00}',
                      style: Sty().smallText.copyWith(color: Clr().textcolor),
                    ),
                    Text(
                      '${shareCtrl.text}',
                      style: Sty().smallText.copyWith(color: Clr().textcolor),
                    ),
                  ],
                ),
                SizedBox(
                  height: Dim().d20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Price',
                      style: Sty().microText.copyWith(color: Clr().grey),
                    ),
                    Text(
                      'Service charges',
                      style: Sty().microText.copyWith(color: Clr().grey),
                    ),
                  ],
                ),
                SizedBox(
                  height: Dim().d8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '₹ ${priceCtrl.text}',
                      style: Sty().smallText.copyWith(color: Clr().textcolor),
                    ),
                    Text(
                      '₹ ${00.0}',
                      style: Sty().smallText.copyWith(color: Clr().textcolor),
                    ),
                  ],
                ),
                SizedBox(
                  height: Dim().d20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Leverage',
                      style: Sty().microText.copyWith(color: Clr().grey),
                    ),
                    Text(
                      'Leverage Fee',
                      style: Sty().microText.copyWith(color: Clr().grey),
                    ),
                  ],
                ),
                SizedBox(
                  height: Dim().d8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${marketValue}',
                      style: Sty().smallText.copyWith(color: Clr().textcolor),
                    ),
                    Text(
                      '₹ 00.0',
                      style: Sty().smallText.copyWith(color: Clr().textcolor),
                    ),
                  ],
                ),
                SizedBox(
                  height: Dim().d20,
                ),
                loading == true
                    ? Center(
                        child: CircularProgressIndicator(
                            color: Clr().primaryColor))
                    : Container(
                        width: MediaQuery.of(context).size.width * 100,
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
                              setState(() {
                                loading = true;
                              });
                              stockfunt(
                                  apiname: 'sell_stock',
                                  type: 'post',
                                  value: [
                                    widget.details['id'],
                                    priceCtrl.text,
                                    widget.details['id'],
                                    shareCtrl.text,
                                  ]);
                            },
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Clr().transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                            child: Text(
                              'Proceed',
                              style: Sty().largeText.copyWith(
                                  fontSize: 16,
                                  color: Clr().white,
                                  fontWeight: FontWeight.w600),
                            )),
                      ),
                SizedBox(
                  height: Dim().d20,
                )
              ],
            ),
          );
        })).show();
  }

  /// total amount
  totalAmountlayut({share, price, lev}) {
    int bb = int.parse(shareCtrl.text.toString());
    var cc = priceCtrl.text.toString();
    int aa = int.parse(marketValue.toString().replaceAll(RegExp(r"\D"), ""));
    print('${aa}, ${bb}, ${cc}');
    priceCtrl.text.contains('.')
        ? setState(() {
            totalAmount = aa * bb * double.parse(priceCtrl.text.toString());
          })
        : setState(() {
            totalAmount = aa * bb * int.parse(priceCtrl.text.toString());
          });
  }

  stockfunt({apiname, type, value}) async {
    var data = FormData.fromMap({});
    switch (apiname) {
      case 'buy_stock':
        data = FormData.fromMap({
          'stock_id': value[0],
          'buying_price': value[1],
          'quantity': value[2],
        });
        break;
      case 'sell_stock':
        data = FormData.fromMap({
          'stock_trade_id': value[0],
          'selling_price': value[1],
          'stock_id': value[2],
          'quantity': value[3]
        });
        break;
    }
    FormData body = data;
    var result = type == 'get'
        ? await STM().getWithoutDialog(ctx, apiname, Token)
        : await STM().postListWithoutDialog(ctx, apiname, Token, body);
    var success = result['success'];
    var message = result['message'];
    switch (apiname) {
      case 'get_profile':
        if (result['success']) {
          setState(() {
            profileList = result['data'];
          });
        }else{
          STM().errorDialog(ctx, result['message']);
        }
        break;
      case "sell_stock":
        if (success) {
          setState(() {
            loading = false;
          });
          STM().successDialogWithAffinity(ctx, message, Home());
        } else {
          STM().back2Previous(ctx);
          STM().errorDialog(ctx, message);
        }
        break;
    }
  }

  /// api type
  apitype() async {
    FormData body = FormData.fromMap({'stock_id': widget.details['id']});
    var result =
        await STM().postListWithoutDialog(ctx, 'stock_details', Token, body);
    if (result['success'] == true) {
      setState(() {
        data = result['data'];
      });
    }else{
      STM().errorDialog(ctx, result['message']);
    }
  }
}
