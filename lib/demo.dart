// // ignore_for_file: prefer_const_constructors

// import 'dart:convert';

// import 'package:candlesticks/candlesticks.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'manage/static_method.dart';
// import 'values/colors.dart';
// import 'values/dimens.dart';
// import 'values/strings.dart';
// import 'values/styles.dart';
// import 'package:http/http.dart' as http;

// class chartDislpay extends StatefulWidget {
//   const chartDislpay({super.key});

//   @override
//   State<chartDislpay> createState() => _chartDislpayState();
// }

// class _chartDislpayState extends State<chartDislpay> {
//   List candles = [];

//   fetchCandles() async {
//     final uri = Uri.parse(
//         "https://api.twelvedata.com/time_series?symbol=AADHARHFC&interval=1min&exchange=NSE&apikey=799a04c1b05841378df39c2024380018");
//     final res = await http.get(uri);
//     var data = jsonDecode(res.body.toString());
//     setState(() {
//       candles = data['values'];
//        List<CandleData> candless = candles
//             .map((e) => CandleData(
//                   timestamp:
//                       DateTime.parse(e[0].toString()).millisecondsSinceEpoch,
//                   open: e[1]?.toDouble(),
//                   high: e[2]?.toDouble(),
//                   low: e[3]?.toDouble(),
//                   close: e[4]?.toDouble(),
//                   volume: e[5]?.toDouble(),
//                 ))
//             .toList();
//     });
//   }

//   @override
//   void initState() {
//     fetchCandles();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData.light(),
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text("BTCUSDT 1H Chart"),
//           actions: [
//             IconButton(
//               onPressed: () {},
//               icon: Icon(
//                 Icons.nightlight_round_outlined,
//               ),
//             )
//           ],
//         ),
//         body: Center(
//           child: Candlesticks(
//             candles: candles,
//           ),
//         ),
//       ),
//     );
//   }
// }
