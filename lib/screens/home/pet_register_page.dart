// lib/screens/home/pet_register_page.dart
import 'package:flutter/material.dart';
import '../../models.dart'; // 모델 파일을 상대 경로로 가져옵니다.

class PetRegisterPage extends StatefulWidget {
  const PetRegisterPage({super.key});

  @override
  State<PetRegisterPage> createState() => _PetRegisterPageState();
}

class _PetRegisterPageState extends State<PetRegisterPage> {
  // 여기에 등록 로직(TextEditingController 등)을 추가하세요.

  // 💡 메인 화면으로 안전하게 돌아가는 함수
  void _navigateToMain() {
    // Navigator.pushAndRemoveUntil을 사용하여 현재 화면을 닫고 메인으로 이동합니다.
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    // 💡 반려동물 등록 화면 UI
    return Scaffold(
      appBar: AppBar(
        title: const Text('반려동물 등록'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('반려동물 정보를 입력하세요.'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 197번째 줄 근처의 동작: 등록 완료 후 메인으로 이동
                _navigateToMain();
              },
              child: const Text('등록 완료'),
            ),
          ],
        ),
      ),
    );
  }
}