
class User {
  final String id;
  final String email;
  final String password;
  final String role;
  final String name;
  final String city;
  final String state;
  final double latitude;
  final double longitude;
  final DateTime createdAt;
  final String location;
   String? uuid;
  User({
    required this.id,
    required this.email,
    required this.password,
    required this.role,
    required this.name,
    required this.city,
    required this.state,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
   required this.location ,
   required this.uuid
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      password: map['password'],
      role: map['role'],
      name: map['name'],
      city: map['city'],
      state: map['state'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      createdAt: map['createdAt'],
      location: map['location'],
      uuid: map['uuid']??""
    );
  }
}
