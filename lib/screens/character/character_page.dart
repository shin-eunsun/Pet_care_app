// lib/screens/character/character_page.dart

import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
// ❗ 서버 통신을 위해 http 패키지가 필요합니다.
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class CharacterPage extends StatefulWidget {
  const CharacterPage({super.key});

  @override
  State<CharacterPage> createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {
  // ✅ ✅ ✅ USB 실제 폰 + adb reverse 기준 "최종 확정 주소"
  // ❗ 서버가 반드시 이 주소(http://127.0.0.1:8000)에서 실행 중이어야 합니다.
  static const String baseUrl = "http://127.0.0.1:8000";

  File? _selectedImage;
  String? _convertedImageUrl;
  bool _isConverting = false;

  // ==========================
  // ✅ 이미지 선택
  // ==========================
  Future<void> _pickImage() async {
    if (_isConverting) return;

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _convertedImageUrl = null;
      });
    }
  }

  // ==========================
  // ✅ 서버로 전송 + 변환 (FastAPI 서버로 요청)
  // ==========================
  Future<void> uploadAndTransformImage() async {
    if (_selectedImage == null || _isConverting) {
      if (_selectedImage == null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("사진을 선택해 주세요.")),
        );
      }
      return;
    }

    if (mounted) setState(() => _isConverting = true);

    final uri = Uri.parse("$baseUrl/transform");
    final request = http.MultipartRequest('POST', uri);

    try {
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          _selectedImage!.path,
        ),
      );

      final response = await request.send();
      final resBody = await response.stream.bytesToString();

      debugPrint("📄 서버 응답: $resBody");

      if (response.statusCode == 200) {
        final resultJson = jsonDecode(resBody);

        if (resultJson['success'] == true) {
          final filename = resultJson['save_filename'];

          if (mounted) {
            setState(() {
              _convertedImageUrl = "$baseUrl/converted/$filename";
            });
          }

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("✅ 변환 완료"), backgroundColor: Colors.green),
            );
          }
        } else {
          throw Exception("AI 변환 실패: ${resultJson['message'] ?? '알 수 없는 오류'}");
        }
      } else {
        throw Exception("서버 오류: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ Flutter 에러: $e");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ 서버 연결 실패 (서버가 켜져 있나요?)"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isConverting = false);
      }
    }
  }

  // ==========================
  // ✅ UI
  // ==========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI 캐릭터 변환', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        // 메인 디자인 통일성을 위해 색상을 오렌지로 변경
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey),
                ),
                child: _convertedImageUrl != null
                    ? Image.network(_convertedImageUrl!, fit: BoxFit.cover)
                    : _selectedImage != null
                    ? Image.file(_selectedImage!, fit: BoxFit.cover)
                    : const Icon(Icons.image, size: 80),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: _pickImage,
                child: const Text("사진 선택"),
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isConverting ? null : uploadAndTransformImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    disabledBackgroundColor: Colors.grey,
                  ),
                  child: Text(
                    _isConverting ? "변환 중..." : "✨ 변환하기",
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text("서버 주소: $baseUrl", style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}