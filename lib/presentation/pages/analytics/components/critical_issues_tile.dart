import 'package:custos/core/extensions/build_context_extension.dart';
import 'package:custos/core/utils/app_spacing.dart';
import 'package:custos/presentation/components/custom_container.dart';
import 'package:flutter/material.dart';

class CriticalIssueTile extends StatelessWidget {
  const CriticalIssueTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(context.xxl),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(context.corner()),
                ),
                child: Icon(icon, color: color),
              ),
              SizedBox(width: context.xl),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.textTheme.titleSmall),
                  Text(subtitle, style: context.textTheme.bodySmall),
                ],
              ),
              const Spacer(),
              Icon(Icons.arrow_forward_ios, color: color),
            ],
          ),
        ),
      ),
    );
  }
}
