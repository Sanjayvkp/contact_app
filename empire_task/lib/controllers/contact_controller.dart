import 'package:empire_task/services/supabase_service.dart';
import 'package:flutter/foundation.dart';
import '../models/contact.dart';

class ContactController extends ChangeNotifier {
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  List<Contact> _favoriteContacts = [];
  List<Contact> _recentlyAddedContacts = [];
  bool _isLoading = false;
  String _error = '';
  String _searchQuery = '';

  // Getters
  List<Contact> get contacts => _contacts;
  List<Contact> get filteredContacts => _filteredContacts;
  List<Contact> get favoriteContacts => _favoriteContacts;
  List<Contact> get recentlyAddedContacts => _recentlyAddedContacts;
  bool get isLoading => _isLoading;
  String get error => _error;
  String get searchQuery => _searchQuery;

  Future<void> initializeContacts() async {
    await fetchContacts();
  }

  Future<void> fetchContacts() async {
    _setLoading(true);
    try {
      _contacts = await SupabaseService().getContacts();
      _filteredContacts = List.from(_contacts);
      await _updateSpecialLists();
      _error = '';
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addContact(String name, String phone) async {
    _setLoading(true);
    try {
      final newContact = Contact(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name.trim(),
        phone: phone.trim(),
        createdAt: DateTime.now(),
      );

      final addedContact = await SupabaseService().addContact(newContact);
      _contacts.insert(0, addedContact);
      _filteredContacts = List.from(_contacts);
      await _updateSpecialLists();
      _error = '';
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateContact(Contact contact) async {
    _setLoading(true);
    try {
      final updatedContact = await SupabaseService().updateContact(contact);
      final index = _contacts.indexWhere((c) => c.id == contact.id);
      if (index != -1) {
        _contacts[index] = updatedContact;
        _filteredContacts = List.from(_contacts);
        await _updateSpecialLists();
      }
      _error = '';
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteContact(String id) async {
    _setLoading(true);
    try {
      await SupabaseService().deleteContact(id);
      _contacts.removeWhere((contact) => contact.id == id);
      _filteredContacts = List.from(_contacts);
      await _updateSpecialLists();
      _error = '';
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> toggleFavorite(String id) async {
    try {
      final index = _contacts.indexWhere((c) => c.id == id);
      if (index == -1) return;

      final current = _contacts[index];
      final newFavorite = !current.isFavorite;

      _contacts[index] = current.copyWith(isFavorite: newFavorite);
      _filteredContacts = List.from(_contacts);
      await _updateSpecialLists();
      notifyListeners();

      final updatedContact = await SupabaseService().toggleFavorite(
        id,
        newFavorite,
      );

      _contacts[index] = updatedContact;
      _filteredContacts = List.from(_contacts);
      await _updateSpecialLists();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void searchContacts(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _filteredContacts = List.from(_contacts);
    } else {
      _filteredContacts = _contacts.where((contact) {
        return contact.name.toLowerCase().contains(query.toLowerCase()) ||
            contact.phone.contains(query);
      }).toList();
    }
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _filteredContacts = List.from(_contacts);
    notifyListeners();
  }

  Future<void> _updateSpecialLists() async {
    try {
      _favoriteContacts = _contacts
          .where((contact) => contact.isFavorite)
          .toList();
      _recentlyAddedContacts = _contacts.take(10).toList();
    } catch (e) {
      _error = e.toString();
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }

  Future<void> refreshContacts() async {
    await fetchContacts();
  }

  void clearAllContacts() {
    _contacts.clear();
    _filteredContacts.clear();
    _favoriteContacts.clear();
    _recentlyAddedContacts.clear();
    notifyListeners();
  }
}
