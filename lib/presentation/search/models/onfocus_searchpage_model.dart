import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/presentation/search/models/searching_item.dart';

class OnFocusSearchPageModel {
  final List<SearchItem>? searchItems;

  OnFocusSearchPageModel({
    required this.searchItems,
  });

  OnFocusSearchPageModel copyWith({
    List<SearchItem>? searchItems,
  }) {
    return OnFocusSearchPageModel(
      searchItems: searchItems ?? this.searchItems,
    );
  }
}