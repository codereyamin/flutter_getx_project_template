import 'dart:developer';

import 'package:flutter/material.dart';

void appInPutUnfocused() {
  try {
    FocusManager.instance.primaryFocus?.unfocus();
  } catch (e) {
    log("error form app unfocused");
  }
}
