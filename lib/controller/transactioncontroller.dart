/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:order_apps/components/customdialog.dart';
import 'package:order_apps/components/listener/customdialoglistener.dart';
import 'package:order_apps/dao/impl/orderimpl.dart';
import 'package:order_apps/dao/table/order.dart';
import 'package:order_apps/ui/transaction.dart';

abstract class TransactionController extends State<Transaction> with CustomDialogListener {

  Future<void> save(BuildContext context, String name, String quantity) async {
    Order order = Order();
    order.name = name;
    order.quantity = int.parse(quantity);

    // save Order
    int result = await OrderImpl().save(order);
    if (result > 0) {
      createDialog(context, "Pesan", "Pesanan Berhasil Dibuat", Dialogs.YES_OPTION);
    } else {
      createDialog(context, "Kesalahan", "Pesanan Gagal Dibuat", Dialogs.YES_OPTION);
    }
  }

  void createDialog(BuildContext context,  String title, String message, Dialogs type) {
    CustomDialog customDialog = CustomDialog(context, type);
    customDialog
        .listener(this)
        .title(title)
        .message(message)
        .show();
  }

  @override
  Future<void> onOk(BuildContext context, int id, List packet) async {
    Navigator.pop(context, true);
  }
}