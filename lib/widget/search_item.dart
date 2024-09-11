import 'package:flutter/material.dart';
import 'package:tiktok_clone/presentation/search/models/searching_item.dart';
import 'package:cached_network_image/cached_network_image.dart';

Widget searchItemWidget(SearchItem item) {
  return ListTile(
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
    title: Text(
      item.name ?? 'Unknown',
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
    subtitle: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (item.handle != null)
          Text(
            '${item.handle}',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        if (item.followers != null)
          Text(
            '${_formatFollowers(item.followers!)} followers',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
      ],
    ),
    trailing: ElevatedButton(
      onPressed: () {
        // TODO: Implement follow functionality
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: const Text('Follow'),
    ),
  );
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