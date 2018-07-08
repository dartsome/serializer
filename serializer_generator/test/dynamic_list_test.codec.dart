// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// SerializerGenerator
// **************************************************************************

library dynamic_list_test.codec;

import 'package:serializer/core.dart' show Serializer, cleanNullInMap;
import 'package:serializer/codecs.dart';
import 'dynamic_list_test.dart';

class DynamicListCodec extends TypeCodec<DynamicList> {
  @override
  DynamicList decode(dynamic value, {Serializer serializer}) {
    DynamicList obj = new DynamicList();
    List _list = serializer?.decode(value['list'], type: null);
    obj.list = _list ?? obj.list;
    return obj;
  }

  @override
  dynamic encode(DynamicList value,
      {Serializer serializer, bool useTypeInfo, bool withTypeInfo}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (serializer.enableTypeInfo(useTypeInfo, withTypeInfo)) {
      map[serializer.typeInfoKey] = typeInfo;
    }
    map['list'] = serializer?.toPrimaryObject(value.list,
        useTypeInfo: useTypeInfo, withTypeInfo: false);
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'DynamicList';
}

Map<String, TypeCodec<dynamic>> test_dynamic_list_test_codecs =
    <String, TypeCodec<dynamic>>{
  'DynamicList': new DynamicListCodec(),
};
