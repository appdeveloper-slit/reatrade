// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storak/localstore.dart';
import 'package:storak/manage/static_method.dart';
import 'package:storak/search_stocks.dart';
import 'package:storak/values/colors.dart';
import 'package:storak/values/dimens.dart';
import 'package:storak/values/styles.dart';
import 'package:upgrader/upgrader.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'notification.dart';
import 'stock_chart.dart';

bool? done;

class Home extends StatefulWidget {
  final b;

  const Home({super.key, this.b});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late BuildContext ctx;
  String? Token;
  bool? profileLoading;
  dynamic profileList;
  bool? loading, ok;
  List isLike = [];
  List isdislike = [];
  List stockList = [];
  List topCompList = [];
  List indesList = [];
  bool ignore = false;
  bool later = false;
  var result;
  List<dynamic> loaclStockList = [];
  var niftyFifty, senSexValue;

  Future<void> _addItem(stockID, symbol, companyname) async {
    await Store.createItem(stockID, symbol, companyname);
  }

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      Token = sp.getString('token');
    });
    STM().checkInternet(context, widget).then(
      (value) {
        if (value) {
          setState(() {
            done = true;
          });
          apiType(apiname: 'get_profile', type: 'get');
          apiType(apiname: 'stock_list', type: 'post');
          // allStocks();
        }
      },
    );
    print(Token);
  }

  Future<void> pullDownRefresh() async {
    print("Refresh Started!");
    await Timer(const Duration(milliseconds: 100), () {
      setState(() {
        apiType(apiname: 'get_profile', type: 'get');
        apiType(apiname: 'stock_list', type: 'post');
      });
      print("Working refresh...");
    });
    print("Refresh Ended!");
  }

  Map updateType = {};
  late Stream stream = Stream.periodic(Duration(seconds: 5)).asyncMap(
      (event) async => await apiType(apiname: 'stock_list', type: 'post'));
  Upgrader _upgrader = Upgrader();
  // var channel = WebSocketChannel.connect(Uri.parse('https://storak.in/api/stock_list'));
  // streamStockListner() async {
  //   channel.stream.listen((event) {
  //     Map data = jsonDecode(event);
  //     print(data);
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    getSession();
    // streamStockListner();
    _upgrader.initialize();
    super.initState();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   timer?.cancel();
  // }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return DoubleBack(
      message: 'Please press back once again!!',
      child: Scaffold(
        bottomNavigationBar: bottomBarLayout(ctx, 0, stream),
        backgroundColor: Clr().black,
        appBar: AppBar(
          elevation: 1,
          shadowColor: Clr().lightShadow,
          backgroundColor: Clr().black,
          leadingWidth: 300,
          leading: Padding(
            padding: EdgeInsets.all(Dim().d16),
            child: Text('Hi, ${profileList == null ? '' : profileList['name']}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Sty().mediumText.copyWith(
                    color: Clr().accentColor, fontWeight: FontWeight.w600)),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.all(Dim().d16),
              child: Row(
                children: [
                  InkWell(
                      onTap: () {
                        STM().replacePage(ctx, SearchStocks(type: 'home'));
                      },
                      child: SvgPicture.asset(
                        'assets/search.svg',
                        color: Clr().white,
                      )),
                  SizedBox(
                    width: Dim().d12,
                  ),
                  // InkWell(
                  //     onTap: () {
                  //       STM().redirect2page(ctx, Notifications());
                  //     },
                  //     child: SvgPicture.asset('assets/bell.svg')),
                ],
              ),
            )
          ],
        ),
        body: updateType.isEmpty
            ? Container()
            : UpgradeAlert(
                upgrader: Upgrader(
                  canDismissDialog: false,
                  dialogStyle: UpgradeDialogStyle.material,
                  durationUntilAlertAgain: Duration(seconds: 2),
                  showReleaseNotes: true,
                  onUpdate: () {
                    updateType['update_type'] == false
                        ? Future.delayed(Duration(seconds: 1), () {
                            SystemNavigator.pop();
                          })
                        : null;
                    return true;
                  },
                  showIgnore: false,
                  // updateType == null ? false : updateType['update_type'],
                  showLater: false,
                  // updateType == null ? false : updateType['update_type'],
                ),
                child: homeLayout()),
      ),
    );
  }

  Widget homeLayout() {
    return RefreshIndicator(
      onRefresh: () {
        return Future.delayed(Duration(seconds: 6), () {
          setState(() {
            apiType(apiname: 'get_profile', type: 'get');
            apiType(apiname: 'stock_list', type: 'post');
          });
        });
      },
      color: Clr().primaryColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(Dim().d16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Clr().grey.withOpacity(0.1),
              ),
              child: Card(
                color: Clr().grey.withOpacity(0.1),
                margin: EdgeInsets.zero,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  // side: BorderSide(color: Clr().borderColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: Dim().d16,
                  ),
                  child: Row(
                    children: [
                      indesList.isEmpty
                          ? Container()
                          : Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '${indesList[0]['symbol']}',
                                    style: Sty()
                                        .smallText
                                        .copyWith(color: Clr().white),
                                  ),
                                  SizedBox(
                                    height: Dim().d12,
                                  ),
                                  Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      indesList[0]['net_change']
                                              .toString()
                                              .contains('-')
                                          ? Icon(Icons.arrow_downward_outlined,
                                              color: Clr().red, size: Dim().d16)
                                          : Icon(Icons.arrow_upward_outlined,
                                              color: Clr().green,
                                              size: Dim().d16),
                                      SizedBox(
                                        width: Dim().d8,
                                      ),
                                      // LiveDataBuilder(
                                      //     builder: (BuildContext context, value) {
                                      //       return Text(
                                      //         '${v['last_price']}',
                                      //         style: Sty().smallText.copyWith(
                                      //             fontSize: Dim().d16,
                                      //             fontWeight: FontWeight.w500,
                                      //             color:
                                      //                 v['net_change'].toString().contains('-')
                                      //                     ? Clr().red
                                      //                     : Clr().green),
                                      //       );
                                      //     },
                                      //     data: ),
                                      // xData(v['last_price']),
                                      Text(
                                        '${indesList[0]['last_price']}',
                                        style: Sty().smallText.copyWith(
                                            fontSize: Dim().d16,
                                            fontWeight: FontWeight.w500,
                                            color: indesList[0]['net_change']
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
                                    '${indesList[0]['net_change']} (${indesList[0]['net_change_ercentage']})',
                                    style: Sty().microText.copyWith(
                                        color: Clr().grey, fontSize: Dim().d14),
                                  ),
                                ],
                              ),
                            ),
                      Container(
                        height: 60,
                        width: 1,
                        color: Clr().grey,
                      ),
                      indesList.isEmpty
                          ? Container()
                          : Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '${indesList[1]['symbol']}',
                                    style: Sty()
                                        .smallText
                                        .copyWith(color: Clr().white),
                                  ),
                                  SizedBox(
                                    height: Dim().d12,
                                  ),
                                  Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      indesList[1]['net_change']
                                              .toString()
                                              .contains('-')
                                          ? Icon(Icons.arrow_downward_outlined,
                                              color: Clr().red, size: Dim().d16)
                                          : Icon(Icons.arrow_upward_outlined,
                                              color: Clr().green,
                                              size: Dim().d16),
                                      SizedBox(
                                        width: Dim().d8,
                                      ),
                                      // LiveDataBuilder(
                                      //     builder: (BuildContext context, value) {
                                      //       return Text(
                                      //         '${v['last_price']}',
                                      //         style: Sty().smallText.copyWith(
                                      //             fontSize: Dim().d16,
                                      //             fontWeight: FontWeight.w500,
                                      //             color:
                                      //                 v['net_change'].toString().contains('-')
                                      //                     ? Clr().red
                                      //                     : Clr().green),
                                      //       );
                                      //     },
                                      //     data: ),
                                      // xData(v['last_price']),
                                      Text(
                                        '${indesList[1]['last_price']}',
                                        style: Sty().smallText.copyWith(
                                            fontSize: Dim().d16,
                                            fontWeight: FontWeight.w500,
                                            color: indesList[1]['net_change']
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
                                    '${indesList[1]['net_change']} (${indesList[1]['net_change_ercentage']})',
                                    style: Sty().microText.copyWith(
                                        color: Clr().grey, fontSize: Dim().d14),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: Dim().d28,
            ),
            Text(
              'Market Today',
              style: Sty().largeText.copyWith(
                  color: Clr().primaryColor, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: Dim().d4,
            ),
            Divider(
              color: Clr().textcolor,
              thickness: 1,
              height: 10,
            ),
            SizedBox(
              height: Dim().d8,
            ),
            stockList.isEmpty
                ? Container()
                : StreamBuilder(
                    stream: stream,
                    builder: (context, AsyncSnapshot snapshot) {
                      return ListView.separated(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: stockList.length,
                        itemBuilder: (ctx, index) {
                          return marketLayout(ctx, index, stockList[index]);
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: Dim().d8,
                          );
                        },
                      );
                    }),
            SizedBox(
              height: Dim().d28,
            ),
            Text(
              'Top Companies',
              style: Sty().largeText.copyWith(
                  color: Clr().primaryColor, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: Dim().d4,
            ),
            Divider(
              color: Clr().textcolor,
            ),
            SizedBox(
              height: Dim().d12,
            ),
            ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: topCompList.length,
              itemBuilder: (ctx, index) {
                return marketLayout(ctx, index, topCompList[index]);
              },
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: Dim().d8,
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget marketLayout(ctx, index, v) {
    return InkWell(
      onTap: () {
        STM().finishAffinity(
            ctx,
            StockChart(
              details: v,
              type: 'home',
            ));
      },
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${v['symbol']}',
                      style: Sty().smallText.copyWith(color: Clr().textcolor),
                    ),
                    SizedBox(
                      height: Dim().d8,
                    ),
                    Text(
                      '${v['company_name']}',
                      style: Sty().microText.copyWith(color: Clr().grey),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        v['net_change'].toString().contains('-')
                            ? Icon(Icons.arrow_downward_outlined,
                                color: Clr().red, size: Dim().d16)
                            : Icon(Icons.arrow_upward_outlined,
                                color: Clr().green, size: Dim().d16),
                        SizedBox(
                          width: Dim().d8,
                        ),
                        // LiveDataBuilder(
                        //     builder: (BuildContext context, value) {
                        //       return Text(
                        //         '${v['last_price']}',
                        //         style: Sty().smallText.copyWith(
                        //             fontSize: Dim().d16,
                        //             fontWeight: FontWeight.w500,
                        //             color:
                        //                 v['net_change'].toString().contains('-')
                        //                     ? Clr().red
                        //                     : Clr().green),
                        //       );
                        //     },
                        //     data: ),
                        // xData(v['last_price']),
                        Text(
                          '${v['last_price']}',
                          style: Sty().smallText.copyWith(
                              fontSize: Dim().d16,
                              fontWeight: FontWeight.w500,
                              color: v['net_change'].toString().contains('-')
                                  ? Clr().red
                                  : Clr().green),
                        )
                      ],
                    ),
                    SizedBox(
                      height: Dim().d8,
                    ),
                    Text(
                      '${v['net_change']} (${v['net_change_ercentage']})',
                      style: Sty()
                          .microText
                          .copyWith(color: Clr().grey, fontSize: Dim().d14),
                    ),
                  ],
                ),
              ),
              SizedBox(width: Dim().d16),
              isLike.map((e) => e.toString()).contains(v['id'].toString())
                  ? InkWell(
                      onTap: () {
                        apiType(
                            apiname: 'remove_favourite',
                            type: 'post',
                            value: v['id']);
                        if (isdislike.contains(v['id'])) {
                          setState(() {
                            isdislike.remove(v['id']);
                          });
                        } else {
                          setState(() {
                            isLike.remove(v['id']);
                            isdislike.add(v['id']);
                          });
                        }
                      },
                      child: SvgPicture.asset('assets/star.svg'))
                  : InkWell(
                      onTap: () {
                        apiType(
                            apiname: 'add_favourite',
                            type: 'post',
                            value: v['id']);
                        if (isLike.contains(v['id'])) {
                          setState(() {
                            isLike.remove(v['id']);
                          });
                        } else {
                          setState(() {
                            isdislike.remove(v['id']);
                            isLike.add(v['id']);
                          });
                        }
                      },
                      child: SvgPicture.asset('assets/watchlisticon.svg')),
            ],
          ),
          SizedBox(
            height: Dim().d8,
          ),
          Divider(
            color: Clr().grey.withOpacity(0.2),
            thickness: 1,
            height: 15,
          )
        ],
      ),
    );
  }

  ///getprofile
  apiType({apiname, type, value}) async {
    var data = FormData.fromMap({});
    switch (apiname) {
      case 'stock_list':
        setState(() {
          loading = true;
        });
        data = FormData.fromMap({});
        break;
      case 'add_favourite':
        data = FormData.fromMap({
          'stock_id': value,
        });
        break;
      case 'remove_favourite':
        data = FormData.fromMap({
          'stock_id': value,
        });
        break;
    }
    FormData body = data;
    var result = type == 'post'
        ? await STM().postListWithoutDialog(ctx, apiname, Token, body)
        : await STM().getWithoutDialog(ctx, apiname, Token);
    switch (apiname) {
      case 'get_profile':
        if (result['success']) {
          setState(() {
            profileList = result['data'];
          });
        } else {
          STM().errorDialog(ctx, result['message']);
        }
        break;
      case 'stock_list':
        if (result['success']) {
          setState(() {
            updateType = result['data'];
            stockList = result['data']['stock_list'];
            topCompList = result['data']['top_companies'];
            indesList = result['data']['index'];
            // ignore = result['data']['update_type'];
            // later = result['data']['update_type'];
            for (int a = 0; a < stockList.length; a++) {
              if (stockList[a]['is_like'] == true) {
                setState(() {
                  isLike.add(stockList[a]['id']);
                });
              } else {
                setState(() {
                  isdislike.add(stockList[a]['id']);
                });
              }
            }
            for (int a = 0; a < topCompList.length; a++) {
              if (topCompList[a]['is_like'] == true) {
                setState(() {
                  isLike.add(topCompList[a]['id']);
                });
              } else {
                setState(() {
                  isdislike.add(topCompList[a]['id']);
                });
              }
            }
            loading = false;
          });
        } else {
          STM().errorDialog(ctx, result['message']);
          setState(() {
            loading = false;
          });
        }
        break;
      case 'add_favourite':
        if (result['success']) {
        } else {
          setState(() {
            STM().errorDialog(ctx, result['message']);
          });
        }
        break;
      case 'remove_favourite':
        if (result['success']) {
        } else {
          setState(() {
            STM().errorDialog(ctx, result['message']);
          });
        }
        break;
    }
  }

  _updater() {
    return Upgrader(
      showLater: true,
      showIgnore: false,
      showReleaseNotes: false,
    );
  }

// allStocks() async {
//   if (widget.b == true) {
//     var result = await STM().getWithoutDialog(ctx, 'all_stocks', Token);
//     setState(() {
//       loaclStockList = result['data'];
//     });
//     loaclStockList.map((e) {
//       Store.createItem(e['id'], e['symbol'], e['company_name']);
//     }).toList();
//     print(loaclStockList.length);
//   }
// }
}
