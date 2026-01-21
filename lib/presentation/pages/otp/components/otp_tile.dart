import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/utils/app_spacing.dart';
import 'package:custos/data/models/otp/otp_entity.dart';
import 'package:custos/data/repositories/otp/otp_repository.dart';
import 'package:custos/di_container.dart';
import 'package:custos/presentation/components/custom_container.dart';
import 'package:custos/presentation/components/custom_icon_button.dart';
import 'package:custos/core/utils/app_icons.dart';
import 'package:custos/presentation/pages/otp/components/otp_code/otp_code_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class OtpTile extends StatefulWidget {
  const OtpTile({super.key, required this.otp, this.showDeleteButton = false});

  final OtpEntity otp;
  final bool showDeleteButton;

  @override
  State<OtpTile> createState() => _OtpTileState();
}

class _OtpTileState extends State<OtpTile> {
  late String tempCode;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: EdgeInsets.symmetric(vertical: context.lg, horizontal: context.xxl),
      child: Row(
        spacing: context.md,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: context.xs,
              children: [
                Text(widget.otp.name, style: context.textTheme.bodyLarge, overflow: TextOverflow.ellipsis),
                OtpCodeWidget(
                  secret: widget.otp.secretCode,
                  tempCode: (code) {
                    setState(() {
                      tempCode = code;
                    });
                  },
                ),
              ],
            ),
          ),
          CustomIconButton(
            icon: AppIcons.copy,
            backgroundColor: context.colorScheme.primaryContainer.withValues(alpha: 0.4),
            iconColor: context.colorScheme.onPrimaryContainer,
            iconSize: 16.0,
            onTap: () {
              Clipboard.setData(ClipboardData(text: tempCode));
              context.showSnackBar(message: 'Temp code copied to clipboard');
            },
          ),
          if (widget.showDeleteButton)
            CustomIconButton(
              icon: AppIcons.delete,
              backgroundColor: context.colorScheme.errorContainer.withValues(alpha: 0.4),
              iconColor: context.colorScheme.onErrorContainer,
              iconSize: 16.0,
              onTap: () {
                context.showConfirmationDialog(
                  title: 'Delete OTP',
                  subtitle: 'Are you sure you want to delete this OTP?',
                  subtitle2: 'This action cannot be undone.',
                  labelLeftButton: context.l10n.cancel,
                  onPressedLeftButton: (value) {
                    context.pop();
                  },
                  labelRightButton: 'Delete',
                  onPressedRightButton: (value) {
                    context.pop();
                    di<OtpRepository>().deleteOtp(id: widget.otp.id);
                  },
                );
              },
            ),
        ],
      ),
    );
  }
}
