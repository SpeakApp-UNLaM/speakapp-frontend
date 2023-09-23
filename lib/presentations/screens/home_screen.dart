import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sp_front/auth/user.dart';
import 'package:sp_front/auth/user_preferences.dart';
import 'package:sp_front/config/theme/app_theme.dart';
import 'package:sp_front/presentations/widgets/navigation-drawer/custom_bottom_navigation.dart';

import '../../config/menu/menu_items.dart';
import '../../providers/auth_provider.dart';
import '../../providers/login_provider.dart';

enum SampleItem { config, logOut }

class HomeScreen extends StatefulWidget {
  static const name = 'home-screen';

  final Widget childView;

  const HomeScreen({Key? key, required this.childView}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();


}

class _HomeScreenState extends State<HomeScreen> {
  String firstName = '';
  bool isLoading = true;
      @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storedUserName = prefs.getString('firstName') ?? "Nombre no encontrado"; // Valor predeterminado si no se encuentra
    setState(() {
      firstName = storedUserName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        titleSpacing: 20,
        backgroundColor: Theme.of(context).primaryColor,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hola!',
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Color(0xFFF5F5F5),
                )),
            Text(firstName,
                style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFFF5F5F5),
                    fontFamily: 'IkkaRounded',
                    fontWeight: FontWeight.w400))
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
                                Text('Configuracion'),
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
                            Text('Configuracion'),
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
      body: widget.childView,
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
        ),
      ),
    );
  }
}
