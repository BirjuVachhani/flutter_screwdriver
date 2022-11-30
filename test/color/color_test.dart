// Author: Birju Vachhani
// Created Date: September 14, 2020

import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('color tests', () {
    expect(const Color(0xFFFF4433).toMaterialColor(), isA<MaterialColor>());
    expect(const Color(0xFFFF4433).toMaterialColor()[300],
        const Color(0xFFFF4433).shade(300));
    expect(const Color(0xFFFF4433).hexString.toLowerCase(), '#ff4433');
    expect(const Color(0xFFFF4433).tweenTo(const Color(0xFF454354)).begin,
        const Color(0xFFFF4433));
    expect(const Color(0xFFFF4433).tweenTo(const Color(0xFF454354)).end,
        const Color(0xFF454354));
    expect(const Color(0xFFFF4433).tweenFrom(const Color(0xFF454354)).begin,
        const Color(0xFF454354));
    expect(const Color(0xFFFF4433).tweenFrom(const Color(0xFF454354)).end,
        const Color(0xFFFF4433));
  });
}
