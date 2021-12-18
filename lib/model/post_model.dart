import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String? id;
  final String title;
  final String image;
  final String? description;
  final bool isFeatured;
  final DateTime? createdAt;

  const PostModel({
    this.id,
    required this.title,
    required this.image,
    this.description,
    this.isFeatured = false,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'image': image,
      'description': description,
      'isFeatured': isFeatured,
      'createdAt': createdAt,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'],
      title: map['title'] as String,
      image: map['image'] as String,
      description: map['description'] as String,
      isFeatured: map['isFeatured'] as bool,
      createdAt: map['createdAt'] != null ? (map['createdAt'] as Timestamp).toDate() : map['createdAt'],
    );
  }
}
