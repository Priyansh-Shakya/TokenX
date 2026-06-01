import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_template/features/about/dev_members.dart';
import 'package:flutter_starter_template/features/home/pages/home_page.dart';
import 'package:flutter_starter_template/features/notes/pages/notes_page.dart';
import 'package:flutter_starter_template/features/notes/providers/notes_providers.dart';

class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(selectedTabProvider);
    final title = ['Home', 'About', 'Notes'][selectedTab];
    final pages = [const HomePage(), const DevMembersPage(), const NotesPage()];

    return Scaffold(
      appBar: AppBar(
        title: Text('TokenX • $title'),
        backgroundColor: const Color(0xFF0F0F1E),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => ref.read(selectedTabProvider.notifier).state = 0,
            child: const Text('Home', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => ref.read(selectedTabProvider.notifier).state = 1,
            child: const Text('About', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => ref.read(selectedTabProvider.notifier).state = 2,
            child: const Text('Notes', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: pages[selectedTab],
      drawer: Drawer(
        backgroundColor: const Color(0xFF0F0F1E),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'TokenX Menu',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildDrawerItem(context, ref, 0, 'Home'),
              _buildDrawerItem(context, ref, 1, 'About'),
              _buildDrawerItem(context, ref, 2, 'Notes'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    WidgetRef ref,
    int index,
    String label,
  ) {
    final selectedTab = ref.watch(selectedTabProvider);
    return ListTile(
      title: Text(
        label,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: selectedTab == index ? Colors.white : Colors.white70,
          fontWeight: selectedTab == index
              ? FontWeight.bold
              : FontWeight.normal,
        ),
      ),
      selected: selectedTab == index,
      selectedTileColor: Colors.white10,
      onTap: () {
        ref.read(selectedTabProvider.notifier).state = index;
        Navigator.of(context).pop();
      },
    );
  }
}
