import 'package:heyya/generated/json/base/json_convert_content.dart';
import 'package:heyya/app/data/model/page_info_entity.dart';

PageInfoEntity $PageInfoEntityFromJson(Map<String, dynamic> json) {
	final PageInfoEntity pageInfoEntity = PageInfoEntity();
	final int? endRow = jsonConvert.convert<int>(json['endRow']);
	if (endRow != null) {
		pageInfoEntity.endRow = endRow;
	}
	final bool? hasNextPage = jsonConvert.convert<bool>(json['hasNextPage']);
	if (hasNextPage != null) {
		pageInfoEntity.hasNextPage = hasNextPage;
	}
	final bool? hasPreviousPage = jsonConvert.convert<bool>(json['hasPreviousPage']);
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
	final int? navigateFirstPage = jsonConvert.convert<int>(json['navigateFirstPage']);
	if (navigateFirstPage != null) {
		pageInfoEntity.navigateFirstPage = navigateFirstPage;
	}
	final int? navigateLastPage = jsonConvert.convert<int>(json['navigateLastPage']);
	if (navigateLastPage != null) {
		pageInfoEntity.navigateLastPage = navigateLastPage;
	}
	final int? navigatePages = jsonConvert.convert<int>(json['navigatePages']);
	if (navigatePages != null) {
		pageInfoEntity.navigatePages = navigatePages;
	}
	final List<int>? navigatepageNums = jsonConvert.convertListNotNull<int>(json['navigatepageNums']);
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
	return pageInfoEntity;
}

Map<String, dynamic> $PageInfoEntityToJson(PageInfoEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['endRow'] = entity.endRow;
	data['hasNextPage'] = entity.hasNextPage;
	data['hasPreviousPage'] = entity.hasPreviousPage;
	data['isFirstPage'] = entity.isFirstPage;
	data['isLastPage'] = entity.isLastPage;
	data['list'] =  entity.list.map((v) => v.toJson()).toList();
	data['navigateFirstPage'] = entity.navigateFirstPage;
	data['navigateLastPage'] = entity.navigateLastPage;
	data['navigatePages'] = entity.navigatePages;
	data['navigatepageNums'] =  entity.navigatepageNums;
	data['nextPage'] = entity.nextPage;
	data['pageNum'] = entity.pageNum;
	data['pageSize'] = entity.pageSize;
	data['pages'] = entity.pages;
	data['prePage'] = entity.prePage;
	data['size'] = entity.size;
	data['startRow'] = entity.startRow;
	data['total'] = entity.total;
	return data;
}