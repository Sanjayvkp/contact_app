import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final String? actionText;

  const SectionHeader({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const Spacer(),
          if (onTap != null && actionText != null)
            TextButton(
              onPressed: onTap,
              child: Text(actionText!),
            ),
        ],
      ),
    );
  }
}
