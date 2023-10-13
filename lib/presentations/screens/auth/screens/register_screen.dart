import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/theme/app_theme.dart';
import '../../../../shared/custom_filled_button.dart';
import '../../../../shared/custom_text_form_field.dart';
import '../../../../shared/geometrical_background.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
                const SizedBox(height: 50),
                // Icon Banner
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          if (!context.canPop()) return;
                          context.pop();
                        },
                        icon: const Icon(Icons.arrow_back_rounded,
                            size: 40, color: Colors.white)),
                    const Spacer(flex: 1),
                    Text('Registro',
                        style: GoogleFonts.nunito(
                            textStyle: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.w800))),
                    const Spacer(flex: 2),
                  ],
                ),

                const SizedBox(height: 50),

                // Wrapping _RegisterForm with SingleChildScrollView
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  height: size.height -
                      260, // 80 from two SizedBox and 100 from the icon
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: scaffoldBackgroundColor,
                  ),
                  child: _RegisterForm(),
                ),
                SizedBox(
                  width: 260,
                  height: 50,
                  child: CustomFilledButton(
                    text: 'CREAR',
                    buttonColor: colorList[0],
                    onPressed: () {},
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RegisterForm extends StatelessWidget {
  const _RegisterForm();

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const CustomTextFormField(
            label: 'Nombre',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          const CustomTextFormField(
            label: 'Apellido',
          ),
          const SizedBox(height: 20),
          const CustomTextFormField(
            label: 'Sexo',
          ),
          const SizedBox(height: 20),
          const CustomTextFormField(
            label: 'Edad',
          ),
          const SizedBox(height: 20),
          const CustomTextFormField(
            label: 'Nombre de Usuario',
          ),
          const SizedBox(height: 20),
          const CustomTextFormField(
            label: 'Correo',
          ),
          const SizedBox(height: 20),
          const CustomTextFormField(
            label: 'Contraseña',
            obscureText: true,
          ),
          const SizedBox(height: 20),
          const CustomTextFormField(
            label: 'Repita la contraseña',
            obscureText: true,
          ),
          const SizedBox(height: 20),
          const CustomTextFormField(
            label: 'Código de Profesional',
          ),
        ],
      ),
    );
  }
}
