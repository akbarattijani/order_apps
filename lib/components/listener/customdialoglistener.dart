/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

import 'package:flutter/material.dart';

class CustomDialogListener {
  void onOk(BuildContext context, int id, List<dynamic> packet) {
    print('Ok is touch');
  }

  void onCancel(BuildContext context, int id, List<dynamic> packet) {
    print('Cancel is touch');
  }
}