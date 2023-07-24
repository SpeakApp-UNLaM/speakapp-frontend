import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sp_front/config/theme/app_theme.dart';


class MenuItem {
  final String title;
  final String subtitle;
  final String link;
  final IconData icon;
  final Color color;

  const MenuItem({
    required this.title,
    required this.subtitle,
    required this.link,
    required this.icon,
    required this.color
  }
  );
}

final appMenuItems = <MenuItem>[
  MenuItem(
    title: 'Home',
    subtitle: '',
    link: '/',
    icon: Icons.extension,
    color: colorList[1] 
  ),
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
    color: colorList[3]
  ),
  MenuItem(
    title: 'Turnos',
    subtitle: '',
    link: '/turns_view',
    icon: Icons.calendar_month_rounded,
    color: colorList[5]
  ),

];

