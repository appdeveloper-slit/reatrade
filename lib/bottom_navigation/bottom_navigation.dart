import 'package:flutter/material.dart';
import 'package:storak/my_orders.dart';
import 'package:storak/values/dimens.dart';
import 'package:storak/values/styles.dart';
import '../home.dart';
import '../manage/static_method.dart';
import '../my_account.dart';
import '../portfoilio.dart';
import '../values/colors.dart';
import '../watchlist.dart';

Widget bottomBarLayout(ctx, index, stream, {b = false}) {
  return BottomNavigationBar(
    elevation: 70,
    backgroundColor: Clr().black,
    selectedItemColor: b ? Clr().grey : Clr().primaryColor,
    unselectedItemColor: Clr().grey,
    selectedFontSize: 00.0,
    unselectedFontSize: 00.0,
    selectedLabelStyle: Sty().smallText.copyWith(color: Clr().primaryColor),
    unselectedLabelStyle: Sty().smallText.copyWith(color: Clr().white),
    type: BottomNavigationBarType.fixed,
    currentIndex: index,
    onTap: (i) async {
      switch (i) {
        case 0:
          STM().finishAffinity(ctx, Home());
          break;
        case 1:
          index == 1
              ? STM().replacePage(ctx, Portfolio())
              : STM().replacePage(ctx, Portfolio());
          break;
        case 2:
          index == 2
              ? STM().replacePage(ctx, WatchList(type: i == 0 ? 0 : ''))
              : STM().replacePage(ctx, WatchList(type: i == 0 ? 0 : ''));
          break;
        case 3:
          index == 3
              ? STM().replacePage(
                  ctx,
                  MyOrders(
                      type: i == 0
                          ? 0
                          : i == 1
                              ? 1
                              : i == 2
                                  ? 2
                                  : ''))
              : STM().replacePage(
                  ctx,
                  MyOrders(
                      type: i == 0
                          ? 0
                          : i == 1
                              ? 1
                              : i == 2
                                  ? 2
                                  : ''));
          break;
        case 4:
          index == 4
              ? STM().replacePage(
                  ctx,
                  MyAccount(
                      type: i == 0
                          ? 0
                          : i == 1
                              ? 1
                              : i == 2
                                  ? 2
                                  : i == 3
                                      ? 3
                                      : ''))
              : STM().replacePage(
                  ctx,
                  MyAccount(
                      type: i == 0
                          ? 0
                          : i == 1
                              ? 1
                              : i == 2
                                  ? 2
                                  : i == 3
                                      ? 3
                                      : ''));
          break;
      }
    },
    items: STM().getBottomList(index, b),
  );
}
