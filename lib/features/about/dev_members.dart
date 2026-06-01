import 'package:flutter/material.dart';
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

  // ── Add new contributors below this line ──────────────────────────────────
  // _MemberEntry(
  //   name: 'Jane Doe',
  //   tagline: 'Backend · Rust · DevOps',
  //   pageBuilder: (_) => const JaneDoeAboutPage(),
  // ),
];

// ─── Team page ───────────────────────────────────────────────────────────────

class DevMembersPage extends StatefulWidget {
  const DevMembersPage({super.key});

  @override
  State<DevMembersPage> createState() => _DevMembersPageState();
}

class _DevMembersPageState extends State<DevMembersPage> {
  // Index of the currently selected member (default = 0 → first in list)
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1E),
      appBar: AppBar(
        title: const Text('Team'),
        backgroundColor: const Color(0xFF0F0F1E),
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 700;
          return isWide
              ? _WideTeamLayout(
                  members: _members,
                  selected: _selected,
                  onSelect: (i) => setState(() => _selected = i),
                )
              : _NarrowTeamLayout(
                  members: _members,
                  selected: _selected,
                  onSelect: (i) => setState(() => _selected = i),
                );
        },
      ),
    );
  }
}

// ─── Wide: sidebar grid + inline detail ──────────────────────────────────────

class _WideTeamLayout extends StatelessWidget {
  const _WideTeamLayout({
    required this.members,
    required this.selected,
    required this.onSelect,
  });

  final List<_MemberEntry> members;
  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left: member cards
        Container(
          width: 260,
          color: const Color(0xFF12122B),
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: members.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) => _MemberCard(
              entry: members[i],
              isSelected: i == selected,
              onTap: () => onSelect(i),
            ),
          ),
        ),

        // Right: the selected member's about page (without its own Scaffold)
        Expanded(
          child: _InlineAboutWrapper(
            key: ValueKey(selected),
            entry: members[selected],
          ),
        ),
      ],
    );
  }
}

// ─── Narrow: full-screen grid, navigate to detail page ───────────────────────

class _NarrowTeamLayout extends StatelessWidget {
  const _NarrowTeamLayout({
    required this.members,
    required this.selected,
    required this.onSelect,
  });

  final List<_MemberEntry> members;
  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: members.length,
      itemBuilder: (context, i) => _MemberCard(
        entry: members[i],
        isSelected: i == selected,
        onTap: () {
          onSelect(i);
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: members[i].pageBuilder));
        },
      ),
    );
  }
}

// ─── Individual member card (used in both layouts) ───────────────────────────

class _MemberCard extends StatelessWidget {
  const _MemberCard({
    required this.entry,
    required this.isSelected,
    required this.onTap,
  });

  final _MemberEntry entry;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final isNetwork =
        entry.avatarAsset != null &&
        (entry.avatarAsset!.startsWith('http://') ||
            entry.avatarAsset!.startsWith('https://'));

    ImageProvider? imageProvider;
    if (isNetwork) imageProvider = NetworkImage(entry.avatarAsset!);
    if (entry.avatarAsset != null && !isNetwork) {
      imageProvider = AssetImage(entry.avatarAsset!);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF1E1E3F) : const Color(0xFF16162A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected ? Colors.white30 : Colors.white12,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Avatar
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white12,
                  border: Border.all(color: Colors.white24),
                  image: imageProvider != null
                      ? DecorationImage(image: imageProvider, fit: BoxFit.cover)
                      : null,
                ),
                child: imageProvider == null
                    ? const Icon(
                        Icons.person_rounded,
                        size: 32,
                        color: Colors.white38,
                      )
                    : null,
              ),
              const SizedBox(height: 12),

              // Name
              Text(
                entry.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: tt.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),

              // Tagline
              Text(
                entry.tagline,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: tt.bodySmall?.copyWith(
                  color: Colors.white38,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Inline about wrapper (wide layout — no Scaffold, no AppBar) ─────────────
// Renders the member's page content without wrapping it in another Scaffold.
// We use a simple Builder + Navigator trick: just show the page body directly.

class _InlineAboutWrapper extends StatelessWidget {
  const _InlineAboutWrapper({super.key, required this.entry});
  final _MemberEntry entry;

  @override
  Widget build(BuildContext context) {
    // Build the full page widget and extract just its body via a custom render.
    // Since MemberAboutPage is a Scaffold, we navigate inline using a nested
    // Navigator so the AppBar from the child doesn't conflict.
    return Navigator(
      onGenerateRoute: (_) => MaterialPageRoute(builder: entry.pageBuilder),
    );
  }
}
