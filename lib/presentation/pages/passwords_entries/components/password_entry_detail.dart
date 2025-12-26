import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/extensions/string_extension.dart';
import 'package:custos/core/utils/app_spacing.dart';
import 'package:custos/data/models/password_entry/password_entry_entity.dart';
import 'package:custos/data/repositories/password_entry/password_entry_repository.dart';
import 'package:custos/di_container.dart';
import 'package:custos/presentation/components/custom_badge.dart';
import 'package:custos/presentation/components/custom_button.dart';
import 'package:custos/presentation/components/custom_icon_button.dart';
import 'package:custos/routes/routes.dart';
import 'package:custos/core/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class PasswordEntryDetail extends StatefulWidget {
  const PasswordEntryDetail({super.key, required this.passwordEntry});

  final PasswordEntryEntity passwordEntry;

  @override
  State<PasswordEntryDetail> createState() => _PasswordEntryDetailState();
}

class _PasswordEntryDetailState extends State<PasswordEntryDetail> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.passwordEntry.name, style: context.textTheme.titleMedium),
        Row(
          spacing: context.lg,
          children: [
            if (widget.passwordEntry.group != null)
              CustomBadge(
                icon: widget.passwordEntry.group!.icon,
                text: widget.passwordEntry.group!.name,
                color: widget.passwordEntry.group!.color,
                height: 38,
                corner: context.corner() * 0.6,
              ),

            const Spacer(),

            CustomButton(
              type: CustomTextButtonEnum.filled,
              label: context.l10n.edit,
              onPressed: () {
                context.pop();
                context.push(
                  UpsertPasswordEntryRoute(
                    id: widget.passwordEntry.id,
                  ).location,
                );
              },
            ),
            CustomIconButton(
              icon: AppIcons.delete,
              backgroundColor: context.colorScheme.errorContainer,
              iconColor: context.colorScheme.onErrorContainer,
              iconSize: 24.0,
              onTap: () {
                context.showConfirmationDialog(
                  title: context.l10n.confirmDeletePasswordEntryTitle,
                  labelLeftButton: context.l10n.cancel,
                  onPressedLeftButton: (value) {
                    context.pop();
                  },
                  labelRightButton: context.l10n.delete,
                  onPressedRightButton: (value) {
                    context
                      ..pop()
                      ..pop();
                    di<PasswordEntryRepository>().deletePasswordEntry(
                      id: widget.passwordEntry.id,
                    );
                  },
                );
              },
            ),
          ],
        ),
        if (widget.passwordEntry.url.isNotNullAndNotEmpty)
          _infoItem(
            context,
            label: context.l10n.fieldUrl,
            data: widget.passwordEntry.url!,
          ),
        if (widget.passwordEntry.username.isNotNullAndNotEmpty)
          _infoItem(
            context,
            label: context.l10n.fieldUsername,
            data: widget.passwordEntry.username!,
          ),
        if (widget.passwordEntry.email.isNotNullAndNotEmpty)
          _infoItem(
            context,
            label: context.l10n.fieldEmail,
            data: widget.passwordEntry.email!,
          ),
        if (widget.passwordEntry.phone.isNotNullAndNotEmpty)
          _infoItem(
            context,
            label: context.l10n.fieldPhone,
            data: widget.passwordEntry.phone!,
          ),
        _infoItem(
          context,
          label: context.l10n.fieldPassword,
          data: widget.passwordEntry.password,
          enableCopy: true,
          occultData: true,
        ),
        if (widget.passwordEntry.note.isNotNullAndNotEmpty)
          _infoItem(
            context,
            label: context.l10n.fieldNote,
            data: widget.passwordEntry.note!,
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
      ],
    );
  }

  Widget _infoItem(
    BuildContext context, {
    required String label,
    required String data,
    bool enableCopy = false,
    bool occultData = false,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    Widget actionIcon({required IconData icon, required VoidCallback onTap}) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(context.sm),
          child: Icon(icon, color: context.colorScheme.secondary),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Expanded(
            child: Text(
              label,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              (occultData && !_isPasswordVisible) ? data.masked : data,
              style: context.textTheme.labelLarge,
              textAlign: TextAlign.right,
            ),
          ),
          if (occultData || enableCopy) ...[
            SizedBox(width: context.m),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (occultData)
                  actionIcon(
                    icon:
                        _isPasswordVisible
                            ? AppIcons.visibilityOn
                            : AppIcons.visibilityOff,
                    onTap: () {
                      setState(() => _isPasswordVisible = !_isPasswordVisible);
                    },
                  ),
                if (enableCopy)
                  actionIcon(
                    icon: AppIcons.copy,
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: data));
                      context.showSnackBar(
                        message: context.l10n.passwordCopiedToClipboard,
                      );
                    },
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
