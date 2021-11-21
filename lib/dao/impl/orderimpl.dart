/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

import 'package:order_apps/dao/daoimpl.dart';
import 'package:order_apps/dao/table/order.dart';

class OrderImpl extends DaoImpl<Order> {

  OrderImpl() : super(Order);

  @override
  Future<int> save(object) {
    return super.save(object);
  }

  Future<List<Order>> getAll() {
    return queryForModels(Order(), "SELECT * FROM t_order", []);
  }

  @override
  List? select(persistance, String arguments, List<String> parameters) {
    // TODO: implement select
    throw UnimplementedError();
  }
}