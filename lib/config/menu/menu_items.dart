import 'package:flutter/material.dart';
import 'package:sp_front/config/theme/app_theme.dart';

class MenuItem {
  final String title;
  final String subtitle;
  final String link;
  final IconData icon;
  final Color color;
  final Color shadowColor;

  const MenuItem(
      {required this.title,
      required this.subtitle,
      required this.link,
      required this.icon,
      required this.color,
      required this.shadowColor});
}

final appMenuItems = <MenuItem>[
  MenuItem(
      title: 'Home',
      subtitle: '',
      link: '/',
      icon: Icons.extension,
      color: colorList[0],
      shadowColor: colorList[2]),
  /*
  MenuItem(
    title: 'Ejercicios',
    subtitle: '',
    link: '/exercises_pending_view',
    icon: Icons.extension_outlined
  ),*/
  MenuItem(
      title: 'Mensajes',
      subtitle: '',
      link: '/messages_view',
      icon: Icons.mail_rounded,
      color: colorList[4],
      shadowColor: Colors.green.shade800),
];

final appMenuItemsSpecialists = <MenuItem>[
  MenuItem(
      title: 'Home',
      subtitle: '',
      link: '/',
      icon: Icons.extension,
      color: colorList[0],
      shadowColor: colorList[2]),
  MenuItem(
      title: 'RFI',
      subtitle: 'RFI',
      link: '/rfi_view',
      icon: Icons.assignment_turned_in_rounded,
      color: Colors.blueAccent,
      shadowColor: Colors.blue.shade700),
  MenuItem(
      title: 'Mensajes',
      subtitle: '',
      link: '/messages_view',
      icon: Icons.mail_rounded,
      color: colorList[4],
      shadowColor: Colors.green.shade700),
];
