/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:order_apps/dao/impl/orderimpl.dart';
import 'package:order_apps/dao/table/order.dart';
import 'package:order_apps/ui/dashboard.dart';
import 'package:order_apps/ui/transaction.dart';

abstract class DashboardController extends State<Dashboard> {

  List<Order> orderList = [];

  Future<List<Order>> orderListFuture() async {
    orderList = await OrderImpl().getAll();
    return orderList;
  }

  void addOrder(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Transaction())
    ).then((value) {
      if (value != null && value as bool) {
        setState(() {
          //Nothing
        });
      }
    });
  }
}