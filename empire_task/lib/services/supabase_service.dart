import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/contact.dart';

class SupabaseService {
  static const String _supabaseUrl = 'https://qpbofztjlqsfufrrgujt.supabase.co';
  static const String _supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFwYm9menRqbHFzZnVmcnJndWp0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY4ODE2OTEsImV4cCI6MjA3MjQ1NzY5MX0.2CaIog9xPiqz2iD6iFOr27_bHMTh9doFLy9vk5DOlyI';

  late final SupabaseClient _supabase;

  SupabaseService() {
    _supabase = Supabase.instance.client;
  }

  // Initialize Supabase
  static Future<void> initialize() async {
    await Supabase.initialize(url: _supabaseUrl, anonKey: _supabaseAnonKey);
  }

  // Get all contacts
  Future<List<Contact>> getContacts() async {
    try {
      final response = await _supabase
          .from('contacts')
          .select()
          .order('created_at', ascending: false);

      return (response as List).map((json) => Contact.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch contacts: $e');
    }
  }

  // Add new contact
  Future<Contact> addContact(Contact contact) async {
    try {
      final Map<String, dynamic> data = contact.toJson();
      data.remove('id');
      data.remove('created_at');

      final response = await _supabase
          .from('contacts')
          .insert(data)
          .select()
          .single();

      return Contact.fromJson(response);
    } catch (e) {
      throw Exception('Failed to add contact: $e');
    }
  }

  // Update contact
  Future<Contact> updateContact(Contact contact) async {
    try {
      final response = await _supabase
          .from('contacts')
          .update(contact.toJson())
          .eq('id', contact.id)
          .select()
          .single();

      return Contact.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update contact: $e');
    }
  }

  // Delete contact
  Future<void> deleteContact(String id) async {
    try {
      await _supabase.from('contacts').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete contact: $e');
    }
  }

  // Toggle favorite status
  Future<Contact> toggleFavorite(String id, bool isFavorite) async {
    try {
      final response = await _supabase
          .from('contacts')
          .update({'is_favorite': isFavorite})
          .eq('id', id)
          .select()
          .single();

      return Contact.fromJson(response);
    } catch (e) {
      throw Exception('Failed to toggle favorite: $e');
    }
  }

  // Search contacts
  Future<List<Contact>> searchContacts(String query) async {
    try {
      final response = await _supabase
          .from('contacts')
          .select()
          .or('name.ilike.%$query%,phone.ilike.%$query%')
          .order('created_at', ascending: false);

      return (response as List).map((json) => Contact.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to search contacts: $e');
    }
  }

  // Get favorite contacts
  Future<List<Contact>> getFavoriteContacts() async {
    try {
      final response = await _supabase
          .from('contacts')
          .select()
          .eq('is_favorite', true)
          .order('created_at', ascending: false);

      return (response as List).map((json) => Contact.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch favorite contacts: $e');
    }
  }

  // Get recently added contacts
  Future<List<Contact>> getRecentlyAddedContacts({int limit = 10}) async {
    try {
      final response = await _supabase
          .from('contacts')
          .select()
          .order('created_at', ascending: false)
          .limit(limit);

      return (response as List).map((json) => Contact.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch recently added contacts: $e');
    }
  }
}
