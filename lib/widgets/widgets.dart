import 'package:chatting_app/shared/constans.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const textInputDecoration = InputDecoration(
  labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.blue,
      width: 2,
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.purple,
      width: 2,
    ),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Color(0xFFee7b64),
      width: 2,
    ),
  ),
);
