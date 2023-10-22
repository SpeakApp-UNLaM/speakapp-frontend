import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sp_front/config/theme/app_theme.dart';
import 'package:sp_front/providers/login_provider.dart';

import '../../../../shared/custom_filled_button.dart';
import '../../../../shared/custom_text_form_field.dart';
import '../../../../shared/geometrical_background.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          body: GeometricalBackground(
              child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            // Icon Banner
            const Image(
              image: AssetImage('assets/branding/Logo_SpeakApp.png'),
              width: 220,
              height: 100,
            ),
            const SizedBox(height: 50),

            Container(
              height: size.height - 260, // 80 los dos sizebox y 100 el ícono
              width: double.infinity,
              decoration: BoxDecoration(
                color: scaffoldBackgroundColor,
                borderRadius:
                    const BorderRadius.only(topLeft: Radius.circular(100)),
              ),
              child: const _LoginForm(),
            )
          ],
        ),
      ))),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm();

  @override
  Widget build(BuildContext context) {
    final loginProv = context.watch<LoginProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          const SizedBox(height: 50),
          Text('Bienvenido',
              style: GoogleFonts.nunito(
                  textStyle: TextStyle(
                      fontSize: 30,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w800))),
          const SizedBox(height: 90),
          CustomTextFormField(
            label: 'Correo',
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) =>
                context.read<LoginProvider>().onEmailChange(value),
            errorMessage: loginProv.email.errorMessage,
          ),
          const SizedBox(height: 30),
          CustomTextFormField(
            label: 'Contraseña',
            obscureText: true,
            onChanged: (value) =>
                context.read<LoginProvider>().onPasswordChange(value),
            errorMessage: loginProv.password.errorMessage,
          ),
          const SizedBox(height: 30),
          SizedBox(
              width: double.infinity,
              height: 60,
              child: CustomFilledButton(
                text: 'INGRESAR',
                buttonColor: colorList[0],
                onPressed: () async {
                  await context.read<LoginProvider>().onFormSubmit(context);
                },
              )),
          const Spacer(flex: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                '¿No tienes una cuenta?',
                style: GoogleFonts.nunito(
                    color: Colors.grey.shade500, fontSize: 14),
              ),
              TextButton(
                  onPressed: () => context.push('/register'),
                  child: Text('Crea una aquí',
                      style: GoogleFonts.nunito(
                          color: Theme.of(context).primaryColor, fontSize: 14)))
            ],
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
