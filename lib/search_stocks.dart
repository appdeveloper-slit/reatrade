import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storak/home.dart';
import 'package:storak/localstore.dart';
import 'package:storak/portfoilio.dart';
import 'package:storak/watchlist.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'manage/static_method.dart';
import 'stock_chart.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class SearchStocks extends StatefulWidget {
  final type;
  const SearchStocks({super.key, this.type});

  @override
  State<SearchStocks> createState() => _SearchStocksState();
}

class _SearchStocksState extends State<SearchStocks> {
  late BuildContext ctx;
  String? Token;

  List isLike = [];
  List isdislike = [];
  List<dynamic> addToCart = [];
  List<dynamic> resultList = [];
  TextEditingController serachCrl = TextEditingController();

  // _refreshData() async {
  //   dynamic data = await Store.getItems();
  //   setState(() {
  //     addToCart = data;
  //     resultList = addToCart;
  //     print(addToCart.length);
  //   });
  // }

  getSessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    // var status = await OneSignal.shared.getDeviceState();
    setState(() {
      Token = sp.getString('token');
      // sUserid = sp.getString('user_id');
      // sUUID = status?.userId;
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        // getHome();
        // _refreshData();
        allStocks();
      }
    });
  }

  @override
  void initState() {
    getSessionData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return WillPopScope(
      onWillPop: () async {
        widget.type == 'home'
            ? STM().finishAffinity(ctx, Home())
            : widget.type == 'port'
                ? STM().replacePage(ctx, Portfolio())
                : widget.type == 'watch'
                    ? STM().replacePage(ctx, WatchList(type: 'home'))
                    : STM().back2Previous(ctx);
        return false;
      },
      child: Scaffold(
        backgroundColor: Clr().black,
        bottomNavigationBar: bottomBarLayout(ctx, 0, '', b: true),
        appBar: AppBar(
          toolbarHeight: Dim().d80,
          elevation: 1,
          shadowColor: Clr().lightShadow,
          backgroundColor: Clr().black,
          leadingWidth: 40,
          leading: InkWell(
            onTap: () {
              widget.type == 'home'
                  ? STM().finishAffinity(ctx, Home())
                  : widget.type == 'port'
                      ? STM().replacePage(ctx, Portfolio())
                      : widget.type == 'watch'
                          ? STM().replacePage(ctx, WatchList(type: 'home'))
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
          title: TextFormField(
            controller: serachCrl,
            style: Sty().mediumText.copyWith(color: Clr().white),
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.done,
            onChanged: searchresult,
            decoration: Sty().textFieldOutlineStyle2.copyWith(
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(Dim().d12),
                    child: SvgPicture.asset(
                      'assets/search.svg',
                      color: Clr().white,
                    ),
                  ),
                  hintStyle: Sty().smallText.copyWith(
                        color: Clr().white,
                      ),
                  // suffixIcon: serachCrl.text.isNotEmpty
                  //     ? InkWell(
                  //         onTap: () {
                  //           serachCrl.clear();
                  //           setState(() {
                  //             resultList = addToCart;
                  //           });
                  //         },
                  //         child: Padding(
                  //           padding: EdgeInsets.all(Dim().d12),
                  //           child: SvgPicture.asset(
                  //             'assets/close.svg',
                  //           ),
                  //         ),
                  //       )
                  //     : Container(),
                  //         filled: true,
                  //         fillColor: Clr().white,
                  //         hintText: "Search for any stocks",
                  //         counterText: "",
                  //         // prefixIcon: Icon(
                  //         //   Icons.call,
                  //         //   color: Clr().lightGrey,
                  //         // ),
                ),
            validator: (value) {
              if (value!.isEmpty) {
                return Str().invalidEmpty;
              } else {
                return null;
              }
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(Dim().d16),
          child: ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemCount: resultList.length,
            itemBuilder: (ctx, index) {
              return marketLayout(ctx, resultList[index]);
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                height: Dim().d8,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget marketLayout(ctx, v) {
    return InkWell(
      onTap: () {
        STM().replacePage(
            ctx,
            StockChart(
              type: 'search',
              details: v,
            ));
      },
      child: Container(
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: Color(0xFFA3A3A3)),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                          style:
                              Sty().smallText.copyWith(color: Clr().textcolor),
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
                  // Expanded(
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.end,
                  //     children: [
                  //       Wrap(
                  //         crossAxisAlignment: WrapCrossAlignment.center,
                  //         children: [
                  //           SvgPicture.asset('assets/down.svg'),
                  //           SizedBox(
                  //             width: Dim().d8,
                  //           ),
                  //           Text(
                  //             '19,020',
                  //             style: Sty().smallText.copyWith(color: Clr().red),
                  //           )
                  //         ],
                  //       ),
                  //       SizedBox(
                  //         height: Dim().d8,
                  //       ),
                  //       Text(
                  //         '-1.26 (-0.59%)',
                  //         style: Sty().microText.copyWith(color: Clr().grey),
                  //       ),
                  //     ],
                  //   ),
                  // // ),
                  // SizedBox(
                  //   width: Dim().d16,
                  // ),
                  // isLike.map((e) => e.toString()).contains(v['stockID'].toString()) ? InkWell(
                  //       onTap: () {
                  //         apiType(
                  //             apiname: 'remove_favourite',
                  //             type: 'post',
                  //             value: v['stockID']);
                  //         if (isdislike.contains(v['stockID'])) {
                  //           setState(() {
                  //             isdislike.remove(v['stockID']);
                  //           });
                  //         } else {
                  //           setState(() {
                  //             isLike.remove(v['stockID']);
                  //             isdislike.add(v['stockID']);
                  //           });
                  //         }
                  //       },
                  //       child: SvgPicture.asset('assets/star.svg')) :  InkWell(
                  //       onTap: () {
                  //         apiType(
                  //             apiname: 'add_favourite',
                  //             type: 'post',
                  //             value: v['stockID']);
                  //         if (isLike.contains(v['stockID'])) {
                  //           setState(() {
                  //             isLike.remove(v['stockID']);
                  //           });
                  //         } else {
                  //           setState(() {
                  //             isdislike.remove(v['stockID']);
                  //             isLike.add(v['stockID']);
                  //           });
                  //         }
                  //       },
                  //       child: SvgPicture.asset('assets/watchlisticon.svg')),
                ],
              ),
              // SizedBox(
              //   height: Dim().d8,
              // ),
              // Divider(
              //   color: Clr().lightGrey,
              // )
            ],
          ),
        ),
      ),
    );
  }

  ///getprofile
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

  allStocks() async {
    var result = await STM().getWithoutDialog(ctx, 'all_stocks', Token);
    setState(() {
      addToCart = result['data'];
      resultList = addToCart;
    });
  }

  void searchresult(value) {
    if (value.isEmpty) {
      setState(() {
        resultList = addToCart;
      });
    } else {
      setState(() {
        resultList = addToCart.where((element) {
          final resultTitle = element['symbol'].toLowerCase();
          final input = value.toLowerCase();
          return resultTitle
              .toString()
              .toLowerCase()
              .startsWith(input.toString().toLowerCase());
        }).toList();
      });
    }
  }
}
