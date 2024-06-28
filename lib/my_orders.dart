import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storak/home.dart';
import 'package:storak/portfoilio.dart';
import 'package:storak/values/colors.dart';
import 'package:storak/watchlist.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'manage/static_method.dart';
import 'values/dimens.dart';
import 'values/styles.dart';

class MyOrders extends StatefulWidget {
  final type;

  const MyOrders({super.key, required this.type});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  late BuildContext ctx;
  String? Token;
  bool? loading;
  List<dynamic> ordersList = [];

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      Token = sp.getString('token');
    });
    STM().checkInternet(context, widget).then(
      (value) {
        if (value) {
          apitype(apiname: 'my_orders', type: 'get');
          setState(() {
            loading = true;
          });
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
    return WillPopScope(
      onWillPop: () async {
        widget.type == 0
            ? STM().finishAffinity(ctx, Home())
            : widget.type == 1
                ? STM().replacePage(ctx, Portfolio())
                : STM().replacePage(ctx, WatchList(type: 1));
        return false;
      },
      child: Scaffold(
        backgroundColor: Clr().black,
        bottomNavigationBar: bottomBarLayout(ctx, 3, ''),
        appBar: AppBar(
          elevation: 1,
          shadowColor: Clr().lightShadow,
          backgroundColor: Clr().black,
          leadingWidth: 40,
          leading: InkWell(
            onTap: () {
              widget.type == 0
                  ? STM().finishAffinity(ctx, Home())
                  : widget.type == 1
                      ? STM().replacePage(ctx, Portfolio())
                      : STM().replacePage(ctx, WatchList(type: 1));
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
            'My Orders',
            style: Sty()
                .mediumText
                .copyWith(color: Clr().textcolor, fontWeight: FontWeight.w600),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            Future.delayed(const Duration(seconds: 2), () {
              apitype(apiname: 'my_orders', type: 'get');
            });
          },
          child: Padding(
            padding: EdgeInsets.all(Dim().d16),
            child: ordersList.isEmpty
                ? check
                    ? SizedBox(
                        height: MediaQuery.of(ctx).size.height / 1.5,
                        child: Center(
                          child: Text("You haven't placed any orders yet",
                              style: Sty()
                                  .mediumBoldText
                                  .copyWith(color: Clr().white)),
                        ),
                      )
                    : Container()
                : ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: ordersList.length,
                    itemBuilder: (ctx, index) {
                      return cardLayout(ctx, ordersList[index]);
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: Dim().d12,
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }

  Widget cardLayout(ctx, v) {
    bool click = true;
    return StatefulBuilder(builder: (context, setState) {
      return Card(
        color: Clr().grey.withOpacity(0.1),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          // side: BorderSide(color: Clr().borderColor),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ID: ${v['order_id']}',
                    style: Sty().microText.copyWith(color: Clr().grey),
                  ),
                  Text(
                    '${v['created_at']}',
                    style: Sty().microText.copyWith(color: Clr().grey),
                  ),
                ],
              ),
              SizedBox(
                height: Dim().d4,
              ),
              Divider(
                color: Clr().grey,
              ),
              SizedBox(
                height: Dim().d12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${v['stock']['symbol']}',
                    style: Sty().smallText.copyWith(
                        color: Clr().textcolor, fontWeight: FontWeight.w600),
                  ),
                  RichText(
                      text: TextSpan(
                          text: '${v['type_string']} ',
                          style: Sty().mediumText.copyWith(
                              color: v['type_string'] == 'Buy'
                                  ? Clr().green
                                  : Clr().red),
                          children: [
                        TextSpan(
                          text: '- ${v['status'].toString()}',
                          style: Sty().mediumText.copyWith(
                              color: v['status'].toString() == 'pending'
                                  ? Color(0xffFCD12A)
                                  : v['status'].toString() == 'completed'
                                      ? Color(0xff33B864)
                                      : Color(0xffED2939)),
                        ),
                      ]))
                ],
              ),
              SizedBox(
                height: Dim().d12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (v['status'].toString() == 'pending')
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Clr().errorRed),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Cancel Order',
                                      style: Sty().mediumBoldText),
                                  content: Text(
                                      'Are you sure want to cancel order?',
                                      style: Sty().mediumText),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          apitype(
                                              type: 'post',
                                              apiname: 'cancel_order',
                                              value: [
                                                v['stock_trade_id'],
                                                v['id'],
                                                v['type_string']
                                              ]);
                                        },
                                        child: Text('Yes',
                                            style: Sty().smallText.copyWith(
                                                fontWeight: FontWeight.w600))),
                                    TextButton(
                                        onPressed: () {
                                          STM().back2Previous(ctx);
                                        },
                                        child: Text('No',
                                            style: Sty().smallText.copyWith(
                                                fontWeight: FontWeight.w600))),
                                  ],
                                );
                              });
                        },
                        child: Text(
                          'Cancel',
                          style: Sty().mediumText.copyWith(color: Clr().white),
                        )),
                  if (v['stock_trade'] != null &&
                      v['type_string'] == 'Sell' &&
                      v['status'].toString() == 'completed')
                    RichText(
                      text: TextSpan(
                          text: 'Net P/L: ',
                          style: Sty().smallText.copyWith(color: Clr().grey),
                          children: [
                            TextSpan(
                                text: '${v['stock_trade']['net_floating_p_l']}',
                                style: Sty().smallText.copyWith(
                                    color: v['stock_trade']['net_floating_p_l']
                                            .toString()
                                            .contains('-')
                                        ? Clr().red
                                        : Clr().grey))
                          ]),
                    ),
                  Text(
                    'Qty: ${v['quantity']}',
                    style: Sty().smallText.copyWith(
                        color: Clr().grey, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Price :  ${v['price']}',
                    style: Sty().smallText.copyWith(
                        color: Clr().grey, fontWeight: FontWeight.w300),
                  ),
                ],
              ),
              if (v['stock_trade'] != null &&
                  v['type_string'] == 'Sell' &&
                  v['status'].toString() == 'completed')
                SizedBox(height: Dim().d12),
              if (v['stock_trade'] != null &&
                  v['type_string'] == 'Sell' &&
                  v['status'].toString() == 'completed')
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (v['stock_trade']['deffered_fee'] != null)
                      RichText(
                        text: TextSpan(
                            text: 'Deffered Fee: ',
                            style: Sty().smallText.copyWith(color: Clr().grey),
                            children: [
                              TextSpan(
                                  text: '${v['stock_trade']['deffered_fee']}',
                                  style: Sty()
                                      .smallText
                                      .copyWith(color: Clr().white))
                            ]),
                      ),
                    SizedBox(
                      width: Dim().d12,
                    ),
                    if (v['stock_trade']['leverage'] != null)
                      RichText(
                        text: TextSpan(
                            text: 'Leverage: ',
                            style: Sty().smallText.copyWith(color: Clr().grey),
                            children: [
                              TextSpan(
                                  text: '${v['stock_trade']['leverage']}x',
                                  style: Sty()
                                      .smallText
                                      .copyWith(color: Clr().white))
                            ]),
                      ),
                  ],
                ),
              if (v['stock_trade'] != null &&
                  v['type_string'] == 'Sell' &&
                  v['status'].toString() == 'completed')
                click
                    ? Container()
                    : Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (v['stock_trade']['leverage_amount'] != null)
                                Padding(
                                  padding: EdgeInsets.only(top: Dim().d12),
                                  child: RichText(
                                    text: TextSpan(
                                        text: 'Leverage Amt: ',
                                        style: Sty()
                                            .smallText
                                            .copyWith(color: Clr().grey),
                                        children: [
                                          TextSpan(
                                              text:
                                                  '${v['stock_trade']['leverage_amount']}',
                                              style: Sty()
                                                  .smallText
                                                  .copyWith(color: Clr().white))
                                        ]),
                                  ),
                                ),
                              // RichText(
                              //   text: TextSpan(.............
                              //       text: 'Quantity:- ',
                              //       style: Sty().smallText.copyWith(color: Clr().grey),
                              //       children: [
                              //         TextSpan(
                              //             text: '${v['stock_trade']['quantity']}',
                              //             style: Sty().smallText.copyWith(color: Clr().grey))
                              //       ]),
                              // ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (v['stock_trade']['transaction_fee'] != null)
                                Padding(
                                  padding: EdgeInsets.only(top: Dim().d12),
                                  child: RichText(
                                    text: TextSpan(
                                        text: 'Transaction Fee: ',
                                        style: Sty()
                                            .smallText
                                            .copyWith(color: Clr().grey),
                                        children: [
                                          TextSpan(
                                              text:
                                                  '0', //'${v['stock_trade']['transaction_fee']}',
                                              style: Sty()
                                                  .smallText
                                                  .copyWith(color: Clr().white))
                                        ]),
                                  ),
                                ),
                              // RichText(
                              //   text: TextSpan(
                              //       text: 'Additional Prepayment:- ',
                              //       style: Sty().smallText.copyWith(color: Clr().grey),
                              //       children: [
                              //         TextSpan(
                              //             text: '${v['stock_trade']['additional_prepayment']}',
                              //             style: Sty().smallText.copyWith(color: Clr().grey))
                              //       ]),
                              // ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (v['stock_trade']['in_hand_amount'] != null)
                                Padding(
                                  padding: EdgeInsets.only(top: Dim().d12),
                                  child: RichText(
                                    text: TextSpan(
                                        text: 'In Hand Amount: ',
                                        style: Sty()
                                            .smallText
                                            .copyWith(color: Clr().grey),
                                        children: [
                                          TextSpan(
                                              text:
                                                  '${v['stock_trade']['in_hand_amount']}',
                                              style: Sty()
                                                  .smallText
                                                  .copyWith(color: Clr().white))
                                        ]),
                                  ),
                                ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (v['stock_trade']['additional_prepayment'] !=
                                  null)
                                Padding(
                                  padding: EdgeInsets.only(top: Dim().d12),
                                  child: RichText(
                                    text: TextSpan(
                                        text: 'Additional PreAmount: ',
                                        style: Sty()
                                            .smallText
                                            .copyWith(color: Clr().grey),
                                        children: [
                                          TextSpan(
                                              text:
                                                  '${v['stock_trade']['additional_prepayment']}',
                                              style: Sty()
                                                  .smallText
                                                  .copyWith(color: Clr().white))
                                        ]),
                                  ),
                                ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (v['stock_trade']['wallet_amount'] != null)
                                Padding(
                                  padding: EdgeInsets.only(top: Dim().d12),
                                  child: RichText(
                                    text: TextSpan(
                                        text: 'PreAmount: ',
                                        style: Sty()
                                            .smallText
                                            .copyWith(color: Clr().grey),
                                        children: [
                                          TextSpan(
                                              text:
                                                  '${v['stock_trade']['wallet_amount']}',
                                              style: Sty()
                                                  .smallText
                                                  .copyWith(color: Clr().white))
                                        ]),
                                  ),
                                ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (v['stock_trade']['floating_p_l'] != null)
                                Padding(
                                  padding: EdgeInsets.only(top: Dim().d12),
                                  child: RichText(
                                    text: TextSpan(
                                        text: 'Floating P/L: ',
                                        style: Sty()
                                            .smallText
                                            .copyWith(color: Clr().grey),
                                        children: [
                                          TextSpan(
                                              text:
                                                  '${v['stock_trade']['floating_p_l']}',
                                              style: Sty().smallText.copyWith(
                                                  color: v['stock_trade']
                                                              ['floating_p_l']
                                                          .toString()
                                                          .contains('-')
                                                      ? Clr().red
                                                      : Clr().white))
                                        ]),
                                  ),
                                ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (v['stock_trade']
                                      ['stop_loss_limit_percentage'] !=
                                  null)
                                Padding(
                                  padding: EdgeInsets.only(top: Dim().d12),
                                  child: RichText(
                                    text: TextSpan(
                                        text: 'Stop Loss Limit : ',
                                        style: Sty()
                                            .smallText
                                            .copyWith(color: Clr().grey),
                                        children: [
                                          TextSpan(
                                              text:
                                                  '${v['stock_trade']['stop_loss_limit_percentage']}%',
                                              style: Sty().smallText.copyWith(
                                                  color: v['stock_trade'][
                                                              'stop_loss_limit_percentage']
                                                          .toString()
                                                          .contains('-')
                                                      ? Clr().red
                                                      : Clr().white))
                                        ]),
                                  ),
                                ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (v['stock_trade']['stop_loss_limit'] != null)
                                Padding(
                                  padding: EdgeInsets.only(top: Dim().d12),
                                  child: RichText(
                                    text: TextSpan(
                                        text: 'Stop Loss Limit: ',
                                        style: Sty()
                                            .smallText
                                            .copyWith(color: Clr().grey),
                                        children: [
                                          TextSpan(
                                              text:
                                                  '${v['stock_trade']['stop_loss_limit']}',
                                              style: Sty().smallText.copyWith(
                                                  color: v['stock_trade'][
                                                              'stop_loss_limit']
                                                          .toString()
                                                          .contains('-')
                                                      ? Clr().red
                                                      : Clr().white))
                                        ]),
                                  ),
                                ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (v['stock_trade']['profit_limit_percentage'] !=
                                  null)
                                Padding(
                                  padding: EdgeInsets.only(top: Dim().d12),
                                  child: RichText(
                                    text: TextSpan(
                                        text: 'Profit Limit : ',
                                        style: Sty()
                                            .smallText
                                            .copyWith(color: Clr().grey),
                                        children: [
                                          TextSpan(
                                              text:
                                                  '${v['stock_trade']['profit_limit_percentage']}%',
                                              style: Sty().smallText.copyWith(
                                                  color: v['stock_trade'][
                                                              'profit_limit_percentage']
                                                          .toString()
                                                          .contains('-')
                                                      ? Clr().red
                                                      : Clr().white))
                                        ]),
                                  ),
                                ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (v['stock_trade']['profit_limit'] != null)
                                Padding(
                                  padding: EdgeInsets.only(top: Dim().d12),
                                  child: RichText(
                                    text: TextSpan(
                                        text: 'Profit Limit: ',
                                        style: Sty()
                                            .smallText
                                            .copyWith(color: Clr().grey),
                                        children: [
                                          TextSpan(
                                              text:
                                                  '${v['stock_trade']['profit_limit']}',
                                              style: Sty().smallText.copyWith(
                                                  color: v['stock_trade']
                                                              ['profit_limit']
                                                          .toString()
                                                          .contains('-')
                                                      ? Clr().red
                                                      : Clr().white))
                                        ]),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
              if (v['stock_trade'] != null &&
                  v['type_string'] == 'Sell' &&
                  v['status'].toString() == 'completed')
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: Dim().d12),
                      child: InkWell(
                          onTap: () {
                            if (click == true) {
                              setState(() {
                                click = false;
                              });
                            } else {
                              setState(() {
                                click = true;
                              });
                            }
                          },
                          child: Text(
                              click == true ? 'More Details >>' : '<< Less',
                              style: Sty().microText.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600))),
                    )
                  ],
                ),
            ],
          ),
        ),
      );
    });
  }

  /// api type
  apitype({apiname, type, value}) async {
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
        });
        break;
      case 'cancel_order':
        data = FormData.fromMap({
          'stock_trade_id': value[0],
          'order_id': value[1],
          'type': value[2]
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
      case 'my_orders':
        if (result['success']) {
          setState(() {
            loading = false;
            check = true;
            ordersList = result['data'];
          });
        } else {
          STM().errorDialog(ctx, result['message']);
        }
        break;
      case "sell_stock":
        if (success) {
          STM().displayToast(message, ToastGravity.CENTER);
        } else {
          STM().errorDialog(ctx, message);
        }
        break;
      case "cancel_order":
        if (success) {
          apitype(apiname: 'my_orders', type: 'get');
          STM().successDialog(ctx, message, widget);
        } else {
          STM().errorDialog(ctx, message);
        }
        break;
    }
  }
}
