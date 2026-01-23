import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/utils/app_spacing.dart';
import 'package:custos/presentation/components/base_state_ui.dart';
import 'package:custos/presentation/components/no_data_widget.dart';
import 'package:custos/presentation/components/option_tile.dart';
import 'package:custos/presentation/components/scaffold_widget.dart';
import 'package:custos/presentation/pages/otp/components/upsert_otp/upsert_otp.dart';
import 'package:custos/presentation/pages/otp/components/otp_tile.dart';
import 'package:custos/presentation/pages/otp/cubit/otp_cubit.dart';
import 'package:custos/core/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OtpPage extends StatelessWidget {
  const OtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OtpCubit()..watchOtps(),
      child: BlocListener<OtpCubit, OtpState>(
        listener: (context, state) {
          if (state.scanQRState.isData && state.scanQRState.data) {
            context.showSnackBar(message: context.l10n.otpSecurityCodeAddedSuccessfully);
          }
          if (state.scanQRState.isError) {
            context.showSnackBar(
              isErrorMessage: true,
              message: context.localizeError(failure: state.scanQRState.error),
            );
          }
        },
        child: ScaffoldWidget(
          floatingActionButton: BlocBuilder<OtpCubit, OtpState>(
            builder: (context, state) {
              return FloatingActionButton(
                child: Icon(AppIcons.add, color: Colors.white),
                onPressed: () => _showAddOtpOptions(context),
              );
            },
          ),
          padding: EdgeInsets.symmetric(horizontal: context.xl),
          child: BlocBuilder<OtpCubit, OtpState>(
            builder: (context, state) {
              return BaseStateUi(
                state: state.otps,
                onRetryPressed: () => context.read<OtpCubit>().watchOtps(),
                noDataWidget: NoDataWidget(
                  iconData: AppIcons.otp,
                  title: context.l10n.otpNoAccountsToShow,
                  subtitle: context.l10n.otpAddAccountsToGetOtpCodes,
                ),
                onDataChild: (otps) {
                  return ListView.builder(
                    itemCount: state.otps.data.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: context.s),
                        child: OtpTile(otp: state.otps.data[index], showDeleteButton: true),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showAddOtpOptions(BuildContext context) {
    context.showCustomModalBottomSheet(
      child: BlocProvider.value(
        value: context.read<OtpCubit>(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: context.md,
          children: [
            OptionTile(
              icon: AppIcons.qrCode,
              title: context.l10n.otpScanQR,
              onTap: () {
                context.pop();
                context.read<OtpCubit>().scanQRCode();
              },
            ),
            OptionTile(
              icon: AppIcons.add,
              title: context.l10n.otpAddManual,
              onTap: () {
                context.pop();
                context.showCustomGeneralDialog(title: context.l10n.otpAddSecurityCode, child: const UpsertOtp());
              },
            ),
          ],
        ),
      ),
    );
  }
}
