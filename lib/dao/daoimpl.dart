/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

import 'package:order_apps/util/mirrorfeature.dart';
import 'package:reflectable/reflectable.dart';

import 'annotation/Table.dart';
import 'annotation/attribute.dart';
import 'baseentity.dart';
import 'daointerface.dart';
import 'dblite.dart';

abstract class DaoImpl<T> implements DaoInterface {
  String? tableName;
  static final List<String> formats = [
      "yyyy-MM-dd",
      "dd-MM-yyyy",
      "yyyy-MM-dd'T'HH:mm:ss'Z'",
      "yyyy-MM-dd'T'HH:mm:ssZ",
      "yyyy-MM-dd'T'HH:mm:ss",
      "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
      "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
      "yyyy-MM-dd HH:mm:ss",
      "MM/dd/yyyy HH:mm:ss",
      "MM/dd/yyyy'T'HH:mm:ss.SSS'Z'",
      "MM/dd/yyyy'T'HH:mm:ss.SSSZ",
      "MM/dd/yyyy'T'HH:mm:ss.SSS",
      "MM/dd/yyyy'T'HH:mm:ssZ",
      "MM/dd/yyyy'T'HH:mm:ss",
      "yyyy:MM:dd HH:mm:ss",
      "yyyyMMdd",
      "ddMMyyyy"
  ];

  DaoImpl(dao) {
    try {
      ClassMirror classMirror = SetupEntity.reflectType(dao) as ClassMirror;
      classMirror.metadata.forEach((table) {
        if (table.runtimeType == Table) {
          Table t = table as Table;
          tableName = t.tableName;
        }
      });
    } on Exception catch(e, stacktrace) {
      print(stacktrace);
    }
  }

  @override
  Future<int> delete(String arguments, List<dynamic> parameters) async {
    String delete = "DELETE FROM $tableName WHERE ";

    for (int i = 0; i < parameters.length; i++) {
      dynamic parameter = parameters[i];

      if (parameter.runtimeType == String) {
        arguments = arguments.replaceFirst("?", "'${parameter.toString()}'");
      } else if (parameter.runtimeType == int || parameter.runtimeType == double) {
        arguments = arguments.replaceFirst("?", "${parameter.toString()}");
      } else {
        throw new Exception("Parameter not valid. Apply only String, Integer, or Double");
      }
    }

    delete += arguments;
    print("DELETE QUERY : " + delete);

    final db = await DBLite().database;
    var deleteResult = await db.rawDelete(delete);

    return deleteResult;
  }

  @override
  Future<int> save(object) async {
    String primaryKey = "";
    String autoIncrement = "";
    bool autoIncrementBool = false;
    dynamic dataType = null;

    Map<String, dynamic> column = new Map();
    try {
      InstanceMirror instanceMirror = SetupEntity.reflect(object);
      for (var v in instanceMirror.type.declarations.values) {
        if (v is VariableMirror) {
          if (MirrorFeature.isAnnotationPresent(v, Attribute)) {
            Attribute attribute = MirrorFeature.getAnnotation(v, Attribute);

            String fieldName = attribute.name;
            if (fieldName.contains("_")) {
              List<String> fn = fieldName.split("_");

              fieldName = "";
              for (int i = 0; i < fn.length; i++) {
                if (i == 0) {
                  fieldName += fn[i];
                } else {
                  fieldName += fn[i].substring(0, 1).toUpperCase() + fn[i].substring(1);
                }
              }
            }

            InstanceMirror instanceMirror = SetupEntity.reflect(object);
            dynamic fieldValue = instanceMirror.invokeGetter(fieldName);

            if (fieldValue == null) {
              column[attribute.name] = "";
            } else {
              column[attribute.name] = fieldValue;
            }

            if (attribute.primaryKey) {
              autoIncrementBool = attribute.autoIncrements;
              if (attribute.autoIncrements) {
                autoIncrement = attribute.name;
              }

              primaryKey = attribute.name;
              dataType = fieldValue.runtimeType;
            }
          }
        }
      }

      String select = "SELECT * FROM $tableName WHERE $primaryKey = ";
      if (dataType == String) {
        select += "'${column[primaryKey].toString()}'";
      } else if (dataType == int || dataType == double) {
        select += column[primaryKey].toString();
      } else {
        throw new Exception("Data Type not valid. Apply only String, Integer, or Double");
      }

      final db = await DBLite().database;
      var selectResult = await db.rawQuery(select);
      if (selectResult.isNotEmpty) {
        print("save() on Select -> $select => Exists");

        String update = "UPDATE $tableName SET ";
        for (String key in column.keys) {
          if (key != primaryKey) {
            update += "$key = '${column[key].toString()}',";
          }
        }

        update = update.substring(0, update.length - 1);
        update += " WHERE $primaryKey = '${column[primaryKey].toString()}'";

        print('save() on Update -> $update (Parameter = ${column[primaryKey].toString()})');
        var updateResult = await db.rawUpdate(update);

        return updateResult;
      } else {
        print("save() on Select -> $select => Dont Exists");

        String insert = "INSERT INTO $tableName (";
        String values = " VALUES (";

        for (String key in column.keys) {
          if (key == autoIncrement && autoIncrementBool) {
            continue;
          }

          insert += "$key,";
          if (column[key] is int || column[key] is double) {
            values += "${column[key]},";
          } else {
            values += "'${column[key].toString()}',";
          }
        }

        insert = insert.substring(0, insert.length - 1);
        values = values.substring(0, values.length - 1);

        values += ")";
        insert += ") $values";

        print('save() on Insert -> $insert');
        var insertResult = await db.rawInsert(insert);

        return insertResult;
      }
    } on Exception catch(e, stacktrace) {
      print(stacktrace);

      return -1;
    }
  }

  Future<T> _processingForModel(dynamic persistanceType, String query, List<dynamic> parameters) async {
    final db = await DBLite().database;

    try {
      for (int i = 0; i < parameters.length; i++) {
        dynamic parameter = parameters[i];

        if (parameter.runtimeType == String) {
          query = query.replaceFirst("?", "'${parameter.toString()}'");
        } else if (parameter.runtimeType == int || parameter.runtimeType == double) {
          query = query.replaceFirst("?", "${parameter.toString()}");
        } else {
          throw new Exception("Parameter not valid. Apply only String, Integer, or Double");
        }
      }

      InstanceMirror instanceMirror = SetupEntity.reflect(persistanceType);
      var selectResult = await db.rawQuery(query);
      Map<String, dynamic> arguments = new Map();

      if (selectResult.isNotEmpty) {
        Map<String, dynamic> data = selectResult[0];

        instanceMirror.type.declarations.values.forEach((v) {
          if (v is VariableMirror) {
            if (MirrorFeature.isAnnotationPresent(v, Attribute)) {
              Attribute attribute = MirrorFeature.getAnnotation(v, Attribute);

              String fieldName = attribute.name;
              if (fieldName.contains("_")) {
                List<String> fn = fieldName.split("_");

                fieldName = "";
                for (int i = 0; i < fn.length; i++) {
                  if (i == 0) {
                    fieldName += fn[i];
                  } else {
                    fieldName += fn[i].substring(0, 1).toUpperCase() + fn[i].substring(1);
                  }
                }
              }

              dynamic fieldValue = instanceMirror.invokeSetter(fieldName, data[attribute.name]);
              arguments[fieldName] = fieldValue;
            }
          }
        });

        persistanceType = instanceMirror.invoke("toModel", [arguments]);
      }
    } on Exception catch(e, stacktrace) {
      print(stacktrace);
    }

    return persistanceType;
  }

  Future<T> queryForModel(dynamic persistanceType, String query, List<dynamic> parameters) {
    if (T.toString() != persistanceType.runtimeType.toString()) {
      throw new Exception("T general (${T.toString()}) not same persistanceType (${persistanceType.runtimeType})");
    }

    return _processingForModel(persistanceType, query, parameters);
  }

  Future<List<T>> _processingForModels(dynamic persistanceType, String query, List<dynamic> parameters) async {
    List<T> result = [];
    final db = await DBLite().database;

    try {
      for (int i = 0; i < parameters.length; i++) {
        dynamic parameter = parameters[i];

        if (parameter.runtimeType == String) {
          query = query.replaceFirst("?", "'${parameter.toString()}'");
        } else if (parameter.runtimeType == int || parameter.runtimeType == double) {
          query = query.replaceFirst("?", "${parameter.toString()}");
        } else {
          throw new Exception("Parameter not valid. Apply only String, Integer, or Double");
        }
      }

      InstanceMirror instanceMirror = SetupEntity.reflect(persistanceType);
      var selectResult = await db.rawQuery(query);
      print('execute query : $query => $selectResult');

      if (selectResult.isNotEmpty) {
        for (Map<String, dynamic> data in selectResult) {
          Map<String, dynamic> arguments = {};

          for (var v in instanceMirror.type.declarations.values) {
            if (v is VariableMirror) {
              if (MirrorFeature.isAnnotationPresent(v, Attribute)) {
                Attribute attribute = MirrorFeature.getAnnotation(v, Attribute);

                String fieldName = attribute.name;
                if (fieldName.contains("_")) {
                  List<String> fn = fieldName.split("_");

                  fieldName = "";
                  for (int i = 0; i < fn.length; i++) {
                    if (i == 0) {
                      fieldName += fn[i];
                    } else {
                      fieldName += fn[i].substring(0, 1).toUpperCase() + fn[i].substring(1);
                    }
                  }
                }

                dynamic fieldValue = instanceMirror.invokeSetter(fieldName, data[attribute.name]);
                arguments[fieldName] = fieldValue;
              }
            }
          }

          result.add(instanceMirror.invoke("toModel", [arguments]) as T);
        }
      }
    } on Exception catch(e, stacktrace) {
      print(stacktrace);
    }

    return result;
  }

  Future<List<T>> queryForModels(dynamic persistanceType, String query, List<dynamic> parameters) async {
    if (T.toString() != persistanceType.runtimeType.toString()) {
      throw new Exception("T general (${T.toString()}) not same persistanceType (${persistanceType.runtimeType})");
    }

    return _processingForModels(persistanceType, query, parameters);
  }
}