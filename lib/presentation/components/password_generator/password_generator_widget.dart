import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/presentation/components/custom_button.dart';
import 'package:custos/presentation/components/form/custom_check_box_title.dart';
import 'package:custos/presentation/components/password_generator/cubit/password_generator_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PasswordGeneratorWidget extends StatelessWidget {
  const PasswordGeneratorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PasswordGeneratorCubit(router: GoRouter.of(context)),
      child: BlocBuilder<PasswordGeneratorCubit, PasswordGeneratorState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.passwordGeneratorLengthTitle,
                style: context.textTheme.titleMedium,
              ),

              const SizedBox(height: 16.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.l10n.passwordGeneratorCharactersLabel,
                    style: context.textTheme.bodyMedium,
                  ),
                  Text(
                    state.length.toString(),
                    style: context.textTheme.bodyMedium,
                  ),
                ],
              ),

              Slider(
                value: state.length.toDouble(),
                min: 8,
                max: 32,
                divisions: 24,
                label: state.length.toString(),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                onChanged: (value) {
                  context.read<PasswordGeneratorCubit>().updateValues(
                    state: state.copyWith(length: value.toInt()),
                  );
                },
              ),

              Text(
                context.l10n.passwordGeneratorIncludeTitle,
                style: context.textTheme.titleMedium,
              ),

              CustomCheckBoxTitle(
                title: context.l10n.passwordGeneratorUppercaseTitle,
                value: state.includeUppercase,
                onChanged: (value) {
                  context.read<PasswordGeneratorCubit>().updateValues(
                    state: state.copyWith(includeUppercase: value),
                  );
                },
              ),

              CustomCheckBoxTitle(
                title: context.l10n.passwordGeneratorLowercaseTitle,
                value: state.includeLowercase,
                onChanged: (value) {
                  context.read<PasswordGeneratorCubit>().updateValues(
                    state: state.copyWith(includeLowercase: value),
                  );
                },
              ),

              CustomCheckBoxTitle(
                title: context.l10n.passwordGeneratorNumbersTitle,
                value: state.includeNumbers,
                onChanged: (value) {
                  context.read<PasswordGeneratorCubit>().updateValues(
                    state: state.copyWith(includeNumbers: value),
                  );
                },
              ),

              CustomCheckBoxTitle(
                title: context.l10n.passwordGeneratorSymbolsTitle,
                value: state.includeSymbols,
                onChanged: (value) {
                  context.read<PasswordGeneratorCubit>().updateValues(
                    state: state.copyWith(includeSymbols: value),
                  );
                },
              ),

              const SizedBox(height: 16.0),

              CustomButton(
                label: context.l10n.passwordGeneratorGenerateButton,
                infiniteWidth: true,
                onPressed:
                    () =>
                        context
                            .read<PasswordGeneratorCubit>()
                            .generatePassword(),
              ),
            ],
          );
        },
      ),
    );
  }
}
