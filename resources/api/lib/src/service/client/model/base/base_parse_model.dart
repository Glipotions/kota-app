import 'dart:convert';
import 'dart:isolate';

/// An abstract base class for models with JSON serialization/deserialization capabilities.
abstract class IBaseModel<T> {
  /// Converts a JSON map to an instance of the model.
  T fromJson(Map<String, dynamic> json);

  /// Converts the model instance to a JSON map.
  Map<String, dynamic> toJson();

  /// Parses a JSON string into the corresponding model or list of models.
  dynamic jsonParser(String jsonBody) {
    assert(
      T.toString() != 'dynamic',
      'Model should be extended from IBaseModel',
    );
    final newJson = json.decode(jsonBody);
    if (newJson is List) {
      
      return newJson.map<T>((e) => fromJson(e as Map<String,dynamic>)).toList();

    } else if (newJson is Map<String, dynamic>) {
      return fromJson(newJson);
    } else {
      return newJson;
    }
  }

  /// Parses a JSON string in the background using an isolate.
  Future<dynamic> backgroundJsonParser(String jsonBody) async {
    final port = ReceivePort('BaseParseModel');
    await Isolate.spawn(
      _backgroundJsonParser,
      {'port': port.sendPort, 'body': jsonBody},
      onError: port.sendPort,
    );
    return  port.first;
  }

  /// The background isolate function for JSON parsing.
  void _backgroundJsonParser(Map<String, dynamic> map) {
    final port = map['port'] as SendPort?;
    Isolate.exit(port, jsonParser(map['body'] as String));
  }

  /// Converts the model instance or list of models to a JSON string.
  String convertToJson([dynamic model]) {
    if (model == null) {
      return json.encode(toJson());
    }

    assert(model is T || model is List<T>,'Model should be T');

    if (model is List) {
      final list = List<Map<String, dynamic>>.from(
        model.map(
          (e) => (e as IBaseModel<T>).toJson(),
        ),
      );
      return json.encode(list);
    } else {
      return json.encode((model as IBaseModel).toJson());
    }
  }

  /// Converts the model instance or list of models to a JSON string 
  /// in the background using an isolate.
  Future<String> backgroundConvertToJson([List<T>? model]) async {
    final port = ReceivePort('BaseParseModel');
    await Isolate.spawn<Map<String,dynamic>>(
      _backgroundConvertToJson,
      {'port': port.sendPort, 'model': model},
      onError: port.sendPort,
    );
    return await port.first as String;
  }

  /// The background isolate function for JSON conversion.
  void _backgroundConvertToJson(Map<String, dynamic> map) {
    final port = map['port'] as SendPort?;
    final model = map['model'];
    Isolate.exit(port, convertToJson(model));
  }
}
