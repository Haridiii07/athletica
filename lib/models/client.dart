class Client {
  final String id;
  final String coachId;
  final String name;
  final String? profilePhotoUrl;
  final String status; // 'active', 'inactive', 'pending'
  final double subscriptionProgress; // 0.0 to 1.0
  final DateTime joinedAt;
  final DateTime? lastSession;
  final Map<String, dynamic> goals;
  final Map<String, dynamic> stats; // height, weight, etc.
  final List<Session> sessionHistory;
  final String? phone;
  final String? email;

  Client({
    required this.id,
    required this.coachId,
    required this.name,
    this.profilePhotoUrl,
    this.status = 'pending',
    this.subscriptionProgress = 0.0,
    required this.joinedAt,
    this.lastSession,
    this.goals = const {},
    this.stats = const {},
    this.sessionHistory = const [],
    this.phone,
    this.email,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'] ?? '',
      coachId: json['coachId'] ?? '',
      name: json['name'] ?? '',
      profilePhotoUrl: json['profilePhotoUrl'],
      status: json['status'] ?? 'pending',
      subscriptionProgress: (json['subscriptionProgress'] ?? 0.0).toDouble(),
      joinedAt: DateTime.parse(json['joinedAt'] ?? DateTime.now().toIso8601String()),
      lastSession: json['lastSession'] != null 
          ? DateTime.parse(json['lastSession']) 
          : null,
      goals: Map<String, dynamic>.from(json['goals'] ?? {}),
      stats: Map<String, dynamic>.from(json['stats'] ?? {}),
      sessionHistory: (json['sessionHistory'] as List<dynamic>?)
          ?.map((session) => Session.fromJson(session))
          .toList() ?? [],
      phone: json['phone'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'coachId': coachId,
      'name': name,
      'profilePhotoUrl': profilePhotoUrl,
      'status': status,
      'subscriptionProgress': subscriptionProgress,
      'joinedAt': joinedAt.toIso8601String(),
      'lastSession': lastSession?.toIso8601String(),
      'goals': goals,
      'stats': stats,
      'sessionHistory': sessionHistory.map((session) => session.toJson()).toList(),
      'phone': phone,
      'email': email,
    };
  }

  Client copyWith({
    String? id,
    String? coachId,
    String? name,
    String? profilePhotoUrl,
    String? status,
    double? subscriptionProgress,
    DateTime? joinedAt,
    DateTime? lastSession,
    Map<String, dynamic>? goals,
    Map<String, dynamic>? stats,
    List<Session>? sessionHistory,
    String? phone,
    String? email,
  }) {
    return Client(
      id: id ?? this.id,
      coachId: coachId ?? this.coachId,
      name: name ?? this.name,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      status: status ?? this.status,
      subscriptionProgress: subscriptionProgress ?? this.subscriptionProgress,
      joinedAt: joinedAt ?? this.joinedAt,
      lastSession: lastSession ?? this.lastSession,
      goals: goals ?? this.goals,
      stats: stats ?? this.stats,
      sessionHistory: sessionHistory ?? this.sessionHistory,
      phone: phone ?? this.phone,
      email: email ?? this.email,
    );
  }

  bool get isActive => status == 'active';
  bool get isPending => status == 'pending';
  String get subscriptionStatus => '${(subscriptionProgress * 100).toInt()}%';
  String get timeSinceJoined {
    final difference = DateTime.now().difference(joinedAt);
    if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'month' : 'months'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else {
      return 'Just joined';
    }
  }
}

class Session {
  final String id;
  final String name;
  final String type;
  final DateTime date;
  final Map<String, dynamic> data;

  Session({
    required this.id,
    required this.name,
    required this.type,
    required this.date,
    this.data = const {},
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      data: Map<String, dynamic>.from(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'date': date.toIso8601String(),
      'data': data,
    };
  }
}
