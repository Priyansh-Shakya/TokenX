import 'package:flutter/material.dart';
import 'package:tokenx/features/about/pages/_generic_aboutme.dart';

class PriyanshAboutPage extends StatelessWidget {
  const PriyanshAboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MemberAboutPage(
      name: 'Priyansh Shakya',
      tagline: 'AI/ML · Flutter · FastAPI',

      // avatarAsset: 'assets/images/priyansh.jpg', // uncomment when you have one
      bio:
          'B.Tech CSE (AI & ML) student interested in Full Stack Development, '
          'AI/ML, conversational AI, and backend systems.\n\n'
          'I enjoy building practical applications with Flutter and FastAPI, '
          'experimenting with LLMs & AI workflows, and creating reusable developer '
          'tools and productivity-focused projects.\n\n'
          'Currently learning more about deep learning, scalable backend architecture, '
          'PostgreSQL optimization, and LLM fine-tuning.\n\n'
          'Open to collaborating on Flutter, FastAPI, AI/ML, and developer tooling projects.',

      socials: [
        SocialLink(
          platform: SocialPlatform.linkedin,
          url: 'https://www.linkedin.com/in/priyansh-shakya-a25459331/',
        ),
        SocialLink(
          platform: SocialPlatform.github,
          url: 'https://github.com/Priyansh-Shakya',
        ),
        SocialLink(
          platform: SocialPlatform.reddit,
          url: 'https://reddit.com/user/Valid_Crashout_',
        ),
      ],

      extras: [
        ExtraSection(
          title: 'Dr Dwarf Studios',
          description:
              'My indie app publishing brand on the Play Store. '
              'I build and ship small but polished Flutter apps under this studio — '
              'ranging from productivity tools to experimental AI-powered utilities. '
              'The name is a nod to keeping things compact, focused, and a little quirky.',
          icon: Image.asset(
            'dev_members/priyansh/dr_dwarf.png',

            fit: BoxFit.contain,
          ),
          accentColor: Color(0xFF7C3AED),

          // Add a Play Store / GitHub link here once you have one:
          links: [
            (
              label: 'Play Store',
              url:
                  "https://play.google.com/console/u/0/developers/5314454300312717418/app-list",
            ),
          ],
          //   (label: 'GitHub', url: 'https://github.com/DrDwarfStudios'),
          // ],
        ),
      ],
    );
  }
}
