import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';

String getAudioUrl(
  String? recitorName,
  List<String> urls,
) {
  final List<String> recitorNames = ["حفص", "ورش", "خلف عن حمزة"];
  int index = recitorName != null ? recitorNames.indexOf(recitorName) : 0;
  if (index >= 0 && index < urls.length) {
    return urls[index];
  } else {
    return '';
  }
}
