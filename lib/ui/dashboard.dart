import 'package:flutter/material.dart';
import 'package:order_apps/controller/dashboardcontroller.dart';
import 'package:order_apps/dao/table/order.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

class Dashboard extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => DashboardState();
}

class DashboardState extends DashboardController {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
            elevation: 4,
            title: const Text(
              "Daftar Pesanan",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            )
        ),
      ),
      body: FutureBuilder<List<Order>>(
        future: orderListFuture(),
        builder: (BuildContext context, AsyncSnapshot<List<Order>> snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.requireData.length,
                  itemBuilder: (context, index) {
                    return _generateOrderItem(context, snapshot.requireData[index]);
                  }
              ),
            );
          } else {
            return Container(color: Colors.white);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          addOrder(context);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _generateOrderItem(BuildContext context, Order order) {
    return Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.name,
                textAlign: TextAlign.left,
                style: const TextStyle(color: Colors.black, fontSize: 13)
              ),
              Text(
                  order.quantity.toString(),
                  textAlign: TextAlign.right,
                  style: const TextStyle(color: Colors.black, fontSize: 13)
              )
            ],
          ),
        )
    );
  }
}