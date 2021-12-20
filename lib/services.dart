import 'dart:io';

import 'package:blog_app/model/post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';

class FirebaseServices {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //firebase auth instance
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //AUTH SERVICES
  Future<bool> loginWithEmail({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (err) {
      debugPrint("Error login:$err");
      return false;
    }
  }

  //signup
  Future<bool> registerWithEmail({required String email, required String password, required String username}) async {
    try {
      final UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'username': username,
        'email': userCredential.user?.email,
      });
      return true;
    } catch (err) {
      debugPrint("Error signup:$err");
      return false;
    }
  }

  //for storing post model to firebase
  Future<void> storePostModelToFirebase({required PostModel postModel}) async {
    await _firestore.collection('posts').add(
          postModel.toMap(),
        );
  }

  Future<List<PostModel>> getListOfPostsFromFirebase() async {
    final postCollection = _firestore.collection('posts');
    return postCollection.orderBy('createdAt', descending: true).get().then((querySnap) {
      return querySnap.docs.map((queryDocSnaps) {
        final Map<String, dynamic> mapData = queryDocSnaps.data();
        mapData.putIfAbsent('id', () => queryDocSnaps.id);
        return PostModel.fromMap(mapData);
      }).toList();
    });
  }

  //for updating post model to firebase
  Future<void> updatePostModel({required String postId, required PostModel postModel}) async {
    await _firestore.collection('posts').doc(postId).update(
          postModel.toMap(),
        );
  }

  //for deleting post model to firebase
  Future<void> deletePostModel({required String postId}) async {
    await _firestore.collection('posts').doc(postId).delete();
  }

  //for uploading image to firebase storage
  Future<String?> uploadFileToStorageAndReturnUrl({
    required String blogTitle,
    required PlatformFile platformFile,
  }) async {
    try {
      final String imagePath = 'images/${blogTitle.replaceAll(" ", "")}.${platformFile.extension}';
      final Reference reference = _firebaseStorage.ref().child(imagePath);
      final UploadTask uploadTask = reference.putFile(File(platformFile.path!));
      final downloadUrl = await uploadTask.then((result) => result.ref.getDownloadURL());
      return downloadUrl;
    } catch (err) {
      debugPrint("Error during image upload :$err");
    }
  }
}
