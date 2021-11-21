/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

import 'package:flutter/cupertino.dart';
import 'package:reflectable/reflectable.dart';

const SetupEntity = BaseEntity();

class BaseEntity extends Reflectable {
  const BaseEntity() : super(invokingCapability,
                            superclassQuantifyCapability,
                            declarationsCapability,
                            typeRelationsCapability,
                            metadataCapability,
                            newInstanceCapability,
                            instanceInvokeCapability,
                            typeCapability);

  dynamic toModel(Map<String, dynamic> data) {
    debugPrint('Persistance Type not contains function => toModel. Please extends to BaseEntity and add override "toModel"');
  }
}