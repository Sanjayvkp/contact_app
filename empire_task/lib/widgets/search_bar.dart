import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Search contacts...',
        prefixIcon: Icon(
          Icons.search_rounded,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: Icon(
                  Icons.clear_rounded,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                onPressed: onClear,
                tooltip: 'Clear search',
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        constraints: const BoxConstraints(minHeight: 48),
      ),
      textInputAction: TextInputAction.search,
      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
    );
  }
}
