import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/utils/app_spacing.dart';
import 'package:custos/presentation/app/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ImagotipoWidget extends StatelessWidget {
  const ImagotipoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SvgPicture.asset(
          Assets.svgs.keySolidFull.path,
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(context.colorScheme.primary, BlendMode.srcIn),
        ),
        SizedBox(width: context.m),
        Text(context.l10n.custos, style: context.textTheme.titleLarge?.copyWith(color: context.colorScheme.primary)),
      ],
    );
  }
}
