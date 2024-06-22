import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'manage/static_method.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String? marketValue;
    List<dynamic> marketList = [];
    int isSelected = 2;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Expanded Columns')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1, // Adjust flex value to control how much space it takes
                child: Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          STM().redirect2page(context, MyApp());
                        },
                        child: Text(
                          'No. of shares',
                          style:
                              Sty().microText.copyWith(color: Clr().textcolor),
                        ),
                      ),
                      SizedBox(
                        height: Dim().d12,
                      ),
                      TextFormField(
                        // controller: mobileCtrl2,
                        cursorColor: Clr().primaryColor,
                        style: Sty().mediumText,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        decoration: Sty().textFieldOutlineStyle.copyWith(
                              hintStyle: Sty().smallText.copyWith(
                                    color: Clr().grey,
                                  ),
                              filled: true,
                              fillColor: Clr().white,

                              hintText: "1",
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
                      ),
                      SizedBox(
                        height: Dim().d20,
                      ),
                      Text(
                        'Price',
                        style: Sty().microText.copyWith(color: Clr().textcolor),
                      ),
                      SizedBox(
                        height: Dim().d12,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                SvgPicture.asset('assets/minus_button.svg'),
                                SizedBox(
                                  width: Dim().d4,
                                ),
                                Container(
                                  height: 40,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border:
                                          Border.all(color: Clr().borderColor)),
                                  child: Center(child: Text('212.66')),
                                ),
                                SizedBox(
                                  width: Dim().d4,
                                ),
                                SvgPicture.asset('assets/plus_button.svg'),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: 60,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Clr().borderColor)),
                              child: Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: Dim().d16),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<dynamic>(
                                    // value: sState,
                                    hint: Text(
                                      marketValue ?? 'Market',
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
                                    icon:
                                        SvgPicture.asset('assets/dropdown.svg'),
                                    style: TextStyle(
                                        color: marketValue != null
                                            ? Clr().black
                                            : Color(0xff000000)),
                                    // style: TextStyle(color: Color(0xff787882)),
                                    items: marketList.map((string) {
                                      return DropdownMenuItem<String>(
                                        value: string['name'],
                                        // value: string['id'].toString(),
                                        child: Text(
                                          string['name'],
                                          // string['name'],
                                          style: TextStyle(
                                              color: Clr().black, fontSize: 14),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (v) {
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
                                border: Border.all(color: Clr().borderColor)),
                            child: Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: Dim().d8),
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
                                  icon: SvgPicture.asset('assets/dropdown.svg'),
                                  style: TextStyle(
                                      color: marketValue != null
                                          ? Clr().black
                                          : Color(0xff000000)),
                                  // style: TextStyle(color: Color(0xff787882)),
                                  items: marketList.map((string) {
                                    return DropdownMenuItem<String>(
                                      value: string['name'],
                                      // value: string['id'].toString(),
                                      child: Text(
                                        string['name'],
                                        // string['name'],
                                        style: TextStyle(
                                            color: Clr().black, fontSize: 14),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (v) {
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
                color: Colors.blue,
                child: Column(
                  children: [
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
                            Clr().red,
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
                            // sellStocklayout();
                          },
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Clr().transparent,
                              shadowColor: Colors.transparent,
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
            ],
          ),
        ),
      ),
    );
  }
}
