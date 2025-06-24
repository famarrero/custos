import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/extensions/string_extension.dart';
import 'package:custos/data/models/password_entry/password_entry_entity.dart';
import 'package:custos/data/repositories/password_entry/password_entry_repository.dart';
import 'package:custos/di_container.dart';
import 'package:custos/presentation/components/custom_icon_button.dart';
import 'package:custos/presentation/pages/groups/components/group_tile.dart';
import 'package:custos/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

class PasswordEntryDetail extends StatelessWidget {
  const PasswordEntryDetail({super.key, required this.passwordEntry});

  final PasswordEntryEntity passwordEntry;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8.0,
                children: [
                  Text(
                    passwordEntry.name,
                    style: context.textTheme.titleMedium,
                  ),
                  if (passwordEntry.group != null)
                    GroupTile(compact: true, group: passwordEntry.group!),
                ],
              ),
            ),
            TextButton(
              child: Text('Edit'),
              onPressed: () {
                context.pop();
                context.push(
                  UpsertPasswordEntryRoute(id: passwordEntry.id).location,
                );
              },
            ),
            CustomIconButton(
              icon: HugeIcons.strokeRoundedDelete01,
              backgroundColor: context.colorScheme.errorContainer,
              iconColor: context.colorScheme.onErrorContainer,
              iconSize: 18.0,
              onTap: () {
                context.showConfirmationDialog(
                  title: 'Are you sure you want delete this entry?',
                  labelLeftButton: 'Cancel',
                  onPressedLeftButton: (value) {
                    context.pop();
                  },
                  labelRightButton: 'Delete',
                  onPressedRightButton: (value) {
                    context
                      ..pop()
                      ..pop();
                    di<PasswordEntryRepository>().deletePasswordEntry(
                      id: passwordEntry.id,
                    );
                  },
                );
              },
            ),
          ],
        ),
        if (passwordEntry.url.isNotNullAndNotEmpty)
          _infoItem(context, label: 'Url', data: passwordEntry.url!),
        if (passwordEntry.username.isNotNullAndNotEmpty)
          _infoItem(context, label: 'Username', data: passwordEntry.username!),
        if (passwordEntry.email.isNotNullAndNotEmpty)
          _infoItem(context, label: 'Email', data: passwordEntry.email!),
        if (passwordEntry.phone.isNotNullAndNotEmpty)
          _infoItem(context, label: 'Phone', data: passwordEntry.phone!),
        _infoItem(
          context,
          label: 'Password',
          data: passwordEntry.password,
          enableCopy: true,
        ),

        if (passwordEntry.note.isNotNullAndNotEmpty)
          _infoItem(context, label: 'Note', data: passwordEntry.note!),
      ],
    );
  }

  Widget _infoItem(
    BuildContext context, {
    required String label,
    required String data,
    bool enableCopy = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
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
              data,
              style: context.textTheme.bodyMedium,
              textAlign: TextAlign.right,
            ),
          ),
          if (enableCopy) ...[
            const SizedBox(width: 8.0),
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: data));
                context.showSnackBar(message: 'Password copy to clipboard');
              },
              child: Icon(HugeIcons.strokeRoundedCopy01),
            ),
          ],
        ],
      ),
    );
  }
}
