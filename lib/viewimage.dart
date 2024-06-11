import 'package:flutter/material.dart';
import 'package:storak/manage/static_method.dart';
import 'package:storak/values/dimens.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'values/colors.dart';

class viewImage extends StatefulWidget {
  final img;

  const viewImage({super.key, this.img});

  @override
  State<viewImage> createState() => _viewImageState();
}

class _viewImageState extends State<viewImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            STM().back2Previous(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Clr().white,
          ),
        ),
        backgroundColor: Clr().black,
        forceMaterialTransparency: true,
      ),
      backgroundColor: Clr().black,
      body: Column(
        children: [
          SizedBox(
            height: Dim().d32,
          ),
          Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 1.3,
              child: widget.img.toString().contains('https')
                  ? Image.network(widget.img)
                  : kIsWeb
                      ? Image.memory(widget.img)
                      : Image.file(widget.img),
            ),
          ),
        ],
      ),
    );
  }
}
