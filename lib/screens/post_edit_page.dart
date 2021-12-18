import 'dart:io';

import 'package:blog_app/model/post_model.dart';
import 'package:blog_app/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class PostEditPage extends StatefulWidget {
  const PostEditPage({Key? key, required this.postModel}) : super(key: key);

  final PostModel postModel;

  @override
  State<PostEditPage> createState() => _PostEditPageState();
}

class _PostEditPageState extends State<PostEditPage> {
  final GlobalKey<FormState> _editFormKey = GlobalKey<FormState>();

  bool isEditing = false;

  late bool _isChecked;
  late String title;
  late String description;
  late String image;

  PlatformFile? _platformFile;

  @override
  void initState() {
    title = widget.postModel.title;
    _isChecked = widget.postModel.isFeatured;
    description = widget.postModel.description ?? "";
    image = widget.postModel.image;
    super.initState();
  }

  Future<PlatformFile?> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      return result.files[0];
    }
    return null;
  }

  Future<void> _handleEdit(BuildContext context) async {
    if (_editFormKey.currentState!.validate()) {
      setState(() {
        isEditing = true;
      });

      String? downloadUrl;
      if (_platformFile != null) {
        downloadUrl = await FirebaseServices()
            .uploadFileToStorageAndReturnUrl(blogTitle: title.replaceAll(" ", ""), platformFile: _platformFile!);
      }

      FirebaseServices firebaseServices = FirebaseServices();

      final postModel = PostModel(
        title: title,
        description: description,
        isFeatured: _isChecked,
        image: downloadUrl ?? image,
        createdAt: DateTime.now(),
      );
      //adding post model to firebase
      await firebaseServices.updatePostModel(postId: widget.postModel.id!, postModel: postModel);
      Navigator.pop(context, postModel);
      setState(() {
        isEditing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Blog'),
      ),
      body: isEditing
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildEditProfileBtn(context),
                      const SizedBox(height: 20),
                      _buildEditFormFields(context),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
      bottomSheet: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: SizedBox(
          height: 40,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isEditing
                ? null
                : () {
                    _handleEdit(context);
                  },
            child: const Text('Edit Post'),
          ),
        ),
      ),
    );
  }

  Widget _buildEditFormFields(BuildContext context) {
    return Form(
      key: _editFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            initialValue: title,
            onChanged: (value) {
              setState(() {
                title = value;
              });
            },
            validator: (value) {
              if (value != null) {
                return value.isEmpty ? 'title can not be empty' : null;
              }
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'blog title',
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            initialValue: description,
            onChanged: (value) {
              setState(() {
                description = value;
              });
            },
            validator: (value) {
              if (value != null) {
                return value.isEmpty ? 'description can not be empty' : null;
              }
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'blog description',
            ),
            maxLines: 4,
          ),
          const SizedBox(height: 20),
          CheckboxListTile(
            title: const Text('Featured Post'),
            value: _isChecked,
            onChanged: (value) {
              setState(() {
                _isChecked = value ?? false;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEditProfileBtn(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final PlatformFile? file = await pickImage();
        setState(() {
          _platformFile = file;
        });
      },
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: Colors.teal.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
          image: _platformFile != null
              ? DecorationImage(
                  image: FileImage(
                    File(
                      _platformFile!.path!,
                    ),
                  ),
                  fit: BoxFit.cover,
                )
              : DecorationImage(image: NetworkImage(widget.postModel.image), fit: BoxFit.cover),
        ),
        child: const Center(
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(Icons.add_a_photo_outlined),
          ),
        ),
      ),
    );
  }
}
