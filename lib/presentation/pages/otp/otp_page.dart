import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/utils/app_spacing.dart';
import 'package:custos/presentation/components/base_state_ui.dart';
import 'package:custos/presentation/components/no_data_widget.dart';
import 'package:custos/presentation/components/scaffold_widget.dart';
import 'package:custos/presentation/pages/otp/components/upsert_otp/upsert_otp.dart';
import 'package:custos/presentation/pages/otp/components/otp_tile.dart';
import 'package:custos/presentation/pages/otp/cubit/otp_cubit.dart';
import 'package:custos/core/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpPage extends StatelessWidget {
  const OtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OtpCubit()..watchOtps(),
      child: ScaffoldWidget(
        floatingActionButton: FloatingActionButton(
          child: Icon(AppIcons.add, color: Colors.white),
          onPressed: () {
            context.showCustomGeneralDialog(title: 'Add OTP Code', child: const UpsertOtp());
          },
        ),
        padding: EdgeInsets.symmetric(horizontal: context.xl),
        child: BlocBuilder<OtpCubit, OtpState>(
          builder: (context, state) {
            return BaseStateUi(
              state: state.otps,
              onRetryPressed: () => context.read<OtpCubit>().watchOtps(),
              noDataWidget: NoDataWidget(
                iconData: AppIcons.key,
                title: 'No OTP Codes',
                subtitle: 'Add your first OTP code to get started',
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
    );
  }
}
