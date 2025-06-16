import 'package:custos/core/utils/constants.dart';
import 'package:custos/presentation/components/custom_button.dart';
import 'package:custos/presentation/components/form/custom_text_form_field.dart';
import 'package:custos/presentation/components/scaffold_widget.dart';
import 'package:flutter/widgets.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

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
          CustomTextFormField(label: 'Repeat master key'),
          CustomButton(
            label: 'Register',
            infiniteWidth: true,
            onPressed: () {
              // Handle register logic here
            },
          ),
        ],
      ),
    );
  }
}
