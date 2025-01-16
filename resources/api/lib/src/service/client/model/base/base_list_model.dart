import 'dart:convert';

class BaseListModel<T> {

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
    final entity = fromJson(item);

    return BaseListModel(
      entity: entity,
    );
  }

  factory BaseListModel.fromJsonList(
      String json, T Function(Map<String, dynamic>) fromJson) {
    final jsonData = jsonDecode(json);
    final items = jsonData['items'] as List<dynamic>;
    final data = items.map((itemJson) => fromJson(itemJson)).toList();
    final index = jsonData['index'] as int;
    final size = jsonData['size'] as int;
    final hasNext = jsonData['hasNext'] as bool;
    final pages = jsonData['pages'] as int;

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
  final List<T>? data;
  // final BaseModelStatus status;
  // final String? message;
  final int? count;
  final int? index;
  final int? size;
  final int? pages;
  final bool? hasNext;
  final T? entity;
}

// enum BaseModelStatus {
//   Ok,
//   NotFound,
//   Error,
//   // Diğer durumlar da eklenebilir
// }