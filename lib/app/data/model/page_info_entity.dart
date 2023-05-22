import 'package:heyya/app/core/enum/verify_state.dart';
import 'package:heyya/generated/json/base/json_convert_content.dart';
import 'package:heyya/generated/json/base/json_field.dart';
import 'package:heyya/generated/json/page_info_entity.g.dart';
import 'dart:convert';

class PageInfoRequest {
  final int number;
  final int size;
  final String? userId;
  final VerifyState? verifyState;
  final String? city;
  final String? country;
  final int? distance;
  final double? lat;
  final double? lon;
  final String? province;
  final List<int>? passUserIds;
  const PageInfoRequest({
    this.number = 1,
    this.size = 20,
    this.userId,
    this.verifyState,
    this.city,
    this.country,
    this.distance,
    this.lat,
    this.lon,
    this.province,
    this.passUserIds,
  });
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['number'] = number;
    data['size'] = size;
    // data['userId'] = userId;
    // data['verifyState'] = verifyStateEnumMap[verifyState];
    // data['city'] = city;
    // data['country'] = country;
    // data['distance'] = distance;
    // data['lat'] = lat;
    // data['lon'] = lon;
    // data['province'] = province;
    // data['passUserIds'] = passUserIds;

    if (userId != null) {
      data['userId'] = userId;
    }
    if (verifyState != null) {
      data['verifyState'] = verifyStateEnumMap[verifyState];
    }
    if (city != null) {
      data['city'] = city;
    }
    if (country != null) {
      data['country'] = country;
    }
    if (distance != null) {
      data['distance'] = distance;
    }
    if (lat != null) {
      data['lat'] = lat;
    }
    if (lon != null) {
      data['lon'] = lon;
    }
    if (province != null) {
      data['province'] = province;
    }
    if (passUserIds != null) {
      data['passUserIds'] = passUserIds;
    }
    return data;
  }
}

@JsonSerializable()
class PageInfoEntity<T> {
  late int endRow;
  late bool hasNextPage;
  late bool hasPreviousPage;
  late bool isFirstPage;
  late bool isLastPage;
  @JSONField(deserialize: false)
  late List<T> list;
  late int navigateFirstPage;
  late int navigateLastPage;
  late int navigatePages;
  late List<int> navigatepageNums;
  late int nextPage;
  late int pageNum;
  late int pageSize;
  late int pages;
  late int prePage;
  late int size;
  late int startRow;
  late int total;

  PageInfoEntity();

  factory PageInfoEntity.fromJson(Map<String, dynamic> json) {
    final pageInfoEntity = PageInfoEntity<T>();
    final int? endRow = jsonConvert.convert<int>(json['endRow']);
    if (endRow != null) {
      pageInfoEntity.endRow = endRow;
    }
    final bool? hasNextPage = jsonConvert.convert<bool>(json['hasNextPage']);
    if (hasNextPage != null) {
      pageInfoEntity.hasNextPage = hasNextPage;
    }
    final bool? hasPreviousPage =
        jsonConvert.convert<bool>(json['hasPreviousPage']);
    if (hasPreviousPage != null) {
      pageInfoEntity.hasPreviousPage = hasPreviousPage;
    }
    final bool? isFirstPage = jsonConvert.convert<bool>(json['isFirstPage']);
    if (isFirstPage != null) {
      pageInfoEntity.isFirstPage = isFirstPage;
    }
    final bool? isLastPage = jsonConvert.convert<bool>(json['isLastPage']);
    if (isLastPage != null) {
      pageInfoEntity.isLastPage = isLastPage;
    }
    final int? navigateFirstPage =
        jsonConvert.convert<int>(json['navigateFirstPage']);
    if (navigateFirstPage != null) {
      pageInfoEntity.navigateFirstPage = navigateFirstPage;
    }
    final int? navigateLastPage =
        jsonConvert.convert<int>(json['navigateLastPage']);
    if (navigateLastPage != null) {
      pageInfoEntity.navigateLastPage = navigateLastPage;
    }
    final int? navigatePages = jsonConvert.convert<int>(json['navigatePages']);
    if (navigatePages != null) {
      pageInfoEntity.navigatePages = navigatePages;
    }
    final List<int>? navigatepageNums =
        jsonConvert.convertListNotNull<int>(json['navigatepageNums']);
    if (navigatepageNums != null) {
      pageInfoEntity.navigatepageNums = navigatepageNums;
    }
    final int? nextPage = jsonConvert.convert<int>(json['nextPage']);
    if (nextPage != null) {
      pageInfoEntity.nextPage = nextPage;
    }
    final int? pageNum = jsonConvert.convert<int>(json['pageNum']);
    if (pageNum != null) {
      pageInfoEntity.pageNum = pageNum;
    }
    final int? pageSize = jsonConvert.convert<int>(json['pageSize']);
    if (pageSize != null) {
      pageInfoEntity.pageSize = pageSize;
    }
    final int? pages = jsonConvert.convert<int>(json['pages']);
    if (pages != null) {
      pageInfoEntity.pages = pages;
    }
    final int? prePage = jsonConvert.convert<int>(json['prePage']);
    if (prePage != null) {
      pageInfoEntity.prePage = prePage;
    }
    final int? size = jsonConvert.convert<int>(json['size']);
    if (size != null) {
      pageInfoEntity.size = size;
    }
    final int? startRow = jsonConvert.convert<int>(json['startRow']);
    if (startRow != null) {
      pageInfoEntity.startRow = startRow;
    }
    final int? total = jsonConvert.convert<int>(json['total']);
    if (total != null) {
      pageInfoEntity.total = total;
    }
    pageInfoEntity.list = JsonConvert.fromJsonAsT<List<T>>(json['list']) ?? [];
    return pageInfoEntity;
  }

  Map<String, dynamic> toJson() => $PageInfoEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
