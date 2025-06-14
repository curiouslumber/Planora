import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ImageModel extends Equatable {
  final String uid;
  final String imagePrompt;
  final String imageVectorizedData;
  final String imageLink;

  // Constructor
  const ImageModel({
    required this.uid,
    required this.imagePrompt,
    required this.imageVectorizedData,
    required this.imageLink,
  });

  // From Firestore
  factory ImageModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return ImageModel(
      uid: doc.id,
      imagePrompt: data['imagePrompt'] ?? '',
      imageVectorizedData: data['imageVectorizedData'] ?? '',
      imageLink: data['imageLink'] ?? '',
    );
  }

  // To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      "imagePrompt": imagePrompt,
      "imageVectorizedData": imageVectorizedData,
      "imageLink": imageLink,
    };
  }

  // Copy With
  ImageModel copyWith({
    String? uid,
    String? imagePrompt,
    String? imageVectorizedData,
    String? imageLink,
  }) {
    return ImageModel(
      uid: uid ?? this.uid,
      imagePrompt: imagePrompt ?? this.imagePrompt,
      imageVectorizedData: imageVectorizedData ?? this.imageVectorizedData,
      imageLink: imageLink ?? this.imageLink,
    );
  }

  // Equatable Props
  @override
  List<Object?> get props => [uid, imagePrompt, imageVectorizedData, imageLink];
}
