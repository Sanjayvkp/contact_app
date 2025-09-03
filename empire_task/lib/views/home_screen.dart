import 'package:empire_task/controllers/contact_controller.dart';
import 'package:empire_task/controllers/theme_controller.dart';
import 'package:empire_task/models/contact.dart';
import 'package:empire_task/views/add_edit_contact_screen.dart';
import 'package:empire_task/widgets/contact_list_item.dart';
import 'package:empire_task/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _currentIndex = 0;
  bool _sortRecent = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ContactController>().initializeContacts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          if (_currentIndex == 0) _buildSearchAndSortRow(context),
          Expanded(
            child: _currentIndex == 0
                ? _buildContactsPage()
                : _buildFavoritesPage(),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      title: Text(
        'Contacts',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0.5,
      shadowColor: Theme.of(context).shadowColor.withOpacity(0.1),
      actions: [
        Consumer<ThemeController>(
          builder: (context, themeController, child) {
            return IconButton(
              icon: Icon(
                themeController.isDarkMode
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
                size: 24,
              ),
              onPressed: themeController.toggleTheme,
              tooltip: 'Toggle theme',
            );
          },
        ),
        IconButton(
          onPressed: () => _navigateToAddEditContact(context),
          icon: Icon(Icons.add),
        ),
      ],
    );
  }

  Widget _buildSearchAndSortRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: CustomSearchBar(
              controller: _searchController,
              onChanged: (query) {
                context.read<ContactController>().searchContacts(query);
              },
              onClear: () {
                _searchController.clear();
                context.read<ContactController>().clearSearch();
              },
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: PopupMenuButton<bool>(
              onSelected: (val) => setState(() => _sortRecent = val),
              itemBuilder: (context) => const [
                PopupMenuItem<bool>(value: false, child: Text('A–Z')),
                PopupMenuItem<bool>(value: true, child: Text('Recent')),
              ],
              child: Row(
                children: [
                  Icon(
                    Icons.sort,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _sortRecent ? 'Recent' : 'A–Z',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactsPage() {
    return Consumer<ContactController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.error.isNotEmpty) {
          return _buildErrorWidget(controller);
        }
        final items = List<Contact>.from(controller.filteredContacts)
          ..sort((a, b) {
            if (_sortRecent) {
              return b.createdAt.compareTo(a.createdAt);
            }
            return a.name.toLowerCase().compareTo(b.name.toLowerCase());
          });
        if (items.isEmpty) {
          return _buildEmptyState();
        }
        return RefreshIndicator(
          onRefresh: controller.refreshContacts,
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final c = items[index];
              return ContactListItem(
                contact: c,
                onTap: () => _navigateToAddEditContact(context, contact: c),
                onFavoriteToggle: () => controller.toggleFavorite(c.id),
                onDelete: () => controller.deleteContact(c.id),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildFavoritesPage() {
    return Consumer<ContactController>(
      builder: (context, controller, child) {
        final favorites = controller.favoriteContacts;
        if (favorites.isEmpty) {
          return _buildEmptyFavoritesState();
        }
        return RefreshIndicator(
          onRefresh: controller.refreshContacts,
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 16),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final c = favorites[index];
              return ContactListItem(
                contact: c,
                onTap: () => _navigateToAddEditContact(context, contact: c),
                onFavoriteToggle: () => controller.toggleFavorite(c.id),
                onDelete: () => controller.deleteContact(c.id),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (idx) {
            setState(() {
              _currentIndex = idx;
            });
          },
          backgroundColor: Theme.of(context).colorScheme.surface,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              activeIcon: Icon(Icons.people),
              label: 'Contacts',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star_outline),
              activeIcon: Icon(Icons.star),
              label: 'Favorites',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(ContactController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            controller.error,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          FilledButton.tonal(
            onPressed: () {
              controller.clearError();
              controller.refreshContacts();
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyFavoritesState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.star_outline_rounded,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'No favorites yet',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Mark contacts as favorites to see them here',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline_rounded,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
          ),
          Text(
            'No contacts',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateToAddEditContact(
    BuildContext context, {
    Contact? contact,
  }) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditContactScreen(contact: contact),
      ),
    );

    if (result['deleted'] == true) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Contact deleted successfully'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }
}
