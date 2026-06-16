// lib/screens/community/community_write_page.dart
import 'package:flutter/material.dart';
import '../../models.dart'; // 💡 상대 경로 유지

class CommunityWritePage extends StatefulWidget {
  const CommunityWritePage({super.key});

  @override
  State<CommunityWritePage> createState() => _CommunityWritePageState();
}

class _CommunityWritePageState extends State<CommunityWritePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDE7), // 💛 다시 돌아온 포근한 크림 옐로우 배경
      appBar: AppBar(
        title: const Text(
          '글 쓰기',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.w900, // 가장 두꺼운 폰트 적용
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFFFFFDE7),
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              // 1. 유효성 검사 (제목이나 내용이 비었을 때)
              if (_titleController.text.trim().isEmpty || _contentController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('제목과 내용을 모두 입력해 주세요. 🐾')),
                );
                return;
              }

              // 2. 작성한 데이터로 Post 객체 생성
              final newPost = Post(
                title: _titleController.text.trim(),
                content: _contentController.text.trim(),
              );

              // 3. 🛠️ [핵심] 부모 화면(CommunityPage)으로 데이터를 실어서 보냅니다!
              Navigator.pop(context, newPost);
            },
            child: const Text(
              '등록',
              style: TextStyle(
                  color: Color(0xFFFF8F00), // 강조 주황색
                  fontSize: 16,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          // 💛 감성적인 화이트 라운드 카드 레이아웃 복구
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFFE082).withOpacity(0.15),
                blurRadius: 15,
                offset: const Offset(0, 5),
              )
            ],
          ),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: '제목을 입력하세요',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFBDC3C7)
                  ),
                ),
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50)
                ),
              ),
              const Divider(color: Color(0xFFF5F5F5), thickness: 1.5),
              Expanded(
                child: TextField(
                  controller: _contentController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: '우리 반려동물에 대한 이야기를 들려주세요. 🐾',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Color(0xFFBDC3C7)),
                  ),
                  style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF566573),
                      height: 1.6
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}