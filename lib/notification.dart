import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bottom_navigation/bottom_navigation.dart';
import 'manage/static_method.dart';
import 'toolbar/toolbar.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class Notifications extends StatefulWidget {
  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  late BuildContext ctx;

  List<dynamic> notificationList = [];

  String? sToken;

  // getSessionData() async {
  //   SharedPreferences sp = await SharedPreferences.getInstance();
  //   sToken = sp.getString('token') ?? '';
  //   debugPrint(sToken);
  //   STM().checkInternet(ctx, widget).then((value) {
  //     if (value) {
  //       getNotificatins();
  //     }
  //   });
  // }

  // @override
  // void initState() {
  //   getSessionData();
  //   super.initState();
  // }

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
        title: Text(
          'My Notifications',
          style: Sty()
              .mediumText
              .copyWith(color: Clr().textcolor, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(Dim().d16),
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: 0,
              itemBuilder: (context, index) {
                // var v = notificationList[index];
                return Card(
                  elevation: 0.0,
                  color: Color(0xffF8F9F8),
                  margin: EdgeInsets.symmetric(
                      horizontal: Dim().d0, vertical: Dim().d8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dim().d4),
                      side: BorderSide(color: Color(0xffECECEC))),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 20, bottom: 12, left: 20, right: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // notificationList.isEmpty
                          //     ? Container()
                          // Text(
                          //   // v['title'].toString(),
                          //   'Lorem Ipsum is simply dummy te ',
                          //   style: Sty()
                          //       .mediumText
                          //       .copyWith(fontWeight: FontWeight.w500),
                          // ),
                          Divider(
                            color: Clr().grey,
                          ),
                          // notificationList.isEmpty
                          //     ? Container()
                          //     :
                          // Text(
                          //   // v['description'].toString(),
                          //   'Lorem ipsum dolor sit amet, consectetur adipiscing elit. At amet, id lorem placerat neque morbi. Gravida integer lectus tristique ',
                          //   style: TextStyle(
                          //     color: Color(0xff747688),
                          //   ),
                          // ),
                          SizedBox(
                            height: 16,
                          ),
                          Align(
                              alignment: Alignment.centerRight,
                              child:
                                  // notificationList.isEmpty
                                  //     ? Container()
                                  //     :
                                  Text(
                                      // v['created_at'].toString(),
                                      'Today, 11:44 am',
                                      style: Sty().smallText.copyWith(
                                          color: Color(0xff979797),
                                          fontSize: 12)))
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  ///Get Profile API
// void getNotificatins() async {
//   var result =
//       await STM().getcat(ctx, Str().loading, 'get_notifications', sToken);
//   var success = result['success'];
//   var message = result['message'];
//   if (success) {
//     setState(() {
//       notificationList = result['data']['notifications'];
//       print('updateprofile ${notificationList}');
//     });
//   } else {
//     STM().errorDialog(ctx, message);
//   }
// }
}
