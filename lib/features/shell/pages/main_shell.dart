import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tokenx/features/about/dev_members.dart';
import 'package:tokenx/features/home/helper_widgets/background_widgets.dart';
import 'package:tokenx/features/home/pages/home_page.dart';
import 'package:tokenx/features/notes/pages/notes_page.dart';
import 'package:tokenx/features/notes/providers/notes_providers.dart';

class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(selectedTabProvider);
    final title = ['Home', 'Notes', 'About'][selectedTab];
    final pages = [const HomePage(), const DevMembersPage(), const NotesPage()];

    return Stack(
      children: [
        const Positioned.fill(child: NetworkBackground()),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('TokenX • $title'),
            backgroundColor: const Color(0xAA0F0F1E).withOpacity(0.40),
            elevation: 0,
            actions: [
              TextButton(
                onPressed: () =>
                    ref.read(selectedTabProvider.notifier).state = 0,
                child: const Text(
                  'Home',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () =>
                    ref.read(selectedTabProvider.notifier).state = 2,
                child: const Text(
                  'Notes',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () =>
                    ref.read(selectedTabProvider.notifier).state = 1,
                child: const Text(
                  'About',
                  style: TextStyle(color: Colors.white),
                ),
              ),

              const SizedBox(width: 12),
            ],
          ),
          body: pages[selectedTab],
        ),
      ],
    );
  }
}
