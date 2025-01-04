import 'dart:convert';

class BaseListModel<T> {
  final List<T>? data;
  // final BaseModelStatus status;
  // final String? message;
  final int? count;
  final int? index;
  final int? size;
  final int? pages;
  final bool? hasNext;
  final T? entity;

  BaseListModel({
    this.data,
    // required this.status,
    // this.message,
    this.count,
    this.index,
    this.size,
    this.pages,
    this.hasNext,
    this.entity,
  });

  factory BaseListModel.fromJsonEntity(
      String json, T Function(Map<String, dynamic>) fromJson) {
    final jsonData = jsonDecode(json);
    final item = jsonData as dynamic;
    var entity = fromJson(item);

    return BaseListModel(
      entity: entity,
    );
  }

  factory BaseListModel.fromJsonList(
      String json, T Function(Map<String, dynamic>) fromJson) {
    final jsonData = jsonDecode(json);
    final items = jsonData['items'] as List<dynamic>;
    var data = items.map((itemJson) => fromJson(itemJson)).toList();
    var index = jsonData['index'] as int;
    var size = jsonData['size'] as int;
    var hasNext = jsonData['hasNext'] as bool;
    var pages = jsonData['pages'] as int;

    return BaseListModel(
      data: data,
      // status: BaseModelStatus.fromJson(jsonData['status']),
      // message: jsonData['message'],
      hasNext: hasNext,
      index: index,
      size: size,
      pages: pages,
      count: jsonData['count'],
    );
  }
}

// enum BaseModelStatus {
//   Ok,
//   NotFound,
//   Error,
//   // Diğer durumlar da eklenebilir
// }