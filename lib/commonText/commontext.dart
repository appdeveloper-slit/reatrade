import 'package:flutter/material.dart';

import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';

class cmnTxt {

  commonTextWidget(string) {
    return Text('${string}',
        style: Sty().mediumText.copyWith(
            color: Clr().f5, fontSize: Dim().d36, fontWeight: FontWeight.w800));
  }


  commonTextWidgetOne(string) {
    return Text('${string}',
        style: Sty().mediumText.copyWith(
            color: Clr().e3, fontSize: Dim().d16, fontWeight: FontWeight.w400));
  }
}
