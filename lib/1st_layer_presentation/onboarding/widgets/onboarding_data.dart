import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

enum SlideColor { red, green, blue }

final data = [
  {
    'title': 'Chat like never before',
    'subtitle': 'Connect with friends anytime, anywhere',
    'leading': 'EXPERIENCE NOW',
    'icon': MdiIcons.chat,
    'title-2': 'LEVEL UP Your Socials',
    'body': 'Stay closer to your loved ones.\nChat, share and connect effortlessly.',
    'color': SlideColor.red,
    'animation': 'assets/backgrounds/slide1.json'
  },
  {
    'title': 'Unlock AI Assistance',
    'subtitle': 'Always prepared to provide assistance',
    'leading': 'GET PRODUCTIVE',
    'icon': MdiIcons.cloudUpload,
    'title-2': 'BOOST Your Produktivity',
    'body': 'Access intelligence with ease.\nExperience unmatched convenience.',
    'color': SlideColor.blue,
    'animation': 'assets/backgrounds/slide2.json'
  },
  {
    'title': 'We prioritize privacy',
    'subtitle': 'Protect with end-to-end encryption',
    'leading': 'ENSURING SECURITY',
    'icon': MdiIcons.security,
    'title-2': 'TRUST Our Encryption',
    'body': 'Your information is solely yours.\nTrust us for the highest level of privacy.',
    'color': SlideColor.green,
    'animation': 'assets/backgrounds/slide4.json'
  },
];
