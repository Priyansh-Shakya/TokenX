import 'package:flutter/material.dart';
import 'package:tokenx/features/about/pages/aryan_aboutme.dart';
import 'package:tokenx/features/about/pages/priyansh_aboutme.dart';

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
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: const Color(0xAA0F0F1E).withOpacity(0.40),
          elevation: 0,
          titleSpacing: 16,
          title: Row(
            children: [
              const Text(
                'Team',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                '·',
                style: TextStyle(color: Colors.white38, fontSize: 16),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white54,
                  indicatorSize: TabBarIndicatorSize.label,
                  dividerColor: Colors.transparent,
                  tabs: _members.map((m) => Tab(text: m.name)).toList(),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: _members.map((m) => _MemberTabPage(entry: m)).toList(),
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
      color: Colors.transparent,
      child: entry.pageBuilder(context),
    );
  }
}
