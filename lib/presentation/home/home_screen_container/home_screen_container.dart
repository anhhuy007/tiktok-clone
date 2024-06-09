import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreenContainer extends ConsumerStatefulWidget {
  const HomeScreenContainer({Key? key}) : super(key: key);

  @override
  _HomeScreenContainerState createState() => _HomeScreenContainerState();
}

class _HomeScreenContainerState extends ConsumerState<HomeScreenContainer> {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Navigator(
        key: navigatorKey,
      )
    );
  }
}