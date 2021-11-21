/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:order_apps/controller/transactioncontroller.dart';

class Transaction extends StatefulWidget {
  Transaction({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TransactionState();
}

class TransactionState extends TransactionController {
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();

  TransactionState({Key? key});

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          elevation: 4,
          title: const Text(
            "Tambah Pesanan",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          )
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const Text(
              'Nama Produk',
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.black38, fontSize: 13),
            ),
            Container(
                decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.blueAccent))
                ),
                child: TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                )
            ),
            const SizedBox(height: 20),
            const Text(
              'Jumlah',
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.black38, fontSize: 13),
            ),
            Container(
                decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.blueAccent))
                ),
                child: TextFormField(
                  controller: _quantityController,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.number,
                )
            ),
            const SizedBox(height: 20),
            RaisedButton(
              color: Colors.blueAccent,
              elevation: 4,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text('Pesan', style: TextStyle(color: Colors.white),),
              ),
              onPressed: () async {
                save(context, _nameController.text, _quantityController.text);
              },
            )
          ],
        ),
      ),
    );
  }
}