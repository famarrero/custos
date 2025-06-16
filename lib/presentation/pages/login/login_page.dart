import 'package:custos/core/utils/constants.dart';
import 'package:custos/presentation/components/custom_button.dart';
import 'package:custos/presentation/components/form/custom_text_form_field.dart';
import 'package:custos/presentation/components/scaffold_widget.dart';
import 'package:custos/routes/routes.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      padding: EdgeInsets.symmetric(
        vertical: kMobileVerticalPadding,
        horizontal: kMobileHorizontalPadding,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 24.0,
        children: [
          CustomTextFormField(label: 'Master key'),
          CustomButton(
            label: 'Login',
            infiniteWidth: true,
            onPressed: () {
              context.go(PasswordsEntriesRoute().location);
            },
          ),
        ],
      ),
    );
  }
}
