// Author: Birju Vachhani
// Created Date: October 01, 2020

import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('TextEditingController tests', () {
    final controller = TextEditingController();
    expect(controller.isBlank, isTrue);
    expect(controller.isNotBlank, isFalse);
    controller.text = '     ';
    expect(controller.isBlank, isTrue);
    expect(controller.isNotBlank, isFalse);
    controller.text = 'Hello';
    expect(controller.isBlank, isFalse);
    expect(controller.isNotBlank, isTrue);
  });
}
