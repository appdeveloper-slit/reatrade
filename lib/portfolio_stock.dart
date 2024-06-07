import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'bottom_navigation/bottom_navigation.dart';
import 'manage/static_method.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/styles.dart';

class PortfolioStock extends StatefulWidget {
  @override
  State<PortfolioStock> createState() => _PortfolioStockState();
}

class _PortfolioStockState extends State<PortfolioStock> {
  late BuildContext ctx;

  @override
  Widget build(BuildContext context) {
    ctx = context;

    return Scaffold(
      backgroundColor: Clr().black,
      bottomNavigationBar: bottomBarLayout(ctx, 0, '', b: true),
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'TITAN',
                  style: Sty().smallText.copyWith(
                        color: Clr().textcolor,
                      ),
                ),
                SizedBox(
                  width: Dim().d4,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Clr().white,
                  ),
                  width: 40,
                  height: 20,
                  child: Center(
                    child: Text(
                      'NSE',
                      style: Sty().microText.copyWith(
                          color: Clr().textcolor, fontWeight: FontWeight.w300),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: Dim().d4,
            ),
            Text(
              'Titan Company Limited',
              style: Sty().microText.copyWith(
                    color: Clr().grey,
                  ),
            ),
          ],
        ),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: Dim().d16),
              child: SvgPicture.asset(
                'assets/star.svg',
                width: 25,
              )),
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(Dim().d16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Wrap(
                  children: [
                    SvgPicture.asset(
                      'assets/stock_type.svg',
                      width: 38,
                    ),
                    SizedBox(
                      width: Dim().d8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Stock Type',
                          style: Sty().microText.copyWith(
                              color: Clr().textcolor,
                              fontWeight: FontWeight.w300),
                        ),
                        SizedBox(
                          height: Dim().d4,
                        ),
                        Text(
                          'BUY',
                          style: Sty().smallText.copyWith(
                              color: Clr().accentColor,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '06 july 2023 ',
                      style: Sty().microText.copyWith(
                          color: Clr().grey, fontWeight: FontWeight.w300),
                    ),
                    SizedBox(
                      height: Dim().d4,
                    ),
                    Text(
                      '12:04 pm',
                      style: Sty().microText.copyWith(
                          color: Clr().grey, fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: Dim().d4,
            ),
            Divider(
              color: Clr().accentColor,
            ),
            SizedBox(
              height: Dim().d8,
            ),
            Text(
              'Total Investment',
              style: Sty()
                  .microText
                  .copyWith(color: Clr().grey, fontWeight: FontWeight.w300),
            ),
            SizedBox(
              height: Dim().d4,
            ),
            Text(
              '₹ 600',
              style: Sty().smallText.copyWith(
                  color: Clr().textcolor, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: Dim().d24,
            ),
            Text(
              'Market Value',
              style: Sty()
                  .microText
                  .copyWith(color: Clr().grey, fontWeight: FontWeight.w300),
            ),
            SizedBox(
              height: Dim().d4,
            ),
            Text(
              '₹ 700',
              style: Sty().smallText.copyWith(
                  color: Clr().textcolor, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: Dim().d24,
            ),
            Text(
              'Total Quantity',
              style: Sty()
                  .microText
                  .copyWith(color: Clr().grey, fontWeight: FontWeight.w300),
            ),
            SizedBox(
              height: Dim().d4,
            ),
            Text(
              '2',
              style: Sty().smallText.copyWith(
                  color: Clr().textcolor, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: Dim().d24,
            ),
            Text(
              'Total Gain/Loss',
              style: Sty()
                  .microText
                  .copyWith(color: Clr().grey, fontWeight: FontWeight.w300),
            ),
            SizedBox(
              height: Dim().d4,
            ),
            RichText(
              text: TextSpan(
                text: '+₹45.32',
                style: Sty().smallText.copyWith(
                    color: Clr().accentColor, fontWeight: FontWeight.w500),
                children: <TextSpan>[
                  TextSpan(
                    text: ' (+4.78%)',
                    style: Sty().smallText.copyWith(
                        color: Clr().textcolor,
                        fontWeight: FontWeight.w400,
                        fontFamily: ''),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Dim().d24,
            ),
            Text(
              'Average Traded Price',
              style: Sty()
                  .microText
                  .copyWith(color: Clr().grey, fontWeight: FontWeight.w300),
            ),
            SizedBox(
              height: Dim().d4,
            ),
            Text(
              '₹ 600.45',
              style: Sty().smallText.copyWith(
                  color: Clr().textcolor, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: Dim().d24,
            ),
            Text(
              'Transaction ID:',
              style: Sty()
                  .microText
                  .copyWith(color: Clr().grey, fontWeight: FontWeight.w300),
            ),
            SizedBox(
              height: Dim().d4,
            ),
            Text(
              '8934284303234',
              style: Sty().smallText.copyWith(
                  color: Clr().textcolor, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: Dim().d24,
            ),
            Text(
              'Service Charges',
              style: Sty()
                  .microText
                  .copyWith(color: Clr().grey, fontWeight: FontWeight.w300),
            ),
            SizedBox(
              height: Dim().d4,
            ),
            Text(
              '₹ 119.5',
              style: Sty().smallText.copyWith(
                  color: Clr().textcolor, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: Dim().d72,
            ),
            SizedBox(
              height: 45,
              width: MediaQuery.of(ctx).size.width * 100,
              child: ElevatedButton(
                  onPressed: () {
                    // STM().redirect2page(
                    //     ctx,
                    //     Verification(
                    //       mobileCtrl.text.toString(),
                    //     ));
                    // updateProfile();
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      primary: Colors.transparent,
                      onSurface: Colors.transparent,
                      shadowColor: Colors.transparent,
                      backgroundColor: Clr().red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
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
    );
  }
}
