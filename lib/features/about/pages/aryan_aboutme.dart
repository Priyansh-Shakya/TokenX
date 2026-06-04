import 'package:flutter/material.dart';
import 'package:tokenx/features/about/pages/_generic_aboutme.dart';

class AryanAboutPage extends StatelessWidget {
  const AryanAboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  MemberAboutPage(
      name: 'Aryan Gupta',
      tagline: 'Backend · DevOps · Open Source',

      bio:
          'Computer Science student passionate about backend development, '
          'distributed systems, and building scalable applications.\n\n'
          'I enjoy working with FastAPI, PostgreSQL, Docker, and cloud-native '
          'technologies to create reliable and efficient software solutions.\n\n'
          'Outside of development, I spend time exploring open-source projects, '
          'learning system design concepts, and experimenting with automation tools.\n\n'
          'Currently focused on improving my knowledge of cloud infrastructure, '
          'microservices architecture, and modern deployment workflows.',

      socials: [
        SocialLink(
          platform: SocialPlatform.linkedin,
          url: 'https://linkedin.com/in/aryan-gupta',
        ),
        SocialLink(
          platform: SocialPlatform.github,
          url: 'https://github.com/aryangupta',
        ),
        SocialLink(
          platform: SocialPlatform.reddit,
          url: 'https://reddit.com/user/aryangupta',
        ),
      ],

      extras: [
        ExtraSection(
          title: 'Open Source Contributions',
          description:
              'I actively contribute to community-driven projects and enjoy '
              'collaborating with developers from different backgrounds. '
              'My interests range from backend frameworks and tooling to '
              'developer productivity and infrastructure projects.',
          icon: Image.asset('dev_members/aryan/open_source.png', fit: BoxFit.contain,)  ,
          accentColor: Color(0xFF2563EB),
        ),
      ],
    );
  }
}
