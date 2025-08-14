import 'package:flutter/material.dart';
import 'package:flutter_chess_game/app.dart';
import 'package:flutter_chess_game/core/error/service_locator/service_locator.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}
