import 'package:flutter/material.dart';
import 'package:flutter_starter_template/features/about/pages/aryan_aboutme.dart';
import 'package:flutter_starter_template/features/about/pages/priyansh_aboutme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CONTRIBUTOR GUIDE
// 1. Create your own file at features/about/members/yourname_about.dart
//    using MemberAboutPage (see priyansh_about.dart as the template).
// 2. Add one entry to the _members list below.
// That's it — the grid updates automatically.
// ─────────────────────────────────────────────────────────────────────────────

class _MemberEntry {
  final String name;
  final String tagline;
  final String? avatarAsset; // asset path or network URL, null = placeholder
  final WidgetBuilder pageBuilder;

  const _MemberEntry({
    required this.name,
    required this.tagline,
    this.avatarAsset,
    required this.pageBuilder,
  });
}

// ── Registry ──────────────────────────────────────────────────────────────────
// First entry = default page shown when the screen opens.

final _members = <_MemberEntry>[
  _MemberEntry(
    name: 'Priyansh Shakya',
    tagline: 'AI/ML · Flutter · FastAPI',
    // avatarAsset: 'assets/images/priyansh.jpg',
    pageBuilder: (_) => const PriyanshAboutPage(),
  ),

  _MemberEntry(
    name: 'Aryan Kumar',
    tagline: 'Flutter · Dart · Open Source',
    // avatarAsset: 'assets/images/aryan.jpg',
    pageBuilder: (_) => const AryanAboutPage(),
  ),

  // ── Add new contributors below this line ──────────────────────────────────
  // _MemberEntry(
  //   name: 'Jane Doe',
  //   tagline: 'Backend · Rust · DevOps',
  //   pageBuilder: (_) => const JaneDoeAboutPage(),
  // ),
];

// ─── Team page ───────────────────────────────────────────────────────────────

class DevMembersPage extends StatelessWidget {
  const DevMembersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _members.length,
      child: Scaffold(
        backgroundColor: const Color(0xFF0F0F1E),
        appBar: AppBar(
          title: const Text('Team'),
          backgroundColor: const Color(0xFF0F0F1E),
          elevation: 0,
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: _members.map((member) => Tab(text: member.name)).toList(),
          ),
        ),
        body: TabBarView(
          children: _members
              .map((member) => _MemberTabPage(entry: member))
              .toList(),
        ),
      ),
    );
  }
}

class _MemberTabPage extends StatelessWidget {
  const _MemberTabPage({required this.entry});

  final _MemberEntry entry;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0F0F1E),
      child: entry.pageBuilder(context),
    );
  }
}
