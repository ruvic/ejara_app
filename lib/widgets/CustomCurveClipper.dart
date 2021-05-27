
import 'package:flutter/material.dart';

class CustomCurveClipper extends CustomClipper<Path> {

  @override
  getClip(Size size) {
    // TODO: implement getClip
    var path = new Path();
    var H = size.height * 0.80;
    path.lineTo(0, H);

    var firstControlPoint = new Offset(size.width * 0.40, size.height);
    var firstEndPoint = new Offset(size.width * 0.70,  size.height - 70);

    var secondControlPoint = new Offset(size.width * 0.80, H - 10);
    var secondEndPoint = new Offset(size.width, H+10);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, H);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }



  @override
  bool shouldReclip(CustomClipper oldClipper)
  {
    return true;
  }
}
