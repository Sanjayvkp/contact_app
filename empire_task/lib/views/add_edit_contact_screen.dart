import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../controllers/contact_controller.dart';
import '../models/contact.dart';

class AddEditContactScreen extends StatefulWidget {
  final Contact? contact;

  const AddEditContactScreen({super.key, this.contact});

  @override
  State<AddEditContactScreen> createState() => _AddEditContactScreenState();
}

class _AddEditContactScreenState extends State<AddEditContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      _nameController.text = widget.contact!.name;
      _phoneController.text = widget.contact!.phone;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.contact != null;
    final controller = context.watch<ContactController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Contact' : 'Add Contact',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.5,
        shadowColor: Theme.of(context).shadowColor.withOpacity(0.1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (isEditing)
            IconButton(
              icon: Icon(
                Icons.delete_outline_rounded,
                color: Theme.of(context).colorScheme.error,
              ),
              onPressed: _showDeleteDialog,
              tooltip: 'Delete Contact',
            ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Avatar/Initials
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: _getAvatarColor(context),
                      shape: BoxShape.circle,
                    ),
                    child: ValueListenableBuilder<TextEditingValue>(
                      valueListenable: _nameController,
                      builder: (_, value, __) {
                        final initials = _getInitials(value.text);
                        return Center(
                          child: Text(
                            initials,
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 32),
                Text(
                  'Contact Details',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    hintText: 'Enter full name',
                    prefixIcon: Icon(
                      Icons.person_outline_rounded,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceVariant,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a name';
                    }
                    if (value.trim().length < 2) {
                      return 'Name must be at least 2 characters';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _phoneController,
                  maxLength: 10,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    hintText: 'Enter phone number',
                    prefixIcon: Icon(
                      Icons.phone_outlined,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceVariant,
                    counterText: '',
                  ),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a phone number';
                    }
                    if (value.trim().length < 10) {
                      return 'Phone number must be at least 10 digits';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.done,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),

                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: controller.isLoading ? null : _saveContact,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: controller.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          isEditing ? 'Update Contact' : 'Add Contact',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),

                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '?';
    final parts = trimmed.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return trimmed[0].toUpperCase();
  }

  Color _getAvatarColor(BuildContext context) {
    final name = _nameController.text.trim();
    if (name.isEmpty) return Theme.of(context).colorScheme.primary;

    final colors = [
      Theme.of(context).colorScheme.primary,
      Colors.blue.shade700,
      Colors.purple.shade700,
      Colors.teal.shade700,
      Colors.orange.shade700,
    ];
    return colors[name.hashCode % colors.length];
  }

  Future<void> _saveContact() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final contactController = context.read<ContactController>();
      if (widget.contact != null) {
        final updatedContact = widget.contact!.copyWith(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
        );
        await contactController.updateContact(updatedContact);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Contact updated successfully'),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
          Navigator.pop(context, {'updated': true});
        }
      } else {
        await contactController.addContact(
          _nameController.text.trim(),
          _phoneController.text.trim(),
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Contact added successfully'),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
          Navigator.pop(context, {'added': true});
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delete Contact',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Text(
                  'Are you sure you want to delete ${widget.contact!.name}? This action cannot be undone.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(
                          context,
                        ).colorScheme.onSurface,
                      ),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton.tonal(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        try {
                          await context.read<ContactController>().deleteContact(
                            widget.contact!.id,
                          );
                          if (mounted) {
                            Navigator.pop(this.context, {'deleted': true});
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(this.context).showSnackBar(
                              SnackBar(
                                content: Text('Error: ${e.toString()}'),
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.error,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            );
                          }
                        }
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.error,
                        foregroundColor: Theme.of(context).colorScheme.onError,
                      ),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
