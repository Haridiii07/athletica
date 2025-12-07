class Plan {
  final String id;
  final String coachId;
  final String name;
  final String description;
  final String? imageUrl;
  final int duration; // in days
  final double price; // in EGP
  final List<String> features;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final String status; // 'active', 'expired', 'draft'
  final int clientCount; // number of clients using this plan
  final double successRate; // 0.0 to 1.0
  final double revenue; // total revenue from this plan

  Plan({
    required this.id,
    required this.coachId,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.duration,
    required this.price,
    this.features = const [],
    required this.createdAt,
    this.expiresAt,
    this.status = 'active',
    this.clientCount = 0,
    this.successRate = 0.0,
    this.revenue = 0.0,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['id'] ?? '',
      coachId: json['coachId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'],
      duration: json['duration'] ?? 0,
      price: (json['price'] ?? 0.0).toDouble(),
      features: List<String>.from(json['features'] ?? []),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      expiresAt: json['expiresAt'] != null 
          ? DateTime.parse(json['expiresAt']) 
          : null,
      status: json['status'] ?? 'active',
      clientCount: json['clientCount'] ?? 0,
      successRate: (json['successRate'] ?? 0.0).toDouble(),
      revenue: (json['revenue'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'coachId': coachId,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'duration': duration,
      'price': price,
      'features': features,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'status': status,
      'clientCount': clientCount,
      'successRate': successRate,
      'revenue': revenue,
    };
  }

  Plan copyWith({
    String? id,
    String? coachId,
    String? name,
    String? description,
    String? imageUrl,
    int? duration,
    double? price,
    List<String>? features,
    DateTime? createdAt,
    DateTime? expiresAt,
    String? status,
    int? clientCount,
    double? successRate,
    double? revenue,
  }) {
    return Plan(
      id: id ?? this.id,
      coachId: coachId ?? this.coachId,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      duration: duration ?? this.duration,
      price: price ?? this.price,
      features: features ?? this.features,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      status: status ?? this.status,
      clientCount: clientCount ?? this.clientCount,
      successRate: successRate ?? this.successRate,
      revenue: revenue ?? this.revenue,
    );
  }

  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);
  bool get isActive => status == 'active' && !isExpired;
  String get durationText => duration >= 7 ? '${duration ~/ 7}-week program' : '$duration-day program';
  String get priceText => '${price.toInt()} EGP';
  String get successRateText => '${(successRate * 100).toInt()}%';
  String get revenueText => '${revenue.toInt()} EGP';
  String get expiresInText {
    if (expiresAt == null) return '';
    final difference = expiresAt!.difference(DateTime.now());
    if (difference.inDays > 0) {
      return 'Expires in ${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'}';
    } else if (difference.inHours > 0) {
      return 'Expires in ${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'}';
    } else {
      return 'Expires soon';
    }
  }
}
