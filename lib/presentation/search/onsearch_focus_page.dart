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
            child: const Text('Close'),
          ),
        ),
        Expanded(
          child: searchState.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(child: Text('Error: $error')),
            data: (data) => data.searchItems == null ? const Center(child: Text("No result")) : ListView.builder(
              itemCount: data.searchItems?.length,
              itemBuilder: (context, index) {
                final userInfo = data.searchItems?[index];
                return searchItemWidget(userInfo!, ref);
              },
            ),
          ),
        ),
      ],
    );
  }
}