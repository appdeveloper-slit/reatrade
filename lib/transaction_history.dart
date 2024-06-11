import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'manage/static_method.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/styles.dart';

class TransactionHistory extends StatefulWidget {
  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory>
    with TickerProviderStateMixin {
  late BuildContext ctx;
  String? Token;

  // dynamic data;
  Map<String, dynamic> data = {};

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      Token = sp.getString('token');
    });
    STM().checkInternet(context, widget).then(
      (value) {
        if (value) {
          getProfile(apiname: 'wallet_history');
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

    TabController _controller = TabController(length: 2, vsync: this);
    return Scaffold(
        backgroundColor: Clr().black,
        bottomNavigationBar: bottomBarLayout(ctx, 0, '', b: true),
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
          title: Text(
            'Transaction History',
            style: Sty()
                .mediumText
                .copyWith(color: Clr().textcolor, fontWeight: FontWeight.w600),
          ),
          bottom: PreferredSize(
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Clr().lightGrey))),
                  child: TabBar(
                    controller: _controller,
                    isScrollable: false,
                    padding: EdgeInsets.symmetric(horizontal: Dim().d20),
                    labelColor: Clr().accentColor,
                    indicatorColor: Clr().accentColor,
                    automaticIndicatorColorAdjustment: true,
                    unselectedLabelColor: Clr().grey,
                    tabs: [
                      Tab(
                        text: 'Funds Added',
                      ),
                      Tab(
                        text: 'Funds Withdrawn',
                      ),
                    ],
                  ),
                ),
              ),
              preferredSize: Size.fromHeight(Dim().d56)),
        ),
        body: data == null
            ? Center(
                child: CircularProgressIndicator(
                  color: Clr().primaryColor,
                ),
              )
            : TabBarView(
                controller: _controller,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: Dim().d12),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dim().d16),
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: data['funds_added'].length,
                        itemBuilder: (ctx, index) {
                          return cardLayout(ctx, data['funds_added'][index]);
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: Dim().d12,
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: Dim().d12),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dim().d16),
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: data['funds_withdrawn'].length,
                        itemBuilder: (ctx, index) {
                          return cardLayout(
                              ctx, data['funds_withdrawn'][index]);
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: Dim().d12,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ));
  }

  Widget cardLayout(ctx, v) {
    return Card(
      color: Clr().grey.withOpacity(0.2),
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
                  // '06 july 2023 / 12:04 pm',
                  '${v['created_at'].toString()}',
                  style: Sty()
                      .microText
                      .copyWith(color: Clr().white, fontSize: 12),
                ),
                Container(
                  color: v['status'] == 0
                      ? Color(0xfff2e529)
                      : v['status'] == 2
                          ? const Color(0xffFFE8E4)
                          : const Color(0xffF1FFF0),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dim().d8, vertical: Dim().d4),
                    child: Text(
                      '${v['status'] == 2 ? 'Failed' : v['status'] == 1 ? 'Success' : 'Pending'}',
                      style: Sty().microText.copyWith(
                          color: Clr().black, fontWeight: FontWeight.w200),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: Dim().d4,
            ),
            Divider(
              color: Clr().clrec,
              thickness: 1.0,
              height: 15,
            ),
            SizedBox(
              height: Dim().d4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   'HDFC Bank Limited',
                    //   style: Sty().smallText.copyWith(
                    //       color: Clr().textcolor, fontWeight: FontWeight.w600),
                    // ),
                    SizedBox(
                      height: Dim().d4,
                    ),
                    Text(
                      '#${v['transaction_id'].toString()}',
                      style: Sty().smallText.copyWith(
                          fontSize: 16,
                          color: Clr().white,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Text(
                  '₹${v['amount']}',
                  style: Sty().smallText.copyWith(
                      fontSize: 16,
                      color: Clr().textcolor,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  getProfile({apiname, type, value}) async {
    var result = await STM().getWithoutDialog(ctx, apiname, Token);
    switch (apiname) {
      case 'wallet_history':
        if (result['success']) {
          setState(() {
            data = result['data'];
          });
        } else {
          STM().errorDialog(ctx, result['message']);
        }
        break;
    }
  }
}
