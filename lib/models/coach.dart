class Coach {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? profilePhotoUrl;
  final String bio;
  final List<String> certificates;
  final String subscriptionTier; // 'free', 'basic', 'pro', 'elite'
  final int clientLimit;
  final DateTime createdAt;
  final DateTime? lastActive;
  final Map<String, dynamic> settings;

  Coach({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profilePhotoUrl,
    this.bio = '',
    this.certificates = const [],
    this.subscriptionTier = 'free',
    this.clientLimit = 3,
    required this.createdAt,
    this.lastActive,
    this.settings = const {},
  });

  factory Coach.fromJson(Map<String, dynamic> json) {
    return Coach(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      profilePhotoUrl: json['profilePhotoUrl'],
      bio: json['bio'] ?? '',
      certificates: List<String>.from(json['certificates'] ?? []),
      subscriptionTier: json['subscriptionTier'] ?? 'free',
      clientLimit: json['clientLimit'] ?? 3,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      lastActive: json['lastActive'] != null 
          ? DateTime.parse(json['lastActive']) 
          : null,
      settings: Map<String, dynamic>.from(json['settings'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profilePhotoUrl': profilePhotoUrl,
      'bio': bio,
      'certificates': certificates,
      'subscriptionTier': subscriptionTier,
      'clientLimit': clientLimit,
      'createdAt': createdAt.toIso8601String(),
      'lastActive': lastActive?.toIso8601String(),
      'settings': settings,
    };
  }

  Coach copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? profilePhotoUrl,
    String? bio,
    List<String>? certificates,
    String? subscriptionTier,
    int? clientLimit,
    DateTime? createdAt,
    DateTime? lastActive,
    Map<String, dynamic>? settings,
  }) {
    return Coach(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      bio: bio ?? this.bio,
      certificates: certificates ?? this.certificates,
      subscriptionTier: subscriptionTier ?? this.subscriptionTier,
      clientLimit: clientLimit ?? this.clientLimit,
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActive ?? this.lastActive,
      settings: settings ?? this.settings,
    );
  }

  bool get isPremium => subscriptionTier != 'free';
  bool get canAddMoreClients => true; // Will be calculated based on current clients vs limit
}
