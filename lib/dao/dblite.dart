/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

import 'dart:io';

import 'package:order_apps/util/mirrorfeature.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reflectable/reflectable.dart';
import 'package:sqflite/sqflite.dart';

import 'annotation/Table.dart';
import 'annotation/attribute.dart';
import 'annotation/reference.dart';
import 'baseentity.dart';

class DBLite {
  static Database? _database;
  List<dynamic> tableList = [];

  DBLite tables(List<dynamic> list) {
    tableList = list;
    return this;
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    // if _database is null we instantiate it
    _database = await _createTables(tableList);
    return _database!;
  }

  _createTables(List<dynamic> persistanceClassList) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = '${documentsDirectory.path}/ottocash.db';
    return await openDatabase(path, version: 2, onOpen: (db) {
    }, onCreate: (Database db, int version) async {

        for (dynamic table in persistanceClassList) {
          String query = "CREATE TABLE ";
          String reference = "";

          ClassMirror classMirror = SetupEntity.reflectType(table) as ClassMirror;
          Table tableAnnotate;
          for (var t in classMirror.metadata) {
            if (t.runtimeType == Table) {
              tableAnnotate = t as Table;
              query += tableAnnotate.tableName;
              query += " (";
            }
          }

          for (var v in classMirror.declarations.values) {
            if (v is VariableMirror) {
              List<dynamic>? attributes = MirrorFeature.getVariables(v, Attribute);

              // add attributes name to query create
              for (Attribute attribute in attributes!) {
                print('attribute : ${attribute.name}');
                String notNull = attribute.notNull ? "NOT NULL " : " ";
                String primaryKey = attribute.primaryKey ? "PRIMARY KEY " : " ";
                String autoIncrement = attribute.autoIncrements ? "AUTOINCREMENT" : " ";
                String defaultValue = attribute.defaultValue;
                String typeString = primaryKey == " " ? attribute.type + "(" + attribute.length.toString() + ") " : attribute.type + " ";

                if (defaultValue != "") {
                  defaultValue = "DEFAULT '$defaultValue' ";
                } else {
                  defaultValue = "";
                }

                query += attribute.name;
                query += " ";
                query += typeString;
                query += notNull;
                query += defaultValue;
                query += primaryKey;
                query += autoIncrement;

                query += ",";
              }

              if (MirrorFeature.isAnnotationPresent(v, Reference)) {
                Reference referenceAnnotate = MirrorFeature.getAnnotation(v, Reference);

                try {
                  ClassMirror classMirror = SetupEntity.reflectType(referenceAnnotate.tableReference) as ClassMirror;
                  for (var tf in classMirror.declarations.values) {
                    if (tf is TypeMirror) {
                      Table tableReference = MirrorFeature.getAnnotation(tf, Table);

                      reference += ", FOREIGN KEY(";
                      reference += referenceAnnotate.fieldName;
                      reference += ") REFERENCES ";
                      reference += tableReference.tableName;
                      reference += ")";
                      reference += referenceAnnotate.referenceName;
                      reference += ")";
                    }
                  }
                } on Exception catch(e, stacktrace) {
                  print(stacktrace);
                }
              }
            }
          }

          query = query.substring(0, query.length - 1) + ") ";
          query += reference;
          print('query create => $query');

          await db.execute(query);
        }
    });
  }
}

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
}