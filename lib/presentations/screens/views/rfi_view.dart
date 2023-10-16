import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sp_front/config/theme/app_theme.dart';
import 'package:sp_front/presentations/screens/choice_patient_screen.dart';

class RfiView extends StatefulWidget {
  static const String name = 'rfi_view';

  const RfiView({Key? key}) : super(key: key);

  @override
  RfiViewState createState() => RfiViewState();
}

class RfiViewState extends State<RfiView> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: colorList[7],
          toolbarHeight: 80,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text('Registro fonológico inducido',
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
            ],
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
        ),
        body: const ChoicePatientScreen());
  }
}

/*Center(
          child: FilledButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorList[4],
              ),
              onPressed: () {
                context.push("/rfi");
              },
              child: Text(
                "Comenzar Test RFI",
                style: Theme.of(context).textTheme.labelSmall,
              )),
        )*/
