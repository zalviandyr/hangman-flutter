class User {
  final String id;
  final String name;
  final int highScore;

  const User({
    required this.id,
    required this.name,
    this.highScore = 0,
  });

  factory User.fromMap(dynamic map) {
    return User(
      id: map['user_id'],
      name: map['user_name'],
      highScore: map['high_score'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': id,
      'user_name': name,
      'high_score': highScore,
    };
  }
}
