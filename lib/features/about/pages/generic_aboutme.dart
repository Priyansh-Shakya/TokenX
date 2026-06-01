import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// ─── Data models ─────────────────────────────────────────────────────────────

class SocialLink {
  final SocialPlatform platform;
  final String url;

  const SocialLink({required this.platform, required this.url});
}

enum SocialPlatform { linkedin, github, reddit, discord }

extension SocialPlatformExt on SocialPlatform {
  String get label => switch (this) {
    SocialPlatform.linkedin => 'LinkedIn',
    SocialPlatform.github => 'GitHub',
    SocialPlatform.reddit => 'Reddit',
    SocialPlatform.discord => 'Discord',
  };

  IconData get icon => switch (this) {
    SocialPlatform.linkedin => Icons.business_center_rounded,
    SocialPlatform.github => Icons.code_rounded,
    SocialPlatform.reddit => Icons.forum_rounded,
    SocialPlatform.discord => Icons.headset_mic_rounded,
  };

  Color get color => switch (this) {
    SocialPlatform.linkedin => const Color(0xFF0A66C2),
    SocialPlatform.github => const Color(0xFFE6EDF3),
    SocialPlatform.reddit => const Color(0xFFFF4500),
    SocialPlatform.discord => const Color(0xFF5865F2),
  };
}

class ExtraSection {
  final String title;
  final String description;
  final IconData icon;
  final Color accentColor;
  final List<SocialLink> links; // optional links specific to this section

  const ExtraSection({
    required this.title,
    required this.description,
    required this.icon,
    this.accentColor = const Color(0xFF7C3AED),
    this.links = const [],
  });
}

// ─── Generic MemberAboutPage ──────────────────────────────────────────────────

class MemberAboutPage extends StatelessWidget {
  /// Display name shown as the hero heading.
  final String name;

  /// Short tagline shown below the name, e.g. "AI/ML · Flutter · FastAPI".
  final String tagline;

  /// Multi-paragraph bio. Plain text; no markdown needed here.
  final String bio;

  /// Optional asset path or network URL for the profile picture.
  /// If null, falls back to a person icon placeholder.
  final String? avatarAsset;

  /// Social links to render.
  final List<SocialLink> socials;

  /// Optional extra sections (e.g. a studio brand, open-source org, etc.)
  final List<ExtraSection> extras;

  const MemberAboutPage({
    super.key,
    required this.name,
    required this.tagline,
    required this.bio,
    this.avatarAsset,
    this.socials = const [],
    this.extras = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1E),
      appBar: AppBar(
        title: Text(name),
        backgroundColor: const Color(0xFF0F0F1E),
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return constraints.maxWidth > 900
              ? _WideBody(page: this)
              : _NarrowBody(page: this);
        },
      ),
    );
  }
}

// ─── Wide layout (≥ 900 px) ───────────────────────────────────────────────────

class _WideBody extends StatelessWidget {
  const _WideBody({required this.page});
  final MemberAboutPage page;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Left column: avatar + identity + socials ──────────────────────
        Container(
          width: 320,
          height: double.infinity,
          color: const Color(0xFF12122B),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
            child: _LeftColumn(page: page),
          ),
        ),

        // ── Right column: bio + extras ────────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 48),
            child: _RightColumn(page: page),
          ),
        ),
      ],
    );
  }
}

// ─── Narrow layout (< 900 px) ────────────────────────────────────────────────

class _NarrowBody extends StatelessWidget {
  const _NarrowBody({required this.page});
  final MemberAboutPage page;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        children: [
          _LeftColumn(page: page),
          const SizedBox(height: 32),
          _RightColumn(page: page),
        ],
      ),
    );
  }
}

// ─── Left column contents ────────────────────────────────────────────────────

class _LeftColumn extends StatelessWidget {
  const _LeftColumn({required this.page});
  final MemberAboutPage page;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Avatar
        _Avatar(asset: page.avatarAsset),
        const SizedBox(height: 24),

        // Name
        Text(
          page.name,
          textAlign: TextAlign.center,
          style: tt.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),

        // Tagline
        Text(
          page.tagline,
          textAlign: TextAlign.center,
          style: tt.bodySmall?.copyWith(
            color: Colors.white38,
            letterSpacing: 1.3,
          ),
        ),
        const SizedBox(height: 36),

        // Socials header
        if (page.socials.isNotEmpty) ...[
          _SectionLabel('CONNECT'),
          const SizedBox(height: 12),
          ...page.socials.map((s) => _SocialTile(social: s)),
        ],
      ],
    );
  }
}

// ─── Right column contents ───────────────────────────────────────────────────

class _RightColumn extends StatelessWidget {
  const _RightColumn({required this.page});
  final MemberAboutPage page;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Bio card ──────────────────────────────────────────────────────
        _Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionLabel('ABOUT'),
              const SizedBox(height: 16),
              Text(
                page.bio,
                style: tt.bodyMedium?.copyWith(
                  color: Colors.white70,
                  height: 1.8,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),

        // ── Extra sections ────────────────────────────────────────────────
        if (page.extras.isNotEmpty) ...[
          const SizedBox(height: 24),
          _SectionLabel('EXTRAS'),
          const SizedBox(height: 16),
          ...page.extras.map((e) => _ExtraCard(section: e)),
        ],
      ],
    );
  }
}

// ─── Avatar ──────────────────────────────────────────────────────────────────

class _Avatar extends StatelessWidget {
  const _Avatar({this.asset});
  final String? asset;

  @override
  Widget build(BuildContext context) {
    final isNetwork =
        asset != null &&
        (asset!.startsWith('http://') || asset!.startsWith('https://'));
    final isAsset = asset != null && !isNetwork;

    ImageProvider? imageProvider;
    if (isNetwork) imageProvider = NetworkImage(asset!);
    if (isAsset) imageProvider = AssetImage(asset!);

    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white12,
        border: Border.all(color: Colors.white24, width: 2),
        image: imageProvider != null
            ? DecorationImage(image: imageProvider, fit: BoxFit.cover)
            : null,
      ),
      child: imageProvider == null
          ? const Icon(Icons.person_rounded, size: 64, color: Colors.white38)
          : null,
    );
  }
}

// ─── Social tile ─────────────────────────────────────────────────────────────

class _SocialTile extends StatelessWidget {
  const _SocialTile({required this.social});
  final SocialLink social;

  @override
  Widget build(BuildContext context) {
    final p = social.platform;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () async {
          final uri = Uri.parse(social.url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white12),
          ),
          child: Row(
            children: [
              Icon(p.icon, size: 18, color: p.color),
              const SizedBox(width: 10),
              Text(
                p.label,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
              ),
              const Spacer(),
              const Icon(
                Icons.open_in_new_rounded,
                size: 13,
                color: Colors.white24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Extra section card ──────────────────────────────────────────────────────

class _ExtraCard extends StatelessWidget {
  const _ExtraCard({required this.section});
  final ExtraSection section;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: _Card(
        accentColor: section.accentColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: section.accentColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    section.icon,
                    size: 20,
                    color: section.accentColor,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  section.title,
                  style: tt.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Description
            Text(
              section.description,
              style: tt.bodyMedium?.copyWith(
                color: Colors.white60,
                height: 1.7,
              ),
            ),

            // Optional links
            if (section.links.isNotEmpty) ...[
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: section.links
                    .map((l) => _ExtraLinkChip(link: l))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ExtraLinkChip extends StatelessWidget {
  const _ExtraLinkChip({required this.link});
  final SocialLink link;

  @override
  Widget build(BuildContext context) {
    final p = link.platform;
    return InkWell(
      onTap: () async {
        final uri = Uri.parse(link.url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: p.color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: p.color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(p.icon, size: 14, color: p.color),
            const SizedBox(width: 6),
            Text(
              p.label,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: p.color),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Shared card container ───────────────────────────────────────────────────

class _Card extends StatelessWidget {
  const _Card({required this.child, this.accentColor});
  final Widget child;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF12122B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: accentColor?.withOpacity(0.25) ?? Colors.white12,
        ),
      ),
      child: child,
    );
  }
}

// ─── Small label ─────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: Colors.white38,
        letterSpacing: 1.6,
      ),
    );
  }
}
