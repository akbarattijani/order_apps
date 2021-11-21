/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

import 'package:order_apps/dao/annotation/Table.dart';
import 'package:order_apps/dao/annotation/attribute.dart';
import 'package:order_apps/dao/baseentity.dart';

@SetupEntity
@Table("t_order")
class Order extends BaseEntity {
  @Attribute("id", "INTEGER", 5, "-1", true, true, false)
  int id = -1;

  @Attribute("name", "VARCHAR", 50, "")
  String name = "";

  @Attribute("quantity", "INTEGER", 5, "0")
  int quantity = 0;

  @override
  toModel(Map<String, dynamic> data) {
    Order order = Order();
    order.id = data["id"];
    order.name = data["name"];
    order.quantity = data["quantity"];

    return order;
  }
}