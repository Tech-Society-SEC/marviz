import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a MARVIZ AI rider's profile.
///
/// Stored in Firestore at: users/{uid}
class UserModel {
  final String uid;
  final String email;
  final String name;
  final int age;
  final String phone;

  // Bike info
  final String bikeName;
  final double bikeMileage;        // km/L
  final double fuelTankCapacity;   // liters

  // Metadata
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final String? profilePhotoUrl;

  // Future stats (defaulted to 0 for new users)
  final int totalRides;
  final double totalDistanceKm;
  final int ridePoints;

  const UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.age,
    required this.phone,
    required this.bikeName,
    required this.bikeMileage,
    required this.fuelTankCapacity,
    required this.createdAt,
    this.lastLoginAt,
    this.profilePhotoUrl,
    this.totalRides = 0,
    this.totalDistanceKm = 0.0,
    this.ridePoints = 0,
  });

  /// Converts this model to a Firestore-compatible map.
  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'age': age,
      'phone': phone,
      'bikeName': bikeName,
      'bikeMileage': bikeMileage,
      'fuelTankCapacity': fuelTankCapacity,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastLoginAt': lastLoginAt != null ? Timestamp.fromDate(lastLoginAt!) : null,
      'profilePhotoUrl': profilePhotoUrl,
      'totalRides': totalRides,
      'totalDistanceKm': totalDistanceKm,
      'ridePoints': ridePoints,
    };
  }

  /// Builds a UserModel from a Firestore document snapshot.
  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw Exception('User document is empty');
    }

    return UserModel(
      uid: data['uid'] as String,
      email: data['email'] as String,
      name: data['name'] as String,
      age: (data['age'] as num).toInt(),
      phone: data['phone'] as String,
      bikeName: data['bikeName'] as String,
      bikeMileage: (data['bikeMileage'] as num).toDouble(),
      fuelTankCapacity: (data['fuelTankCapacity'] as num).toDouble(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastLoginAt: (data['lastLoginAt'] as Timestamp?)?.toDate(),
      profilePhotoUrl: data['profilePhotoUrl'] as String?,
      totalRides: (data['totalRides'] as num?)?.toInt() ?? 0,
      totalDistanceKm: (data['totalDistanceKm'] as num?)?.toDouble() ?? 0.0,
      ridePoints: (data['ridePoints'] as num?)?.toInt() ?? 0,
    );
  }

  /// Creates a copy with some fields updated.
  UserModel copyWith({
    String? name,
    int? age,
    String? phone,
    String? bikeName,
    double? bikeMileage,
    double? fuelTankCapacity,
    String? profilePhotoUrl,
    DateTime? lastLoginAt,
    int? totalRides,
    double? totalDistanceKm,
    int? ridePoints,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      name: name ?? this.name,
      age: age ?? this.age,
      phone: phone ?? this.phone,
      bikeName: bikeName ?? this.bikeName,
      bikeMileage: bikeMileage ?? this.bikeMileage,
      fuelTankCapacity: fuelTankCapacity ?? this.fuelTankCapacity,
      createdAt: createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      totalRides: totalRides ?? this.totalRides,
      totalDistanceKm: totalDistanceKm ?? this.totalDistanceKm,
      ridePoints: ridePoints ?? this.ridePoints,
    );
  }
}