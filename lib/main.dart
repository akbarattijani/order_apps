import 'package:flutter/material.dart';
import 'package:order_apps/dao/table/order.dart';
import 'package:order_apps/ui/dashboard.dart';

import 'components/loadingpage.dart';
import 'dao/dblite.dart';
import 'main.reflectable.dart';

void main() {
  initializeReflectable();
  runApp(OrderMain());
}

class OrderMain extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _OrderMainState();
}

class _OrderMainState extends State<OrderMain> {
  GlobalKey _keyHasData = GlobalKey();
  GlobalKey _keyLoading = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Future<int> _orderFuture() async {
      await DBLite()
          .tables([Order])
          .database;

      return 1;
    }

    return FutureBuilder<int>(
      future: _orderFuture(),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        if (snapshot.hasData) {
          return MaterialApp(
            key: _keyHasData,
            title: 'Aplikasi Pesanan',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                primaryColor: Colors.white
            ),
            initialRoute: '/',
            routes: {
              '/': (context) => Dashboard()
            },
          );
        } else {
          return MaterialApp(
            key: _keyLoading,
            title: 'Aplikasi Pesanan',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                primaryColor: Colors.white
            ),
            initialRoute: '/loadingData',
            routes: {
              '/loadingData': (context) => LoadingPage()
            },
          );
        }
      },
    );
  }
}