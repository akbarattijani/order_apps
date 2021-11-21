/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

import 'package:flutter/cupertino.dart';

class DaoInterface {
  Future<int> save(dynamic object) async {
    debugPrint('save execute to table');
    return -1;
  }

  List<dynamic>? select(dynamic persistance, String arguments, List<String> parameters) {
    debugPrint('select execute to table');
    return null;
  }

  Future<int> delete(String arguments, List<String> parameters) async {
    debugPrint('delete execute to table');
    return -1;
  }
}