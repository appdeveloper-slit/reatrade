// import 'package:example/test_mutable.dart';
// import 'package:flutter/material.dart';
// import 'package:flutterx_live_data/flutterx_live_data.dart';
// import 'package:flutterx_utils/flutterx_utils.dart';

// void main() => runApp(const MyApp());

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) => MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutterx LiveData Demo',
//       theme: ThemeData(primarySwatch: Colors.teal),
//       home: const LiveDataExample());
// }

// class LiveDataExample extends StatefulWidget {
//   const LiveDataExample({super.key});

//   @override
//   State<LiveDataExample> createState() => _LiveDataExampleState();
// }

// class _LiveDataExampleState extends State<LiveDataExample> {
//   static const List<Widget> _pages = [MutableLiveDataTest()];

//   @override
//   Widget build(BuildContext context) => DefaultTabController(
//       length: _pages.length,
//       child: Scaffold(
//           appBar: AppBar(
//               title: const Text('LiveData example'),
//               bottom: TabBar(
//                   tabs: _pages.map((page) => Tab(text: page.runtimeType.toString().replaceAll('Test', ''))).toList())),
//           body: PageView(
//               children: _pages
//                   .map((page) =>
//                       Center(child: Padding(padding: const EdgeInsets.all(kMinInteractiveDimension), child: page)))
//                   .toList())));
// }

// Widget xColumn(String title, Iterable<Widget> rows) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       Text(title),
//       const SizedBox(height: 12),
//       ...rows.map((row) => SizedBox(height: 24, child: row)),
//     ]);

// Widget xActions(Iterable<Widget> actions) => Row(children: actions.interpolate(const SizedBox(width: 4)).toList());

// Widget xAction({required VoidCallback? onPressed, required IconData icon}) => Center(
//       child: ElevatedButton(
//           onPressed: onPressed,
//           style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(4), minimumSize: Size.zero),
//           child: Icon(icon, size: 14)),
//     );

// Widget xData<T>(ObservableData<T> data) =>
//     LiveDataBuilder<T>(data: data, builder: (context, data) => Text('$data'), placeholder: const Text('--'));