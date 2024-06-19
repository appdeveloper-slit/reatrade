import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storak/home.dart';
import 'package:storak/manage/static_method.dart';
import 'package:storak/values/colors.dart';
import 'package:storak/values/dimens.dart';
import 'package:storak/values/strings.dart';
import 'package:storak/values/styles.dart';
import 'my_orders.dart';

class SellPageFinal extends StatefulWidget {
  final dynamic details;

  const SellPageFinal({super.key, this.details});

  @override
  State<SellPageFinal> createState() => _SellPageFinalState();
}

class _SellPageFinalState extends State<SellPageFinal> {
  late BuildContext ctx;
  dynamic data;
  String? Token;
  TextEditingController priceCtrl = TextEditingController();
  String markettypevalue = 'Market';
  List marketype = ['Market', 'Limit'];

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      Token = sp.getString('token');
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dim().d20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Dim().d20),
            Text('No. of shares',
                style: Sty().mediumText.copyWith(
                      color: Clr().white,
                    )),
            SizedBox(height: Dim().d4),
            Text('${widget.details['quantity']}',
                style: Sty().mediumText.copyWith(
                      color: Clr().white,
                    )),
            SizedBox(height: Dim().d32),
            Text('Price',
                style: Sty().mediumText.copyWith(
                      color: Clr().white,
                    )),
            SizedBox(height: Dim().d12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: priceCtrl,
                    readOnly: markettypevalue == 'Market' ? true : false,
                    cursorColor: Clr().primaryColor,
                    style: Sty().mediumText.copyWith(
                          color: Clr().white,
                        ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    decoration: Sty().textFieldOutlineStyle.copyWith(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: Dim().d0, horizontal: Dim().d8),
                          hintStyle: Sty().smallText.copyWith(
                                color: Clr().grey,
                              ),
                          // filled: true,
                          // fillColor: Clr().white,
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
                        // bb = v.toString();
                        // marketValueAmt(
                        //     shareCtrl.text.toString(),
                        //     priceCtrl.text.toString());
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
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Clr().borderColor)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dim().d16),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<dynamic>(
                          value: markettypevalue,
                          hint: Text(
                            markettypevalue ?? 'Select Market',
                            // 'Select State',
                            style: TextStyle(
                              fontSize: 14,
                              color: markettypevalue != null
                                  ? Clr().white
                                  : Color(0xff787882),
                              // color: Color(0xff787882),
                              fontFamily: 'Inter',
                            ),
                          ),
                          isExpanded: true,
                          icon: SvgPicture.asset(
                            'assets/dropdown.svg',
                            color: Clr().primaryColor,
                          ),
                          style: TextStyle(
                              color: markettypevalue != null
                                  ? Clr().white
                                  : Clr().white),
                          // style: TextStyle(color: Color(0xff787882)),
                          dropdownColor: Clr().black,
                          items: marketype.map((string) {
                            return DropdownMenuItem<String>(
                              value: string,
                              // value: string['id'].toString(),
                              child: Text(
                                string,
                                // string['name'],
                                style:
                                    TextStyle(color: Clr().white, fontSize: 14),
                              ),
                            );
                          }).toList(),
                          onChanged: (v) {
                            setState(() {
                              markettypevalue = v.toString();
                            });
                            if (markettypevalue == 'Market') {
                              setState(() {
                                priceCtrl = TextEditingController(
                                    text: data['last_price']);
                              });
                            } else {
                              setState(() {
                                priceCtrl = TextEditingController(
                                    text: data['last_price'].toString());
                              });
                            }
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
            Expanded(
              child: SizedBox(
                height: Dim().d4,
              ),
            ),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    AwesomeDialog(
                        context: context,
                        dialogType: DialogType.noHeader,
                        body: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                'Are you sure about selling/ cancelling this stock / order?',
                                textAlign: TextAlign.center,
                                style: Sty()
                                    .mediumText
                                    .copyWith(fontWeight: FontWeight.w600)),
                            SizedBox(height: Dim().d20),
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: Dim().d12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                        onPressed: () {
                                          STM().back2Previous(ctx);
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xffEDEDED)),
                                        child: Center(
                                          child: Text('No',
                                              style: Sty().mediumText.copyWith(
                                                  color: Clr().black)),
                                        )),
                                  ),
                                  SizedBox(width: Dim().d12),
                                  Expanded(
                                    child: ElevatedButton(
                                        onPressed: () {
                                          sellStockapi();
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Clr().black),
                                        child: Center(
                                          child: Text('Yes',
                                              style: Sty().mediumText.copyWith(
                                                  color: Clr().white)),
                                        )),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: Dim().d12),
                          ],
                        )).show();
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      
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
            SizedBox(
              height: Dim().d20,
            )
          ],
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
        priceCtrl = TextEditingController(text: data['last_price'].toString());
      });
    } else {
      STM().errorDialog(ctx, result['message']);
    }
  }

  sellStockapi() async {
    STM().back2Previous(ctx);
    FormData body = FormData.fromMap({
      'stock_trade_id': widget.details['id'],
      'selling_price': priceCtrl.text,
      'market_value': data['last_price'],
      'type': markettypevalue,
      'stock_id': widget.details['stock_id'],
      'quantity': widget.details['quantity']
    });
    var result = await STM()
        .postWithToken(ctx, Str().processing, 'sell_stock', body, Token);
    if (result['success'] == true) {
      STM().successDialogWithAffinity(
          ctx,
          result['message'],
          MyOrders(
            type: 0,
          ));
    } else {
      STM().errorDialog(ctx, result['message']);
    }
  }
}
