import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sp_front/auth/user.dart';
import 'package:sp_front/auth/user_preferences.dart';
import 'package:sp_front/config/theme/app_theme.dart';
import 'package:sp_front/providers/auth_provider.dart';
import '../../config/menu/menu_items.dart';
import '../../providers/login_provider.dart';

enum SampleItem { config, logOut }

class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';

  final Widget childView;

  const HomeScreen({super.key, required this.childView});

  @override
  Widget build(BuildContext context) {
    User? user;
    UserPreferences().getUser().then((value) => {user = value})  ;
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
              ...appMenuItems.map((item) => Icon(
                    item.icon,
                    color: item.color,
                    size: 35,
                  )),
            ],
            onTap: (index) {
              context.go(appMenuItems[index].link);
            },
          )),
    );
  }
}
/*
class HomeScreen extends StatefulWidget {
  static const String name = 'home-principal';

  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.notifications,
                    color: Theme.of(context).primaryColor,
                  ),
                )),
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {},
                  child: const CircleAvatar(
                    //TODO GET IMAGE FROM USER
                    backgroundImage: NetworkImage(
                        'https://img.freepik.com/foto-gratis/nino-sonriente-aislado-rosa_23-2148984798.jpg?w=1380&t=st=1689548961~exp=1689549561~hmac=ca7f09fd97ffda2f39c4e258f2ae1c44b69bab0c6423cd0ec106c492a469caf2'),
                  ),
                )),
          ],
        ),
        drawer: SideMenu(scaffoldKey: scaffoldKey),
        bottomNavigationBar: const CustomBottomNavigation(),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child:
                Text("Home", style: Theme.of(context).textTheme.headlineLarge),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
              color: Color(0xFFE4E4E4),
            ),
          ),
          const SizedBox(
            height: 100,
          ),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonHomeExercise(),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonHomeMessages(),
                  SizedBox(width: 20),
                  ButtonHomeTurns(),
                ],
              )
            ],
          )
        ]));
  }
}*/
