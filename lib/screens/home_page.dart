import 'package:blog_app/constants/constants.dart';
import 'package:blog_app/model/post_model.dart';
import 'package:blog_app/screens/auth_screens/login_screen.dart';
import 'package:blog_app/screens/post_detail_page.dart';
import 'package:blog_app/screens/post_edit_page.dart';
import 'package:blog_app/screens/upload_blog_page.dart';
import 'package:blog_app/services.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

AlertDialog _showAlertForLogout(BuildContext context) {
  return AlertDialog(
    title: const Text("Blog App"),
    content: const Text(
      "Are you sure to log out ?",
    ),
    actions: [
      TextButton(
        onPressed: () {
          if (SharedPrefConstant.sharedPreferences != null) {
            SharedPrefConstant.sharedPreferences?.setBool(isLoginKey, false);
          }
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const LoginScreen(),
              ),
              (Route<dynamic> route) => false);
        },
        child: const Text('Yes'),
      ),
      TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('No'),
      ),
    ],
  );
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog App'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => _showAlertForLogout(context),
                );
              },
              icon: const Icon(Icons.logout_outlined),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<List<PostModel>>(
          future: FirebaseServices().getListOfPostsFromFirebase(),
          builder: (context, snapshots) {
            final List<PostModel>? postModelList = snapshots.data;
            if (snapshots.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (postModelList != null) {
              return postModelList.isEmpty
                  ? const Center(
                      child: Text('No any blog post'),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 40),
                      itemCount: snapshots.data?.length,
                      itemBuilder: (context, index) {
                        final PostModel postModel = postModelList[index];
                        return _buildSingleBlogSection(context, postModel);
                      },
                    );
            }
            return const Center(
              child: Text('no data'),
            );
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
            setState(() {});
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSingleBlogSection(BuildContext context, PostModel postModel) {
    return GestureDetector(
      onLongPress: () async {
        final PostModel? data = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PostEditPage(postModel: postModel),
          ),
        );
        if (data != null) {
          setState(() {});
        }
      },
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
                child: Image.network(
                  postModel.image,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    postModel.title,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      FirebaseServices().deletePostModel(postId: postModel.id!);
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  )
                ],
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
