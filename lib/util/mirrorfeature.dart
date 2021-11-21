/*
  @author AKBAR <akbar.attijani@gmail.com>
 */

import 'package:reflectable/reflectable.dart';

class MirrorFeature {
  static bool isParameterPresent(ParameterMirror declaration, Type annotation) {
    for (var instance in declaration.metadata) {
      if (instance.runtimeType == annotation) {
        return true;
      }
    }

    return false;
  }

  static bool isAnnotationPresent(DeclarationMirror declaration, Type annotation) {
    for (var instance in declaration.metadata) {
      if (instance.runtimeType == annotation) {
        return true;
      }
    }

    return false;
  }

  static dynamic getAnnotation(DeclarationMirror declaration, Type annotation) {
    for (var instance in declaration.metadata) {
      if (instance.runtimeType == annotation) {
        return instance;
      }
    }

    return null;
  }

  static dynamic getParameter(ParameterMirror declaration, Type annotation) {
    for (var instance in declaration.metadata) {
      if (instance.runtimeType == annotation) {
        return instance;
      }
    }

    return null;
  }

  static List<dynamic>? getAnnotations(DeclarationMirror declaration, Type annotation) {
    var result = [];
    for (var instance in declaration.metadata) {
      if (instance.runtimeType == annotation) {
        result.add(instance);
      }
    }

    return result;
  }

  static List<dynamic>? getVariables(VariableMirror declaration, Type annotation) {
    var result = [];
    for (var instance in declaration.metadata) {
      if (instance.runtimeType == annotation) {
        result.add(instance);
      }
    }

    return result;
  }

  static Object? getTypeAnnotation(TypeMirror declaration, Type annotation) {
    for (var instance in declaration.metadata) {
      if (instance.runtimeType == annotation) {
        return instance;
      }
    }

    return null;
  }
}