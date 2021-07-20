import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/home/edit_screen.dart';

class ProfileText extends StatefulWidget {
  final String title, body;
  final Widget icon;

  ProfileText({required this.icon, required this.title, required this.body});

  @override
  _ProfileTextState createState() => _ProfileTextState();
}

class _ProfileTextState extends State<ProfileText> {
  bool edit = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              widget.icon,
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.title} : ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Container(
                      width: 250.0,
                      child: Text(
                        widget.body,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
