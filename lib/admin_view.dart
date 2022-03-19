import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_emonit/split_view.dart';

import 'page_menu.dart';

class AdminView extends ConsumerWidget {
  const AdminView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPageBuilder = ref.watch(selectedPageBuilderProvider);
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplitView(menu: const PageMenu(), content: selectedPageBuilder(context)),
    );
  }
}