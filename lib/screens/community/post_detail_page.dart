// lib/screens/community/community_detail_page.dart
import 'package:flutter/material.dart';
import '../../models.dart';

class CommunityDetailPage extends StatefulWidget {
  final Post post;
  const CommunityDetailPage({super.key, required this.post});

  @override
  State<CommunityDetailPage> createState() => _CommunityDetailPageState();
}

class _CommunityDetailPageState extends State<CommunityDetailPage> {
  final TextEditingController _commentController = TextEditingController();

  void _addComment() {
    if (_commentController.text.trim().isNotEmpty) {
      setState(() {
        // 📌 Post 객체 내부의 comments 리스트에 데이터를 추가합니다.
        widget.post.comments.add(_commentController.text.trim());
        _commentController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: const Text('소통하기', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0.5
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(widget.post.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(widget.post.content, style: const TextStyle(fontSize: 16)),
                const Divider(height: 40),
                const Text('댓글', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                // 📌 widget.post.comments를 출력합니다.
                ...widget.post.comments.map((c) => ListTile(
                    leading: const Icon(Icons.pets, color: Colors.orange),
                    title: Text(c)
                )),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.grey))),
            child: Row(
              children: [
                Expanded(child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(hintText: '댓글을 입력하세요...')
                )),
                IconButton(icon: const Icon(Icons.send, color: Colors.orange), onPressed: _addComment),
              ],
            ),
          ),
        ],
      ),
    );
  }
}