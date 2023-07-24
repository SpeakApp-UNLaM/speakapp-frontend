import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:sp_front/config/menu/menu_items.dart';

class SideMenu extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const SideMenu({super.key, required this.scaffoldKey});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  int navDrawerIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
        selectedIndex: navDrawerIndex,
        onDestinationSelected: (value) {
          setState(() {
            navDrawerIndex = value;
          });

          final menuItem = appMenuItems[value];
          context.push(menuItem.link);
          widget.scaffoldKey.currentState?.closeDrawer();
        },
        backgroundColor: Theme.of(context).colorScheme.background,
        children: [
          buildHeader(context),
          ...appMenuItems.map((item) => NavigationDrawerDestination(
                icon: Icon(item.icon, color: Theme.of(context).primaryColor),
                label: Text(item.title,
                    style: Theme.of(context).textTheme.labelMedium),
              ))
        ]);
  }
}

Widget buildHeader(BuildContext context) => Container(
      padding: EdgeInsets.zero,
      child: UserAccountsDrawerHeader(
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
        accountName: Text(
          "Tomas Ramirez",
          //TODO GET USER NAME
          style: Theme.of(context).textTheme.labelSmall,
        ),
        accountEmail: Text(
          //TODO GET USER EMAIL
          "tomasramirez@gmail.com",
          style: Theme.of(context).textTheme.labelSmall,
        ),
        currentAccountPicture: const CircleAvatar(
          //TODO GET USER IMAGE
          backgroundImage: NetworkImage(
              'https://img.freepik.com/foto-gratis/nino-sonriente-aislado-rosa_23-2148984798.jpg?w=1380&t=st=1689548961~exp=1689549561~hmac=ca7f09fd97ffda2f39c4e258f2ae1c44b69bab0c6423cd0ec106c492a469caf2'),
        ),
      ),
    );

Widget buildMenuItems(BuildContext context) => Wrap(
      runSpacing: 16,
      children: [
        AboutListTile(
          // <-- SEE HERE
          icon: Icon(
            Icons.info_outlined,
            color: Theme.of(context).primaryColor,
          ),
          applicationIcon: Icon(
            Icons.local_play_outlined,
          ),
          applicationName: 'Speak App',
          applicationVersion: '1.0.0',
          applicationLegalese: '© 2023 - SpeakApp',
          aboutBoxChildren: [
            ///Content goes here...
          ],
          child: Text('About', style: Theme.of(context).textTheme.labelMedium),
        )
      ],
    );
