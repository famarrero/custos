import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A widget to build a list of customs list tile
class CustomTilesOptions extends StatelessWidget {
  const CustomTilesOptions({super.key, required this.tiles});

  final List<CustomSettingTile> tiles;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: tiles.length,
      itemBuilder: (context, index) {
        return tiles[index];
      },
    );
  }
}

/// Custom setting tile widget
class CustomSettingTile extends StatelessWidget {
  const CustomSettingTile({
    super.key,
    this.prefixIconSize,
    this.prefixIconColor,
    this.prefixIconSvgPath,
    this.prefixIconPath,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  final double? prefixIconSize;
  final Color? prefixIconColor;
  final String? prefixIconSvgPath;
  final IconData? prefixIconPath;
  final String title;
  final String? subtitle;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading:
          prefixIconSvgPath != null
              ? SvgPicture.asset(
                height: prefixIconSize,
                width: prefixIconSize,
                prefixIconSvgPath!,
                colorFilter:
                    prefixIconColor != null
                        ? ColorFilter.mode(prefixIconColor!, BlendMode.src)
                        : null,
              )
              : (prefixIconPath != null
                  ? Icon(
                    prefixIconPath!,
                    size: prefixIconSize,
                    color: prefixIconColor,
                  )
                  : null),
      title: Text(title, style: context.textTheme.bodyMedium),
      subtitle:
          subtitle != null
              ? Text(subtitle!, style: context.textTheme.labelSmall)
              : null,
    );
  }
}
