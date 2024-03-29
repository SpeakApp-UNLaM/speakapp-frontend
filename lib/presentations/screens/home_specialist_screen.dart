import 'dart:convert';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sp_front/config/theme/app_theme.dart';
import '../../config/menu/menu_items.dart';
import '../../providers/auth_provider.dart';
import '../../providers/login_provider.dart';

enum SampleItem { config, logOut }


class HomeSpecialistScreen extends StatefulWidget {
  final Widget childView;
    static const name = 'home-screen';

  const HomeSpecialistScreen({Key? key, required this.childView}) : super(key: key);

  @override
  _HomeSpecialistScreenState createState() => _HomeSpecialistScreenState();
}

class _HomeSpecialistScreenState extends State<HomeSpecialistScreen> {
    late Image? userImage;

  @override
  void initState() {
    String? userImageData = context.read<AuthProvider>().loggedUser.imageData;
    if (userImageData != null && userImageData != "") {
      userImage = Image.memory(
          base64.decode(
              context.read<AuthProvider>().loggedUser.imageData as String),
          fit: BoxFit.cover);
    } else {
      userImage = null;
    }

    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        titleSpacing: 20,
        backgroundColor: Theme.of(context).primaryColor,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hola!', style: Theme.of(context).textTheme.labelSmall),
            Text(context.read<AuthProvider>().loggedUser.firstName,
                style: Theme.of(context).textTheme.labelMedium)
          ],
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: PopupMenuButton(
                color: colorList[7],
                onSelected: (SampleItem item) {
                  switch (item) {
                    case SampleItem.logOut:
                      context.read<LoginProvider>().onLogOut(context);
                    default:
                      return;
                  }
                },
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<SampleItem>>[
                      const PopupMenuItem<SampleItem>(
                        value: SampleItem.config,
                        child: Row(
                          children: [
                            Icon(Icons.settings),
                            SizedBox(width: 8),
                            Text('Configuración'),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                      const PopupMenuItem<SampleItem>(
                        value: SampleItem.logOut,
                        child: Row(
                          children: [
                            Icon(Icons.logout),
                            SizedBox(width: 8),
                            Text('Salir'),
                          ],
                        ),
                      ),
                    ],
                child: userImage == null
                  ? PhysicalModel(
                      color: Theme.of(context).primaryColor,
                      shadowColor: Theme.of(context).primaryColor,
                      elevation: 12,
                      shape: BoxShape.circle,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        foregroundColor: Theme.of(context).primaryColor,
                        child: const ClipOval(
                          child: Icon(Icons.person, size: 30),
                        ),
                      ),
                    )
                  : PhysicalModel(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                      shadowColor: Theme.of(context).primaryColor,
                      elevation: 12,
                      child: CircleAvatar(
                          radius: 20,
                          //TODO GET IMAGE FROM USER
                          backgroundImage: (userImage as Image).image),
                    ),),
          ),
        ],
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: Theme.of(context).primaryColorLight,
              height: 1.0,
            )),
      ),
      body: widget.childView,
      bottomNavigationBar: Container(
          margin: EdgeInsets.zero,
          child: CurvedNavigationBar(
            buttonBackgroundColor: colorList[7],
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            color: colorList[7],
            height: 50,
            items: <Widget>[
              ...appMenuItemsSpecialists.map(
                (item) => Icon(
                  item.icon,
                  color: item.color,
                  size: 35,
                ),
              )
            ],
            onTap: (index) {
              if (appMenuItemsSpecialists[index].link == '/') {
                context.go(appMenuItemsSpecialists[index].link,
                    extra: authProvider.prefs.getInt('userId') as int);
              } else {
                context.go(appMenuItemsSpecialists[index].link);
              }
            },
          )),
    );
  }
}
