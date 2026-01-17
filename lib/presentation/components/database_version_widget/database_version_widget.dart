import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/presentation/components/database_version_widget/cubit/database_version_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DatabaseVersionWidget extends StatelessWidget {
  const DatabaseVersionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DatabaseVersionCubit()..getDatabaseVersion(),
      child: BlocBuilder<DatabaseVersionCubit, DatabaseVersionState>(
        builder: (context, state) {
          if (state.versionState.isData) {
            return Text(
              'Data base version: ${state.versionState.dataOrNull}',
              style: context.textTheme.labelMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
