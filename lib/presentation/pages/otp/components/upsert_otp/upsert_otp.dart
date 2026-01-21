import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/extensions/build_context_form_validators_extension.dart';
import 'package:custos/data/models/otp/otp_entity.dart';
import 'package:custos/presentation/components/custom_button.dart';
import 'package:custos/presentation/components/form/custom_text_form_field.dart';
import 'package:custos/presentation/pages/otp/components/upsert_otp/cubit/upsert_otp_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class UpsertOtp extends StatefulWidget {
  const UpsertOtp({super.key, this.otp});

  final OtpEntity? otp;

  @override
  State<UpsertOtp> createState() => _UpsertOtpState();
}

class _UpsertOtpState extends State<UpsertOtp> {
  /// Create a global key to uniquely identify the Form widget for validation
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _secretCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final otp = widget.otp;
    if (otp != null) {
      _nameController.text = otp.name;
      _secretCodeController.text = otp.secretCode.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UpsertOtpCubit(),
      child: BlocConsumer<UpsertOtpCubit, UpsertOtpState>(
        listener: (context, state) {
          if (state.upsertOtpState.isData && state.upsertOtpState.data) {
            context.pop();
          }
          if (state.upsertOtpState.isError) {
            context.pop();
            context.showSnackBar(
              isErrorMessage: true,
              message: context.localizeError(failure: state.upsertOtpState.error),
            );
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 24.0,
              children: [
                CustomTextFormField(
                  controller: _nameController,
                  label: 'Name',
                  hint: ' Ej. Google, GitHub, etc...',
                  isRequired: true,
                  validator: context.validateRequired,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                  textInputType: TextInputType.text,
                ),
                CustomTextFormField(
                  controller: _secretCodeController,
                  label: 'Secret Code',
                  hint: ' Enter the secret code',
                  isRequired: true,
                  validator: context.validateOTPSecretCode,
                  textInputAction: TextInputAction.done,
                  textInputType: TextInputType.text,
                  inputFormatters: [
                    TextInputFormatter.withFunction(
                      (oldValue, newValue) =>
                          TextEditingValue(text: newValue.text.toUpperCase(), selection: newValue.selection),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 24.0,
                  children: [
                    // Cancel
                    CustomButton(
                      type: CustomTextButtonEnum.outlined,
                      label: context.l10n.cancel,
                      onPressed: () => context.pop(),
                    ),
                    // Add/Edit OTP
                    CustomButton(
                      label: widget.otp == null ? 'Add' : 'Save',
                      isLoading: state.upsertOtpState.isLoading,
                      onPressed: () => _upsertOtp(context),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _upsertOtp(BuildContext context) {
    if (_formKey.currentState?.validate() == true) {
      final now = DateTime.now().toUtc();
      context.read<UpsertOtpCubit>().upsertOtp(
        otp: OtpEntity(
          id: widget.otp?.id ?? Uuid().v4(),
          name: _nameController.text.trim(),
          secretCode: _secretCodeController.text.trim().toUpperCase(),
          createdAt: widget.otp?.createdAt ?? now,
          updatedAt: now,
        ),
      );

      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _secretCodeController.dispose();
    super.dispose();
  }
}
