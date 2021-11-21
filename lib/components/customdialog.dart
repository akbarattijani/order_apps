import 'package:flutter/material.dart';
import 'listener/customdialoglistener.dart';

/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

String _title = 'Pesan';
String _message = 'Pesan';

enum Dialogs { YES_OPTION, YES_NO_OPTION, ONLY_ALERT }
Dialogs _dialogType = Dialogs.YES_OPTION;
bool _isShowing = false;
CustomDialogListener? _listener;

class CustomDialog {
  _MyDialog? _dialog;
  BuildContext? _buildContext, _context;
  int _id = -111111;
  List<dynamic> packetList = [];


  CustomDialog(BuildContext context, Dialogs type) {
    _buildContext = context;
    _dialogType = type;
  }

  CustomDialog packet(List<dynamic> packetList) {
    this.packetList = packetList;
    return this;
  }

  CustomDialog id(int id) {
    _id = id;
    return this;
  }

  CustomDialog listener(CustomDialogListener listener) {
    _listener = listener;
    return this;
  }

  CustomDialog title(String title) {
    _title = title;
    return this;
  }

  CustomDialog message(String message) {
    _message = message;
    return this;
  }

  bool isShowing() {
    return _isShowing;
  }

  void hide() {
    _isShowing = false;
    Navigator.of(_context!).pop();
    debugPrint('CustomDialog dismissed');
  }

  void show() {
    _dialog = _MyDialog(
      id: _id,
      dialog: this,
      packetList: packetList,
    );

    _isShowing = true;
    debugPrint('CustomDialog shown');
    showDialog<dynamic>(
      context: _buildContext!,
      builder: (BuildContext context) {
        _context = context;
        return _dialog!;
      },
    );
  }
}

// ignore: must_be_immutable
class _MyDialog extends StatefulWidget {
  int id;
  CustomDialog dialog;
  List<dynamic> packetList;

  _MyDialog({Key? key, required this.id, required this.dialog, required this.packetList}) : super(key: key);

  var _dialog;

  update() {
    _dialog.changeState();
  }

  @override
  State<StatefulWidget> createState() {
    _dialog = _MyDialogState(
        id: id,
        dialog: dialog,
        packetList: packetList
    );
    return _dialog;
  }
}

class _MyDialogState extends State<_MyDialog> {
  int id;
  CustomDialog dialog;
  List<dynamic> packetList;

  _MyDialogState({Key? key, required this.id, required this.dialog, required this.packetList});

  changeState() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _isShowing = false;
    debugPrint('CustomDialog dismissed by back button');
  }

  @override
  Widget build(BuildContext context) {
    if (_dialogType == Dialogs.YES_OPTION) {
      return AlertDialog(
        title: Text(_title),
        content: Text(_message),
        actions: <Widget>[
          FlatButton(
            child: const Text("Yes", style: TextStyle(color: Colors.blueAccent)),
            onPressed: () {
              dialog.hide();
              _listener!.onOk(context, id, packetList);
            },
          )
        ],
      );
    } else if (_dialogType == Dialogs.YES_NO_OPTION) {
      return AlertDialog(
        title: Text(_title),
        content: Text(_message),
        actions: <Widget>[
          FlatButton(
            child: const Text("No", style: TextStyle(color: Colors.blueAccent)),
            onPressed: () {
              dialog.hide();
              _listener!.onCancel(context, id, packetList);
            },
          ),
          FlatButton(
            child: const Text("Yes", style: TextStyle(color: Colors.blueAccent)),
            onPressed: () {
              dialog.hide();
              _listener!.onOk(context, id, packetList);
            },
          ),
        ],
      );
    } else {
      return AlertDialog(
        title: Text(_title),
        content: Text(_message)
      );
    }
  }
}