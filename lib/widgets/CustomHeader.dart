import 'package:ejara_app/constants/AppColor.dart';
import 'package:flutter/material.dart';

import 'CustomCurveClipper.dart';

// ignore: must_be_immutable
class CustomHeader extends StatefulWidget{

  String title;

  CustomHeader({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CustomHeaderState();
  }

}

class _CustomHeaderState extends State<CustomHeader>{
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: CustomCurveClipper(),
          child: Container(
            color: AppColor.primary_color.withOpacity(1.0),
            height: height /2 + 50,
            width: width,
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          height: height/2,
          width: width,
          child: Image.asset("assets/images/backgroundIcons.png"),
        ),
        Container(
          alignment: Alignment.centerRight,
          height: height/2,
          width: width,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Image.asset("assets/images/ejaraLogoWhite.png"),
                Text(widget.title,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

}
