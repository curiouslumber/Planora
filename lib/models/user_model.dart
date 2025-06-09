import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String uid;
  final String displayName;
  final String? profilePicUrl;
  final String email;
  final String? phoneNumber;
  final String loginType;

  // Constructor
  const UserModel({
    required this.uid,
    required this.displayName,
    this.profilePicUrl,
    required this.email,
    this.phoneNumber,
    required this.loginType,
  });

  // From Firestore
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      displayName: data['displayName'] ?? '',
      profilePicUrl: data['profilePicUrl'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      loginType: data['loginType'] ?? '',
    );
  }

  // To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      "displayName": displayName,
      "profilePicUrl": profilePicUrl,
      "email": email,
      "phoneNumber": phoneNumber,
      "loginType": loginType,
    };
  }

  // Copy With
  UserModel copyWith({
    String? uid,
    String? displayName,
    String? profilePicUrl,
    String? email,
    String? phoneNumber,
    String? loginType,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      loginType: loginType ?? this.loginType,
    );
  }

  // Equatable Props
  @override
  List<Object?> get props => [
    uid,
    displayName,
    profilePicUrl,
    email,
    phoneNumber,
    loginType,
  ];
}
