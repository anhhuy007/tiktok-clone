import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/presentation/search/notifiers/onfocus_search_notifier.dart';
import 'package:tiktok_clone/presentation/search/notifiers/search_notifier.dart';
import 'package:tiktok_clone/widget/search_item.dart';

class OnFocusSearchPage extends ConsumerWidget {
  final VoidCallback onClose;

  const OnFocusSearchPage({
    super.key,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(onFocusSearchProvider);

    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: onClose,
            child: const Text(
                'Close',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        Expanded(
          child: searchState.when(
            loading: () => const Center(child: CircularProgressIndicator(color: Colors.white,)),
            error: (error, stackTrace) => Center(child: Text('Error: $error $stackTrace')),
            data: (data) =>
                ref.watch(searchPageProvider).value?.searchController.text != ''
                    ? data.searchItems == null
                        ? const Center(child: Text("No result"))
                        : ListView.builder(
                            itemCount: data.searchItems?.length ?? 0,
                            itemBuilder: (context, index) {
                              final item = data.searchItems![index];
                              return UserSearchItemWidget(item, ref, false);
                            },
                          )
                    : ListView.builder(
                        itemCount: data.searchedItems?.length,
                        itemBuilder: (context, index) {
                          final searchItem = data.searchedItems?[index];
                          return searchItem?.name != null
                              ? UserSearchItemWidget(searchItem!, ref, true)
                              : QuerySearchItemWidget(
                                  searchItem!, ref, true);
                        },
                      ),
          ),
        ),
      ],
    );
  }
}
