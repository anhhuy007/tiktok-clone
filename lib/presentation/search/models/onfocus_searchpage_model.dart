import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/presentation/search/models/searching_item.dart';

class OnFocusSearchPageModel {
  final List<SearchItem>? searchItems;
  final List<SearchItem>? searchedItems;

  OnFocusSearchPageModel({
    required this.searchItems,
    required this.searchedItems,
  });

  OnFocusSearchPageModel copyWith({
    List<SearchItem>? searchItems,
    List<SearchItem>? searchedItems,
  }) {
    return OnFocusSearchPageModel(
      searchItems: searchItems ?? this.searchItems,
      searchedItems: searchedItems ?? this.searchedItems,
    );
  }
}