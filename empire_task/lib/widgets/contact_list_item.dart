import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../models/contact.dart';

class ContactListItem extends StatelessWidget {
  final Contact contact;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onDelete;

  const ContactListItem({
    super.key,
    required this.contact,
    required this.onTap,
    required this.onFavoriteToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.2,
          children: [
            SlidableAction(
              onPressed: (_) => onDelete(),
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
              icon: Icons.delete_outline_rounded,
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
          ],
        ),
        child: Material(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: _getAvatarColor(context),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        contact.initials,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contact.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          contact.phone,
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                        // const SizedBox(height: 4),
                        // Text(
                        //   'Added ${DateFormat.yMMMd().format(contact.createdAt)}',
                        //   style: TextStyle(
                        //     fontSize: 12,
                        //     color: Theme.of(
                        //       context,
                        //     ).colorScheme.onSurface.withOpacity(0.4),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      contact.isFavorite
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      color: contact.isFavorite
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    onPressed: onFavoriteToggle,
                    tooltip: contact.isFavorite
                        ? 'Remove from favorites'
                        : 'Add to favorites',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getAvatarColor(BuildContext context) {
    final colors = [
      Theme.of(context).colorScheme.primary,
      Colors.blue.shade700,
      Colors.purple.shade700,
      Colors.teal.shade700,
      Colors.orange.shade700,
    ];
    return colors[contact.name.hashCode % colors.length];
  }
}
