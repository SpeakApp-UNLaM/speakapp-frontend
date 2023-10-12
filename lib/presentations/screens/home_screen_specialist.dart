import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sp_front/config/theme/app_theme.dart';
import '../../config/menu/menu_items.dart';
import '../../providers/auth_provider.dart';
import '../../providers/login_provider.dart';

enum SampleItem { config, logOut }

class HomeScreenSpecialist extends StatelessWidget {
  static const name = 'home-screen';

  final Widget childView;

  const HomeScreenSpecialist({super.key, required this.childView});

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
            Text('Tomas Gonzalez',
                style: Theme.of(context).textTheme.labelMedium)
          ],
        ),
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: PopupMenuButton(
                    color: colorList[7],
                    onSelected: (SampleItem) {},
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
                    child: Icon(
                      Icons.notifications,
                      color: colorList[7],
                    )),
              )),
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
                child: const CircleAvatar(
                  //TODO GET IMAGE FROM USER
                  backgroundImage: AssetImage('assets/niño-feliz.jpg'),
                )),
          ),
        ],
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: Theme.of(context).primaryColorLight,
              height: 1.0,
            )),
      ),
      body: childView,
      bottomNavigationBar: Container(
          margin: EdgeInsets.zero,
          child: CurvedNavigationBar(
            buttonBackgroundColor: colorList[7],
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            color: colorList[7],
            height: 50,
            items: <Widget>[
              ...appMenuItemsSpecialists.map((item) => Icon(
                    item.icon,
                    color: item.color,
                    size: 35,
                  )),
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
