import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircleBoxImage extends StatelessWidget {
  final String? image;
  final double radius;
  CircleBoxImage(this.image, this.radius);

  ImageProvider<Object>? toggleImage(String? image) {
    if (image == '' || image == null) {
      return AssetImage('assets/newUser.png');
    } else {
      return NetworkImage(image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
        )
      ]),
      child: CircleAvatar(
        radius: radius,
        backgroundImage: toggleImage(image),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
