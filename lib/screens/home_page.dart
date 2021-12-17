import 'dart:io';

import 'package:blog_app/model/post_model.dart';
import 'package:blog_app/screens/post_detail_page.dart';
import 'package:blog_app/screens/upload_blog_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<PostModel> postModelList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog App'),
      ),
      body: SafeArea(
        child: postModelList.isEmpty
            ? const Center(
                child: Text('No any blog post'),
              )
            : ListView.builder(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 40),
                itemCount: postModelList.length,
                itemBuilder: (context, index) {
                  final PostModel postModel = postModelList[index];
                  return _buildSingleBlogSection(context, postModel);
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        // heroTag: 'addBlog',
        // tooltip: 'Add Blog',
        onPressed: () async {
          final PostModel? postModel = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const UploadBlogPage(),
            ),
          );

          if (postModel != null) {
            setState(() {
              postModelList.add(postModel);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSingleBlogSection(BuildContext context, PostModel postModel) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PostDetailPage(postModel: postModel),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.black12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: postModel.title.replaceAll(" ", ""),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.file(
                  File(postModel.image.path!),
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                postModel.title,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(
                postModel.description ?? "",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
