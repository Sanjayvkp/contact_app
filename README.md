# Contacts App

A modern Flutter contacts application with Supabase backend, featuring a clean MVC architecture and Provider state management.

## Features

- 📱 **View Contacts** – List all saved contacts with name and phone number
- ➕ **Add Contact** – Add a new contact with a form (name, phone number)
- ✏️ **Edit Contact** – Edit an existing contact's info
- ❌ **Delete Contact** – Delete a contact from the list
- 🔍 **Search Contacts** – Real-time filtering by name or phone number
- ⭐️ **Favorite Contacts** – Mark/unmark a contact as favorite
- 🆕 **Recently Added** – Section or sorting by most recently added
- ⚡️ **Fast Performance** – Optimized for speed
- 🌙 **Dark Mode** – Toggle between light and dark themes

## Tech Stack

- **Frontend**: Flutter (latest stable version)
- **Backend**: Supabase
- **State Management**: Provider
- **Architecture**: MVC (Model-View-Controller)
- **Database**: PostgreSQL (via Supabase)

## Project Structure

```
lib/
├── controllers/          # Business logic and state management
│   ├── contact_controller.dart
│   └── theme_controller.dart
├── models/              # Data models
│   └── contact.dart
├── services/            # External services and API calls
│   └── supabase_service.dart
├── views/               # UI screens
│   ├── home_screen.dart
│   └── add_edit_contact_screen.dart
├── widgets/             # Reusable UI components
│   ├── contact_list_item.dart
│   ├── search_bar.dart
│   └── section_header.dart
├── theme/               # App theming
│   └── app_theme.dart
└── main.dart            # App entry point
```

## Setup Instructions

### 1. Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code
- Supabase account

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Supabase Setup

1. Create a new project at [supabase.com](https://supabase.com)
2. Go to SQL Editor and run the following SQL to create the contacts table:

```sql
-- Create contacts table
CREATE TABLE contacts (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  phone TEXT NOT NULL,
  is_favorite BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE contacts ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow all operations" ON contacts FOR ALL USING (true);
```


### 4. Run the App


### State Management with Provider
- `ContactController`: Manages contact CRUD operations and search
- `ThemeController`: Handles theme switching and persistence

### Real-time Search
- Instant filtering as you type
- Searches both name and phone number fields
- Debounced search for performance

### Favorites System
- Toggle favorite status with star icon
- Separate favorites tab
- Visual indicators for favorite contacts

### Responsive UI
- Material Design 3 components
- Dark/light theme support
- Smooth animations and transitions
- Swipe actions for quick delete

### Error Handling
- Comprehensive error handling for API calls
- User-friendly error messages
- Retry mechanisms for failed operations

## Future Enhancements

- [ ] Supabase Auth integration for user-specific contacts
- [ ] Contact image/avatar support
- [ ] Contact categories/groups
- [ ] Export/import contacts
- [ ] Contact sharing
- [ ] Offline support with local storage
- [ ] Push notifications for contact birthdays

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License.

## Support

For support, please open an issue in the GitHub repository or contact the development team.
