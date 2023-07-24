import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyAppBar extends StatelessWidget {
  const MyAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.notifications_none,
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
        );
  }
}