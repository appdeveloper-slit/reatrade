import 'dart:async';
import 'package:candlesticks/candlesticks.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:interactive_chart/interactive_chart.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storak/home.dart';
import 'package:storak/manage/static_method.dart';
import 'package:storak/mock_data.dart';
import 'package:storak/portfoilio.dart';
import 'package:storak/search_stocks.dart';
import 'package:storak/values/colors.dart';
import 'package:storak/values/dimens.dart';
import 'package:storak/values/styles.dart';
import 'package:storak/watchlist.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'buy_stock.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'my_orders.dart';
import 'sell_stock.dart';

class StockChart extends StatefulWidget {
  final details, type;

  const StockChart({super.key, required this.details, required this.type});

  @override
  State<StockChart> createState() => _StockChartState();
}

class _StockChartState extends State<StockChart> {
  late BuildContext ctx;
  List isLike = [];
  List isdislike = [];
  int isSelected = 0;
  var message;
  List<CandleData> _data = [];
  dynamic data;
  List<dynamic> resultList = [
    {'name': '1 minute'},
    // {'name': '30 minute'},
    {'name': 'Day'},
    {'name': 'Week'},
    {'name': 'Month'},
  ];

  var check;

  String? Token;
  bool? loading, checkmarket;
  bool _showAverage = false;
  var instrumenttoken = null;
  bool? streamBool;

  Stream? ominuteStream;
  StreamSubscription? _subone;

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      Token = sp.getString('token');
      streamBool = true;
    });
    STM().checkInternet(context, widget).then(
      (value) {
        if (value) {
          api1type();
          print(instrumenttoken);
          // stockUpdate('https://api-v2.upstox.com/historical-candle/NSE_EQ%7CINE848E01016/1minute/${DateFormat('yyyy-MM-dd').format(fromdate)}/${DateFormat('yyyy-MM-dd').format(oneminutedate)}');
          // stockfunt(apiname: 'favourite_stock_list', type: 'get');
          // ominuteStream = Stream.periodic(Duration(seconds: 5)).asyncMap(
          //     (event) async => await stockUpdate(checkmarket == false
          //         ? 'https://api-v2.upstox.com/historical-candle/${data['instrument_token']}/1minute/${DateFormat('yyyy-MM-dd').format(fromdate)}/${DateFormat('yyyy-MM-dd').format(oneminutedate)}'
          //         : 'https://api-v2.upstox.com/historical-candle/intraday/${instrumenttoken}/1minute'));
        }
      },
    );
    print(Token);
  }

  cancelStream() {
    final subscription = stream.listen(null);
    subscription.onData((event) {
      // Update onData after listening.
      subscription.cancel();
      stream.timeout(Duration(seconds: 1));
    });
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
    return WillPopScope(
      onWillPop: () async {
        widget.type == 'home'
            ? STM().finishAffinity(ctx, Home())
            : widget.type == 'watch'
                ? STM().finishAffinity(ctx, WatchList(type: 'home'))
                : widget.type == 'port'
                    ? STM().finishAffinity(ctx, Portfolio())
                    : widget.type == 'search'
                        ? STM().replacePage(
                            ctx,
                            SearchStocks(
                              type: 'home',
                            ))
                        : STM().back2Previous(ctx);
        return false;
      },
      child: Scaffold(
        bottomNavigationBar: bottomBarLayout(ctx, 0, stream, b: true),
        backgroundColor: Clr().black,
        appBar: AppBar(
          elevation: 1,
          shadowColor: Clr().lightShadow,
          backgroundColor: Clr().black,
          leadingWidth: 40,
          leading: InkWell(
            onTap: () {
              widget.type == 'home'
                  ? STM().finishAffinity(ctx, Home())
                  : widget.type == 'watch'
                      ? STM().finishAffinity(ctx, WatchList(type: 'home'))
                      : widget.type == 'port'
                          ? STM().finishAffinity(ctx, Portfolio())
                          : widget.type == 'search'
                              ? STM().replacePage(
                                  ctx,
                                  SearchStocks(
                                    type: 'home',
                                  ))
                              : STM().back2Previous(ctx);
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
        body: data == null
            ? Center(
                child: CircularProgressIndicator(color: Clr().primaryColor))
            : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: Dim().d20),
                    _data.isNotEmpty
                        ? StreamBuilder(
                            stream: ominuteStream,
                            builder: (context, AsyncSnapshot snapshot) {
                              return Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: Dim().d20),
                                child: SizedBox(
                                    height: 400.0,
                                    width: 500,
                                    child:
                                        // Candlesticks(candles: _data)
                                        InteractiveChart(
                                      candles: _data,
                                      initialVisibleCandleCount: 50,
                                      onCandleResize: (value) => 50.0,
                                      style: ChartStyle(
                                          overlayBackgroundColor: Clr().grey),
                                    )),
                              );
                            })
                        : loading == true
                            ? Container(
                                height: 400.0,
                                child: Center(
                                  child: Text('${message}',
                                      style: Sty().mediumText),
                                ),
                              )
                            : CircularProgressIndicator(
                                color: Clr().primaryColor,
                                strokeWidth: 1.2,
                              ),
                    Column(
                      children: [
                        SizedBox(
                          height: Dim().d8,
                        ),
                        StreamBuilder(
                            stream: stream,
                            builder: (context, AsyncSnapshot snapshot) {
                              return SizedBox(
                                height: 50,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  itemCount: 1,
                                  itemBuilder: (ctx, index) {
                                    return resultLayout(ctx, index, resultList);
                                  },
                                  separatorBuilder: (context, index) {
                                    return SizedBox(
                                      width: Dim().d8,
                                    );
                                  },
                                ),
                              );
                            }),
                        SizedBox(
                          height: Dim().d32,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            elevation: 0.2,
                            color: Clr().grey.withOpacity(0.2),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        'Open',
                                        style: Sty().microText.copyWith(
                                            fontWeight: FontWeight.w300,
                                            color: Clr().white),
                                      ),
                                      SizedBox(
                                        height: Dim().d8,
                                      ),
                                      Text(
                                        '${data['open']}',
                                        style: Sty().microText.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: Clr().grey),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        'High',
                                        style: Sty().microText.copyWith(
                                            fontWeight: FontWeight.w300,
                                            color: Clr().white),
                                      ),
                                      SizedBox(
                                        height: Dim().d8,
                                      ),
                                      Text(
                                        '${data['high']}',
                                        style: Sty().microText.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: Clr().grey),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        'Low',
                                        style: Sty().microText.copyWith(
                                            fontWeight: FontWeight.w300,
                                            color: Clr().white),
                                      ),
                                      SizedBox(
                                        height: Dim().d8,
                                      ),
                                      Text(
                                        '${data['low']}',
                                        style: Sty().microText.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: Clr().grey),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        'Close',
                                        style: Sty().microText.copyWith(
                                            fontWeight: FontWeight.w300,
                                            color: Clr().white),
                                      ),
                                      SizedBox(
                                        height: Dim().d8,
                                      ),
                                      Text(
                                        '${data['close']}',
                                        style: Sty().microText.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: Clr().grey,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Dim().d20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              isLike.map((e) => e.toString()).contains(
                                      widget.type == 'watch'
                                          ? widget.details['stock_id']
                                              .toString()
                                          : widget.details['id'].toString())
                                  ? InkWell(
                                      onTap: () {
                                        apiType(
                                            apiname: 'remove_favourite',
                                            type: 'post',
                                            value: widget.type == 'watch'
                                                ? widget.details['stock_id']
                                                : widget.details['id']);
                                        if (isdislike.contains(
                                            widget.type == 'watch'
                                                ? widget.details['stock_id']
                                                : widget.details['id'])) {
                                          setState(() {
                                            isdislike.remove(
                                                widget.type == 'watch'
                                                    ? widget.details['stock_id']
                                                    : widget.details['id']);
                                          });
                                        } else {
                                          setState(() {
                                            isLike.remove(widget.type == 'watch'
                                                ? widget.details['stock_id']
                                                : widget.details['id']);
                                            isdislike.add(widget.type == 'watch'
                                                ? widget.details['stock_id']
                                                : widget.details['id']);
                                          });
                                        }
                                      },
                                      child: SvgPicture.asset(
                                          'assets/fillstar.svg'))
                                  : InkWell(
                                      onTap: () {
                                        apiType(
                                            apiname: 'add_favourite',
                                            type: 'post',
                                            value: widget.type == 'watch'
                                                ? widget.details['stock_id']
                                                : widget.details['id']);
                                        if (isLike.contains(
                                            widget.type == 'watch'
                                                ? widget.details['stock_id']
                                                : widget.details['id'])) {
                                          setState(() {
                                            isLike.remove(widget.type == 'watch'
                                                ? widget.details['stock_id']
                                                : widget.details['id']);
                                          });
                                        } else {
                                          setState(() {
                                            isdislike.remove(
                                                widget.type == 'watch'
                                                    ? widget.details['stock_id']
                                                    : widget.details['id']);
                                            isLike.add(widget.type == 'watch'
                                                ? widget.details['stock_id']
                                                : widget.details['id']);
                                          });
                                        }
                                      },
                                      child: SvgPicture.asset(
                                          'assets/unfillstar.svg')),
                              SizedBox(
                                width: Dim().d16,
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: 50,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        stream.timeout(Duration(seconds: 1));
                                        STM().redirect2page(
                                            ctx, BuyStock(details: data));
                                      },
                                      style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          shadowColor: Colors.transparent,
                                          backgroundColor: Clr().accentColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5))),
                                      child: Text(
                                        'Buy',
                                        style: Sty().largeText.copyWith(
                                            fontSize: 16,
                                            color: Clr().white,
                                            fontWeight: FontWeight.w600),
                                      )),
                                ),
                              ),

                              // Expanded(
                              //   child: SizedBox(
                              //     height: 50,
                              //     child: ElevatedButton(
                              //         onPressed: () {
                              //           STM().redirect2page(ctx,
                              //               SellStock(details: data));
                              //           // updateProfile();
                              //         },
                              //         style: ElevatedButton.styleFrom(
                              //             elevation: 0,
                              //             primary: Colors.transparent,
                              //             onSurface: Colors.transparent,
                              //             shadowColor: Colors.transparent,
                              //             backgroundColor: Clr().red,
                              //             shape: RoundedRectangleBorder(
                              //                 borderRadius:
                              //                     BorderRadius.circular(5))),
                              //         child: Text(
                              //           'Sell',
                              //           style: Sty().largeText.copyWith(
                              //               fontSize: 16,
                              //               color: Clr().white,
                              //               fontWeight: FontWeight.w600),
                              //         )),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        // SizedBox(
                        //  ,mm,,,m,m
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        //   child: SizedBox(
                        //     height: 45,
                        //     width: MediaQuery.of(ctx).size.width * 100,
                        //     child: ElevatedButton(
                        //         onPressed: () {
                        //           STM().redirect2page(ctx, MyOrders());
                        //           // updateProfile();
                        //         },
                        //         style: ElevatedButton.styleFrom(
                        //             side: BorderSide(color: Clr().textcolor),
                        //             elevation: 0,
                        //             primary: Colors.transparent,
                        //             onSurface: Colors.transparent,
                        //             shadowColor: Colors.transparent,
                        //             backgroundColor: Clr().white,
                        //             shape: RoundedRectangleBorder(
                        //                 borderRadius: BorderRadius.circular(5))),
                        //         child: Row(
                        //           mainAxisAlignment: MainAxisAlignment.center,
                        //           children: [
                        //             SvgPicture.asset('assets/orders.svg'),
                        //             SizedBox(
                        //               width: Dim().d8,
                        //             ),
                        //             Text(
                        //               'Orders',
                        //               style: Sty().largeText.copyWith(
                        //                   fontSize: 16,
                        //                   color: Clr().textcolor,
                        //                   fontWeight: FontWeight.w400),
                        //             ),
                        //           ],
                        //         )),
                        //   ),
                        // ),
                        SizedBox(
                          height: Dim().d20,
                        ),
                      ],
                    )
                  ],
                ),
              ),
      ),
    );
  }

  Widget resultLayout(ctx, index, resultList) {
    var v = resultList[index];
    return InkWell(
      onTap: () {
        _data.clear();
        DateTime fromdate = DateTime.now();
        // DateTime oneminutedate = DateTime(fromdate.year - fromdate.month - 2 - fromdate.day);
        DateTime oneminutedate = fromdate.subtract(Duration(days: 60));
        DateTime thirtyminutedate = fromdate.subtract(Duration(days: 60));
        DateTime daydate =
            DateTime(fromdate.year, fromdate.month - 6, fromdate.day);
        DateTime weekdate =
            DateTime(fromdate.year, fromdate.month - 24, fromdate.day);
        DateTime monthdate =
            DateTime(fromdate.year, fromdate.month - 60, fromdate.day);

        String list1 =
            'https://api-v2.upstox.com/historical-candle/${data['instrument_token']}/1minute/${DateFormat('yyyy-MM-dd').format(fromdate)}/${DateFormat('yyyy-MM-dd').format(oneminutedate)}';

        // String list2 =
        //     'https://api-v2.upstox.com/historical-candle/${data['instrument_token']}/30minute/${DateFormat('yyyy-MM-dd').format(fromdate)}/${DateFormat('yyyy-MM-dd').format(thirtyminutedate)}';
        String list3 =
            'https://api-v2.upstox.com/historical-candle/${data['instrument_token']}/day/${DateFormat('yyyy-MM-dd').format(fromdate)}/${DateFormat('yyyy-MM-dd').format(daydate)}';

        String list4 =
            'https://api-v2.upstox.com/historical-candle/${data['instrument_token']}/week/${DateFormat('yyyy-MM-dd').format(fromdate)}/${DateFormat('yyyy-MM-dd').format(weekdate)}';
        String list5 =
            'https://api-v2.upstox.com/historical-candle/${data['instrument_token']}/month/${DateFormat('yyyy-MM-dd').format(fromdate)}/${DateFormat('yyyy-MM-dd').format(monthdate)}';
        // print(list1);
        // index == 0
        //     ? stockUpdate(list1)
        //     :
        // // index == 1
        // //         ? stockUpdate(list2)
        // //         :
        // index == 1
        //             ? stockUpdate(list3)
        //             : index == 2
        //                 ? stockUpdate(list4)
        //                 : stockUpdate(list5);
        // setState(() {
        //   isSelected = index;
        // });
        setState(() {
          check = '1 minute';
        });
        ominuteStream = !kIsWeb
            ? Stream.periodic(Duration(seconds: 5)).asyncMap((event) async =>
                await stockUpdate(checkmarket == false
                    ? 'https://api-v2.upstox.com/historical-candle/${data['instrument_token']}/1minute/${DateFormat('yyyy-MM-dd').format(fromdate)}/${DateFormat('yyyy-MM-dd').format(oneminutedate)}'
                    : 'https://api-v2.upstox.com/historical-candle/intraday/${data['instrument_token']}/1minute'))
            : candleData();
        // stockUpdate(checkmarket == false
        //     ? 'https://api-v2.upstox.com/historical-candle/${data['instrument_token']}/1minute/${DateFormat('yyyy-MM-dd').format(fromdate)}/${DateFormat('yyyy-MM-dd').format(oneminutedate)}'
        //     : 'https://api-v2.upstox.com/historical-candle/intraday/${data['instrument_token']}/1minute');
        // print('https://api-v2.upstox.com/historical-candle/intraday/${data['instrument_token']}/1minute');
      },
      child: Container(
        height: 50,
        decoration: isSelected == index
            ? BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                    color: isSelected == index
                        ? Clr().borderColor
                        : Clr().transparent),
                color: Clr().white,
                boxShadow: [
                  BoxShadow(
                    color: Clr().grey.withOpacity(0.1),
                    spreadRadius: 0.1,
                    blurRadius: 12,
                    offset: Offset(0, 7), // changes position of shadow
                  ),
                ],
              )
            : null,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dim().d12),
          // v['name'].toString(),
          child: Center(
              child: Text(
            '1 minute',
            style: Sty().smallText.copyWith(color: Clr().black),
          )),
        ),
      ),
    );
  }

  /// api type
  apitype() async {
    FormData body = FormData.fromMap({
      'stock_id': widget.type == 'watch'
          ? widget.details['stock_id']
          : widget.details['id']
    });
    var result =
        await STM().postListWithoutDialog(ctx, 'stock_details', Token, body);
    if (result['success'] == true) {
      setState(() {
        data = result['data'];
        checkmarket = result['data']['is_open'];
        instrumenttoken = data['instrument_token'];
      });
      if (result['data']['is_favourite'] == true) {
        setState(() {
          isdislike.clear();
          widget.type == 'watch'
              ? isLike.add(widget.details['stock_id'])
              : isLike.add(data['id']);
        });
      } else {
        setState(() {
          isLike.clear();
          widget.type == 'watch'
              ? isdislike.add(widget.details['stock_id'])
              : isdislike.add(data['id']);
        });
      }
    }
  }

  api1type() async {
    FormData body = FormData.fromMap({
      'stock_id': widget.type == 'watch'
          ? widget.details['stock_id']
          : widget.details['id']
    });
    var result =
        await STM().postListWithoutDialog(ctx, 'stock_details', Token, body);
    if (result['success'] == true) {
      setState(() {
        data = result['data'];
        checkmarket = result['data']['is_open'];
        instrumenttoken = data['instrument_token'];
        DateTime fromdate = DateTime.now();
        DateTime oneminutedate = fromdate.subtract(Duration(days: 60));
        if (!kIsWeb) {
          instrumenttoken != null
              ? stockUpdate(checkmarket == false
                  ? 'https://api-v2.upstox.com/historical-candle/${data['instrument_token']}/1minute/${DateFormat('yyyy-MM-dd').format(fromdate)}/${DateFormat('yyyy-MM-dd').format(oneminutedate)}'
                  : 'https://api-v2.upstox.com/historical-candle/intraday/${instrumenttoken}/1minute')
              : Container();
        } else {
          candleData();
        }
      });
      if (result['data']['is_favourite'] == true) {
        setState(() {
          isdislike.clear();
          widget.type == 'watch'
              ? isLike.add(widget.details['stock_id'])
              : isLike.add(data['id']);
        });
      } else {
        setState(() {
          isLike.clear();
          widget.type == 'watch'
              ? isdislike.add(widget.details['stock_id'])
              : isdislike.add(data['id']);
        });
      }
    }
  }

  apiType({apiname, type, value}) async {
    var data = FormData.fromMap({});
    switch (apiname) {
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

  candleData() async {
    loading = false;
    DateTime fromdate = DateTime.now();
    DateTime oneminutedate = fromdate.subtract(Duration(days: 60));
    FormData body = FormData.fromMap({
      'instrument_token': instrumenttoken,
      'from_date': DateFormat('yyyy-MM-dd').format(fromdate),
      'to_date': DateFormat('yyyy-MM-dd').format(oneminutedate),
    });
    var result = await STM().postWithoutDialog(ctx, 'get_candle_data', body);
    var message = result['message'];
    var success = result['success'];
    if (success) {
      setState(() {
        _data.clear();
        loading = true;
        List<dynamic> allstock = result['data']['data']['candles'];
        print(result['data']['data']['candles']);
        List<CandleData> candles = allstock
            .map((e) => CandleData(
                  timestamp:
                      DateTime.parse(e[0].toString()).millisecondsSinceEpoch,
                  open: e[1]?.toDouble(),
                  high: e[2]?.toDouble(),
                  low: e[3]?.toDouble(),
                  close: e[4]?.toDouble(),
                  volume: e[5]?.toDouble(),
                ))
            .toList();
        _data = candles.reversed.toList();
        // _data = allstock
        //     .map((e) => Candle.fromJson(e))
        //     .toList();
        allstock.isEmpty ? loading = true : loading = false;
      });
    } else {
      setState(() {
        loading = true;
      });
      STM().errorDialog(ctx, message);
    }
  }

  stockUpdate(apiname) async {
    loading = false;
    Dio dio = Dio(
      BaseOptions(
        headers: {
          "Access-Control-Allow-Origin": "https://api-v2.upstox.com",
          "Access-Control-Allow-Methods": "GET,PUT,PATCH,POST,DELETE",
          "Access-Control-Allow-Headers":
              "Origin, X-Requested-With, Content-Type, Accept",
          "Content-Type": 'application/json',
          "responseType": "ResponseType.plain",
          "Api-Version": "2.0",
        },
      ),
    );
    String url = apiname;
    dynamic result;
    try {
      Response response = await dio.get(url);
      if (kDebugMode) {
        print("Response = $response");
      }
      if (response.statusCode == 200) {
        result = response.data;
      }
    } on DioError catch (e) {
      STM().errorDialog(ctx, e.message);
    }
    print(apiname);
    var success = result['status'];
    if (success == 'success') {
      setState(() {
        _data.clear();
        List<dynamic> allstock = result['data']['candles'];
        print(result['data']['candles']);
        List<CandleData> candles = allstock
            .map((e) => CandleData(
                  timestamp:
                      DateTime.parse(e[0].toString()).millisecondsSinceEpoch,
                  open: e[1]?.toDouble(),
                  high: e[2]?.toDouble(),
                  low: e[3]?.toDouble(),
                  close: e[4]?.toDouble(),
                  volume: e[5]?.toDouble(),
                ))
            .toList();
        _data = candles.reversed.toList();
        // _data = allstock
        //     .map((e) => Candle.fromJson(e))
        //     .toList();
        allstock.isEmpty ? loading = true : loading = false;
      });
      print(_data);
    } else {
      setState(() {
        loading = true;
        message = "we don't get any data for this stock";
      });
    }
  }

// _computeTrendLines() {
//   final ma7 = CandleData.computeMA(_data, 7);
//   final ma30 = CandleData.computeMA(_data, 30);
//   final ma90 = CandleData.computeMA(_data, 90);
//
//   for (int i = 0; i < _data.length; i++) {
//     _data[i].trends = [ma7[i], ma30[i], ma90[i]];
//   }
// }
//
// _removeTrendLines() {
//   for (final data in _data) {
//     data.trends = [];
//   }
// }
}
