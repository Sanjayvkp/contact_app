class Contact {
  final String id;
  final String name;
  final String phone;
  final bool isFavorite;
  final DateTime createdAt;

  Contact({
    required this.id,
    required this.name,
    required this.phone,
    this.isFavorite = false,
    required this.createdAt,
  });

  Contact copyWith({
    String? id,
    String? name,
    String? phone,
    bool? isFavorite,
    DateTime? createdAt,
  }) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'is_favorite': isFavorite,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      isFavorite: json['is_favorite'] ?? false,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  String get initials {
    if (name.isEmpty) return '';
    final nameParts = name.trim().split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }
}
