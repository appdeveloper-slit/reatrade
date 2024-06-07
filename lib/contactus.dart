import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:storak/values/colors.dart';
import 'package:storak/values/dimens.dart';
import 'package:storak/values/styles.dart';
import 'package:url_launcher/url_launcher.dart';

import 'manage/static_method.dart';

class contactUs extends StatefulWidget {
  const contactUs({super.key});

  @override
  State<contactUs> createState() => _contactUsState();
}

class _contactUsState extends State<contactUs> {
  late BuildContext ctx;

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Clr().black,
      appBar: AppBar(
        backgroundColor: Clr().black,
        leading: InkWell(
          onTap: () {
            STM().back2Previous(ctx);
          },
          child: Padding(
            padding: EdgeInsets.all(Dim().d16),
            child: Icon(Icons.arrow_back, color: Clr().white),
          ),
        ),
        title: Text('Contact Us',
            style: Sty().mediumText.copyWith(color: Clr().white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 32,
            ),
            Image.asset('assets/contact_banner.png'),
            SizedBox(
              height: 20,
            ),
            Text(
              'Contact Information',
              style: Sty().largeText.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                    color: Clr().white,
                  ),
            ),
            SizedBox(
              height: 4,
            ),
            Text('Have any query contact us',
                style: Sty().microText.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Clr().white,
                    )),
            SizedBox(height: 20),
            SvgPicture.asset(
              'assets/phone.svg',
              color: Clr().white,
            ),
            SizedBox(
              height: 4,
            ),
            InkWell(
                onTap: () {
                  STM().openDialer(
                    '1877654398',
                  );
                },
                child: Text(
                  '1877654398',
                  style: Sty().smallText.copyWith(
                        color: Clr().white,
                      ),
                )),
            SizedBox(height: 20),
            SvgPicture.asset(
              'assets/mail.svg',
              color: Clr().white,
            ),
            InkWell(
                onTap: () async {
                  await launch('mailto:customersupport@reatrade.in');
                },
                child: Text(
                  'customersupport@reatrade.in',
                  style: Sty().smallText.copyWith(
                        color: Clr().white,
                      ),
                )),
            InkWell(
                onTap: () async {
                  await launch('mailto:grievanceofficer@reatrade.in');
                },
                child: Text(
                  'grievanceofficer@reatrade.in',
                  style: Sty().smallText.copyWith(
                        color: Clr().white,
                      ),
                )),
            SizedBox(height: Dim().d20),
            // SvgPicture.asset('assets/mail.svg'),
            // InkWell(
            //     onTap: () async {
            //       await launch('mailto:grienvances@storak.in');
            //     },
            //     child: Text('grienvances@storak.in')),
            // SizedBox(height: 20),
            Icon(Icons.maps_home_work, color: Clr().white),
            InkWell(
              onTap: () {
                MapsLauncher.launchQuery(
                    'RG Trade Tower, Netaji Subhash Place, Pitam Pura, New Delhi-110034');
              },
              child: Text(
                'RG Trade Tower, Netaji Subhash Place, Pitam Pura, New Delhi-110034',
                textAlign: TextAlign.center,
                style: Sty().smallText.copyWith(
                      color: Clr().white,
                    ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      )),
    );
  }
}
