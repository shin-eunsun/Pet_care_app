import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 저장소 임포트
import '../../main.dart';

class PetRegistrationPage extends StatefulWidget {
  const PetRegistrationPage({super.key});

  @override
  State<PetRegistrationPage> createState() => _PetRegistrationPageState();
}

class _PetRegistrationPageState extends State<PetRegistrationPage> {
  final TextEditingController _nameController = TextEditingController();
  String _selectedType = '강아지';

  // ★ 펫 정보 저장 및 메인 이동
  Future<void> _savePetAndNavigate() async {
    final prefs = await SharedPreferences.getInstance();

    // 선택된 펫 종류 저장 (예방접종 페이지에서 이 값을 읽음)
    await prefs.setString('petType', _selectedType);
    await prefs.setString('petName', _nameController.text.trim());

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0, backgroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () async {
              // 건너뛰기 시에는 petType을 'none'으로 설정
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('petType', 'none');
              _savePetAndNavigate();
            },
            child: const Text('건너뛰기', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('반려동물 정보를\n등록해 주세요! 🐾', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            const Text('아이의 이름', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: _nameController, decoration: const InputDecoration(hintText: '이름 입력')),
            const SizedBox(height: 30),
            const Text('아이의 종류', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                _buildTypeChip('강아지'), const SizedBox(width: 10),
                _buildTypeChip('고양이'), const SizedBox(width: 10),
                _buildTypeChip('기타'),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _savePetAndNavigate,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, padding: const EdgeInsets.symmetric(vertical: 16)),
                child: const Text('등록 완료', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeChip(String type) {
    bool isSelected = _selectedType == type;
    return ChoiceChip(
      label: Text(type),
      selected: isSelected,
      onSelected: (val) => setState(() => _selectedType = type),
      selectedColor: Colors.orange.withOpacity(0.2),
    );
  }
}