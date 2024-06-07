import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storak/manage/static_method.dart';
import 'package:storak/paymentpage.dart';
import 'package:storak/sellpage2.dart';
import 'package:storak/values/colors.dart';
import 'package:storak/values/dimens.dart';
import 'package:storak/values/strings.dart';
import 'package:storak/values/styles.dart';

import 'bottom_navigation/bottom_navigation.dart';

class SellPage extends StatefulWidget {
  final dynamic details;

  const SellPage({super.key, this.details});

  @override
  State<SellPage> createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {
  late BuildContext ctx;
  dynamic data;
  String? Token;
  TextEditingController valueCtrl = TextEditingController();
  var prepayment;

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      Token = sp.getString('token');
      prepayment = widget.details['pre_payment'];
    });
    STM().checkInternet(context, widget).then(
      (value) {
        if (value) {
          apitype();
        }
      },
    );
    print(Token);
  }

  late Stream stream = Stream.periodic(Duration(seconds: 5))
      .asyncMap((event) async => await apitype());

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
      bottomNavigationBar: bottomBarLayout(ctx, 1, stream),
      appBar: AppBar(
        elevation: 1,
        shadowColor: Clr().lightShadow,
        backgroundColor: Clr().black,
        leadingWidth: 40,
        leading: InkWell(
          onTap: () {
            STM().back2Previous(ctx);
          },
          child: Padding(
            padding: EdgeInsets.only(left: Dim().d16),
            child: SvgPicture.asset(
              'assets/back.svg',
              color: Clr().white,
            ),
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
                        '${data['symbol']}',
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
                    '${data['company_name']}',
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
      body: RefreshIndicator(
        onRefresh: () async {
          return Future.delayed(const Duration(seconds: 3), () {
            setState(() {
              apitype();
            });
          });
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/stockicon.svg',
                          color: Clr().white,
                        ),
                        SizedBox(width: Dim().d8),
                        SvgPicture.asset(
                          'assets/stockstatus.svg',
                          color: Clr().white,
                        ),
                      ],
                    ),
                    StreamBuilder(
                        stream: stream,
                        builder: (context, AsyncSnapshot snapshot) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${DateFormat('dd MMMM yyyy').format(DateTime.parse(widget.details['buy_at']))}',
                                style: Sty().smallText.copyWith(
                                      color: Clr().white,
                                      fontWeight: FontWeight.w200,
                                    ),
                              ),
                              SizedBox(height: Dim().d4),
                              Text(
                                '${DateFormat('h:mm a').format(DateTime.parse(widget.details['buy_at']))}',
                                style: Sty().smallText.copyWith(
                                      color: Clr().white,
                                      fontWeight: FontWeight.w200,
                                    ),
                              ),
                            ],
                          );
                        })
                  ],
                ),
                SizedBox(height: Dim().d12),
                Divider(
                  color: Color(0xff6C6C6C),
                  thickness: 1,
                ),
                SizedBox(height: Dim().d20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Buy Price',
                      style: Sty().microText.copyWith(color: Clr().grey),
                    ),
                    Text(
                      'Quantity',
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
                      ' ₹ ${widget.details['buying_price']}',
                      style: Sty().smallText.copyWith(color: Clr().textcolor),
                    ),
                    Text(
                      '${widget.details['quantity']}',
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
                      'Leverage Amount',
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
                      '${widget.details['leverage']}x',
                      style: Sty().smallText.copyWith(color: Clr().textcolor),
                    ),
                    Text(
                      '₹ ${widget.details['leverage_amount']}',
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
                      'Pre-Payment',
                      style: Sty().microText.copyWith(color: Clr().grey),
                    ),
                    Text(
                      'Market Value',
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
                      '₹ ${prepayment}',
                      style: Sty().smallText.copyWith(color: Clr().textcolor),
                    ),
                    Text(
                      '₹ ${(widget.details['buying_price'] * widget.details['quantity']).toString().contains('.') ? double.parse((widget.details['buying_price'] * widget.details['quantity']).toString()).toStringAsFixed(2) : (widget.details['buying_price'] * widget.details['quantity'])}',
                      style: Sty().smallText.copyWith(color: Clr().textcolor),
                    ),
                  ],
                ),
                SizedBox(height: Dim().d28),
                Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffC2C2C2), width: 0.6),
                      borderRadius: BorderRadius.circular(Dim().d12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(Dim().d14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                              text: TextSpan(
                                  text: 'Floating P/L:- ',
                                  style: Sty()
                                      .mediumText
                                      .copyWith(color: Clr().grey),
                                  children: [
                                TextSpan(
                                    text:
                                        '₹ ${widget.details['floating_p_l'].toString().contains('.') ? double.parse(widget.details['floating_p_l'].toString()).toStringAsFixed(2) : widget.details['floating_p_l'].toString()} (${widget.details['floating_p_l_percent'].toString().contains('.') ? double.parse(widget.details['floating_p_l_percent'].toString()).toStringAsFixed(2) : widget.details['floating_p_l_percent'].toString()}%)',
                                    style: Sty().mediumText.copyWith(
                                          color: Clr().white,
                                        ))
                              ])),
                          SizedBox(height: Dim().d12),
                          RichText(
                              text: TextSpan(
                                  text: 'Transaction Fees:- ',
                                  style: Sty()
                                      .mediumText
                                      .copyWith(color: Clr().grey),
                                  children: [
                                TextSpan(
                                    text:
                                        '₹ ${widget.details['transaction_fee'].toString().contains('.') ? double.parse(widget.details['transaction_fee'].toString()).toStringAsFixed(2) : widget.details['transaction_fee'].toString()}',
                                    style: Sty().mediumText.copyWith(
                                          color: Clr().white,
                                        ))
                              ])),
                          SizedBox(height: Dim().d12),
                          RichText(
                              text: TextSpan(
                                  text: 'Deferred Fees:- ',
                                  style: Sty()
                                      .mediumText
                                      .copyWith(color: Clr().grey),
                                  children: [
                                TextSpan(
                                    text:
                                        '₹ ${widget.details['deffered_fee'].toString().contains('.') ? double.parse(widget.details['deffered_fee'].toString()).toStringAsFixed(2) : widget.details['deffered_fee'].toString()}',
                                    style: Sty().mediumText.copyWith(
                                          color: Clr().white,
                                        ))
                              ])),
                          SizedBox(height: Dim().d12),
                          RichText(
                              text: TextSpan(
                                  text: 'Net Floating P/L:- ',
                                  style: Sty()
                                      .mediumText
                                      .copyWith(color: Clr().grey),
                                  children: [
                                TextSpan(
                                    text:
                                        '₹ ${widget.details['net_floating_p_l'].toString().contains('.') ? double.parse(widget.details['net_floating_p_l'].toString()).toStringAsFixed(2) : widget.details['net_floating_p_l'].toString()} (${widget.details['net_floating_p_l_percent'].toString().contains('.') ? double.parse(widget.details['net_floating_p_l_percent'].toString()).toStringAsFixed(2) : widget.details['net_floating_p_l_percent'].toString()}%)',
                                    style: Sty().mediumText.copyWith(
                                          color: Clr().white,
                                        ))
                              ])),
                        ],
                      ),
                    )),
                SizedBox(height: Dim().d32),
                Row(
                  children: [
                    Expanded(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.fromLTRB(5, 20, 5, 20),
                            padding: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1, color: Color(0xff278225)),
                              borderRadius: BorderRadius.circular(12),
                              shape: BoxShape.rectangle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: Dim().d12),
                                  Text('Lost Value',
                                      style: Sty()
                                          .mediumText
                                          .copyWith(color: Clr().grey)),
                                  SizedBox(height: Dim().d4),
                                  Text(
                                      '₹ ${widget.details['stop_loss_limit']} (${widget.details['stop_loss_limit_percentage'].toString().contains('.') ? double.parse(widget.details['stop_loss_limit_percentage'].toString()).toStringAsFixed(2) : widget.details['stop_loss_limit_percentage'].toString()}%)',
                                      style: Sty().mediumText.copyWith(
                                            color: Clr().white,
                                          ))
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 20,
                            top: 12,
                            child: Container(
                              padding: EdgeInsets.only(
                                  bottom: 5, left: 10, right: 10),
                              color: Clr().background,
                              child: Text(
                                'Stoploss Limit',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.fromLTRB(5, 20, 5, 20),
                            padding: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1, color: Color(0xff278225)),
                              borderRadius: BorderRadius.circular(12),
                              shape: BoxShape.rectangle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: Dim().d12),
                                  Text('Profit Value',
                                      style: Sty()
                                          .mediumText
                                          .copyWith(color: Clr().grey)),
                                  SizedBox(height: Dim().d4),
                                  Text(
                                      '₹ ${widget.details['profit_limit']} (${widget.details['profit_limit_percentage'].toString().contains('.') ? double.parse(widget.details['profit_limit_percentage'].toString()).toStringAsFixed(2) : widget.details['profit_limit_percentage'].toString()}%)',
                                      style: Sty().mediumText.copyWith(
                                            color: Clr().white,
                                          ))
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 20,
                            top: 12,
                            child: Container(
                              padding: EdgeInsets.only(
                                  bottom: 5, left: 10, right: 10),
                              color: Clr().background,
                              child: Text(
                                'Profit Limit',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Dim().d32),
                Row(
                  children: [
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        addFundlayout();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dim().d8),
                            color: Color(0xffF7F7F7),
                            border: Border.all(color: Color(0xffC2C2C2))),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(Dim().d12),
                            child: Text('Add Funds', style: Sty().mediumText),
                          ),
                        ),
                      ),
                    )),
                    SizedBox(width: Dim().d16),
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        STM().redirect2page(
                            ctx, SellPageFinal(details: widget.details));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dim().d8),
                          color: Color(0xffFF4124),
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(Dim().d12),
                            child: Text('Sell / Cancel',
                                style: Sty()
                                    .mediumText
                                    .copyWith(color: Clr().white)),
                          ),
                        ),
                      ),
                    )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// api type
  apitype() async {
    FormData body = FormData.fromMap({'stock_id': widget.details['stock_id']});
    var result =
        await STM().postListWithoutDialog(ctx, 'stock_details', Token, body);
    if (result['success'] == true) {
      setState(() {
        data = result['data'];
      });
    } else {
      STM().errorDialog(ctx, result['message']);
    }
  }

  /// add preamount

  addPreAmount() async {
    FormData body = FormData.fromMap(
        {'stock_trade_id': widget.details['id'], 'amount': valueCtrl.text});
    var result = await STM()
        .postListWithoutDialog(ctx, 'additional_prepayment', Token, body);
    if (result['success'] == true) {
      try {
        setState(() {
          prepayment = int.parse(widget.details['pre_payment'].toString()) +
              int.parse(valueCtrl.text.toString());
        });
      } catch (_) {
        setState(() {
          prepayment = double.parse(widget.details['pre_payment'].toString()) +
              double.parse(valueCtrl.text.toString());
        });
      }
      STM().back2Previous(ctx);
      STM().displayToast(result['message'], ToastGravity.BOTTOM);
      valueCtrl.clear();
    } else {
      STM().errorDialog(ctx, result['message']);
    }
  }

  /// awesome dialog for adding fund
  addFundlayout({value}) {
    var select;
    final _formKey = GlobalKey<FormState>();
    AwesomeDialog(
        width: double.infinity,
        isDense: true,
        context: ctx,
        dialogType: DialogType.NO_HEADER,
        animType: AnimType.BOTTOMSLIDE,
        body: Form(
            key: _formKey,
            child: StatefulBuilder(builder: (context, setState) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: Dim().d16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add more prepayment amount to this  order',
                      style: Sty().smallText.copyWith(color: Clr().grey),
                    ),
                    SizedBox(
                      height: Dim().d12,
                    ),
                    TextFormField(
                      controller: valueCtrl,
                      cursorColor: Clr().primaryColor,
                      style: Sty().mediumText,
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      decoration: Sty().textFieldOutlineStyle.copyWith(
                            hintStyle: Sty().smallText.copyWith(
                                  color: Clr().grey,
                                ),
                            filled: true,
                            fillColor: Clr().white,
                            prefixText: '₹ ',
                            prefixStyle: TextStyle(color: Clr().textcolor),
                            hintText: "Enter Amount",
                            counterText: "",
                            // prefixIcon: Icon(
                            //   Icons.call,
                            //   color: Clr().lightGrey,
                            // ),
                          ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return Str().invalidEmpty;
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(
                      height: Dim().d20,
                    ),
                    SizedBox(
                      height: 40,
                      width: MediaQuery.of(ctx).size.height,
                      child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              addPreAmount();
                              // STM().redirect2page(ctx, paymentPage(price: valueCtrl.text,));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              shadowColor: Colors.transparent,
                              backgroundColor: Clr().accentColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          child: Text(
                            'Proceed',
                            style: Sty().mediumText.copyWith(
                                  fontSize: 16,
                                  color: Clr().white,
                                  fontWeight: FontWeight.w500,
                                ),
                          )),
                    ),
                    SizedBox(
                      height: Dim().d20,
                    ),
                  ],
                ),
              );
            }))).show();
  }
}
