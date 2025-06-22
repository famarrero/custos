import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A widget to build a list of customs list tile
class CustomTilesOptions extends StatelessWidget {
  const CustomTilesOptions({
    super.key,
    required this.tiles,
    this.style,
    this.prefixIconSize = 22.0,
    this.prefixIconColor,
    this.padding,
  });

  final List<CustomTile> tiles;
  final TextStyle? style;
  final double prefixIconSize;
  final Color? prefixIconColor;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: tiles.length,
      itemBuilder: (context, index) {
        final tile = tiles[index];
        return Column(
          children: [
            ListTile(
              // shape: RoundedRectangleBorder(
              //   borderRadius: BorderRadius.only(
              //     topLeft:
              //         index == 0
              //             ? const Radius.circular(14.0)
              //             : const Radius.circular(0.0),
              //     topRight:
              //         index == 0
              //             ? const Radius.circular(14.0)
              //             : const Radius.circular(0.0),
              //     bottomLeft:
              //         index == tiles.length - 1
              //             ? const Radius.circular(14.0)
              //             : const Radius.circular(0.0),
              //     bottomRight:
              //         index == tiles.length - 1
              //             ? const Radius.circular(14.0)
              //             : const Radius.circular(0.0),
              //   ),
              // ),
              onTap: tile.onTap,
              leading:
                  tile.prefixIconSvgPath != null
                      ? SvgPicture.asset(
                        height: prefixIconSize,
                        width: prefixIconSize,
                        tile.prefixIconSvgPath!,
                        colorFilter:
                            prefixIconColor != null
                                ? ColorFilter.mode(
                                  prefixIconColor!,
                                  BlendMode.src,
                                )
                                : null,
                      )
                      : (tile.prefixIconPath != null
                          ? Icon(
                            tile.prefixIconPath!,
                            size: prefixIconSize,
                            color: prefixIconColor,
                          )
                          : null),
              title: Text(
                tile.title,
                style: style ?? context.textTheme.bodyMedium,
              ),
              subtitle:
                  tile.subtitle != null
                      ? Text(
                        tile.subtitle!,
                        style: context.textTheme.labelSmall,
                      )
                      : null,
            ),
          ],
        );
      },
    );
  }
}

/// Custom list tile object
class CustomTile {
  const CustomTile({
    this.prefixIconSvgPath,
    this.prefixIconPath,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  final String? prefixIconSvgPath;
  final IconData? prefixIconPath;
  final String title;
  final String? subtitle;
  final Function() onTap;
}
