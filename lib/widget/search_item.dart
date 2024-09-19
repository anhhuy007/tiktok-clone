import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/presentation/search/models/searching_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tiktok_clone/core/utils/navigator_services.dart';
import 'package:tiktok_clone/presentation/search/notifiers/onfocus_search_notifier.dart';
import 'package:tiktok_clone/presentation/search/notifiers/search_notifier.dart';
import 'package:tiktok_clone/route/app_routes.dart';
import 'package:tiktok_clone/presentation/profile/profile_page/notifiers/profile_notifier.dart';
import 'package:tiktok_clone/presentation/profile/profile_page_container/notifiers/profile_page_container_notifier.dart';
import 'package:tiktok_clone/presentation/authentication/notifiers/auth_notifier.dart';

Widget UserSearchItemWidget(SearchItem item, WidgetRef ref, bool canRemove) {
  return ListTile(
    onTap: () {
      if (!canRemove) {
        String query = ref.read(searchPageProvider).value!.searchController.text;
        ref.read(onFocusSearchProvider.notifier).insertSearchHistoryItem(
            query, item.userId ?? 0
        );
      }
      _navigateToProfilePage(ref, item.userId ?? 0);
    },
    leading: CircleAvatar(
      radius: 25,
      backgroundColor: Colors.grey[200],
      backgroundImage: item.avatarUrl != null
          ? CachedNetworkImageProvider(item.avatarUrl!)
          : null,
      child: item.avatarUrl == null
          ? Icon(Icons.person, color: Colors.grey[400])
          : null,
    ),
    subtitle: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.name ?? 'Unknown',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        if (item.handle != null)
          Text(
            '${item.handle}',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        const SizedBox(width: 10),
        if (item.followers != null)
          Text(
            '${_formatFollowers(item.followers!)} followers',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          )
      ],
    ),
    trailing: canRemove
        ? IconButton(
            icon: const Icon(Icons.highlight_remove, color: Colors.grey),
            onPressed: () {
              ref.read(onFocusSearchProvider.notifier).deleteSearchHistoryItem(
                  item.id ?? 0
              );
            },
          )
        : null,
  );
}

Widget QuerySearchItemWidget(String query, WidgetRef ref) {
  return ListTile(
    onTap: () {},
    leading: const Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Icon(
        Icons.search,
        color: Colors.grey,
        size: 30,
      ),
    ),
    title: Text(
      query,
      style: const TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 16,
        color: Colors.grey,
      ),
    ),
    trailing: IconButton(
      icon: const Icon(Icons.highlight_remove, color: Colors.grey),
      onPressed: () {},
    ),
  );
}

void _navigateToProfilePage(WidgetRef ref, int profileId) {
  ref.read(profilePageContainerNotifier.notifier).updateState(
        profileId: profileId,
        userId: ref.read(authProvider).user!.id,
      );
  ref.read(profileNotifier.notifier).fetchPopularVideos(userId: profileId);
  NavigatorService.pushNamed(AppRoutes.profilePage);
}

String _formatFollowers(int followers) {
  if (followers >= 1000000) {
    return '${(followers / 1000000).toStringAsFixed(1)}M';
  } else if (followers >= 1000) {
    return '${(followers / 1000).toStringAsFixed(1)}K';
  } else {
    return followers.toString();
  }
}
