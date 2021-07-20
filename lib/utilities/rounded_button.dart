import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Function() onTap;
  RoundedButton({required this.text, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: ElevatedButton(
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(10.0),
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed))
                    return Color(0xFFC800FF);
                  return Color(0xFF8800FF);
                },
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                text,
                style: TextStyle(fontSize: 18),
              ),
            ),
            onPressed: onTap,
          ),
        ),
      ],
    );
  }
}
