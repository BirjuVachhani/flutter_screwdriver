// Author: Birju Vachhani
// Created Date: September 01, 2020

import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('color tests', () {
    expect('#000000'.toColor(), Colors.black);
    expect('000000'.toColor(), Colors.black);
    expect('000r000'.toColor(), null);
    expect('#FFF'.toColor(), Colors.white);
    expect('FFF'.toColor(), Colors.white);
  });
}
