import 'package:flutter/material.dart';

const kSubscript = TextStyle(
  fontSize: 15.0,
  fontWeight: FontWeight.w300,
);
const kErrorStyle = TextStyle(
  fontSize: 15.0,
  color: Colors.red,
);
const kTextFieldDecoration = InputDecoration(
  prefixIcon: null,
  suffixIcon: null,
  border: InputBorder.none,
  hintText: 'Enter a value',
  hintStyle: TextStyle(fontSize: 20),
  contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Color(0xFF5A5B5C),
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(15.0),
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.purple, width: 2.0),
    borderRadius: BorderRadius.all(
      Radius.circular(15.0),
    ),
  ),
  fillColor: Color(0xFF5A5B5C),
  filled: true,
);
