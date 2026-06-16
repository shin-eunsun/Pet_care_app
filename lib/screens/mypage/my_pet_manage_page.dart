import 'dart:convert'; // 데이터 저장을 위해 필수
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPetManagePage extends StatefulWidget {
  const MyPetManagePage({super.key});

  @override
  State<MyPetManagePage> createState() => _MyPetManagePageState();
}

class _MyPetManagePageState extends State<MyPetManagePage> {
  // 펫 데이터 리스트: [{'name': '뽀삐', 'type': '강아지', 'birthYear': '2020'}]
  List<Map<String, dynamic>> _pets = [];

  @override
  void initState() {
    super.initState();
    _loadPets();
  }

  // 1. 저장된 펫 불러오기
  Future<void> _loadPets() async {
    final prefs = await SharedPreferences.getInstance();
    final String? petsJson = prefs.getString('myPets');
    if (petsJson != null) {
      setState(() {
        _pets = List<Map<String, dynamic>>.from(jsonDecode(petsJson));
      });
    }
  }

  // 2. 펫 추가하기 (저장)
  Future<void> _addPet(String name, String type, String birthYear) async {
    final newPet = {'name': name, 'type': type, 'birthYear': birthYear};
    setState(() {
      _pets.add(newPet);
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('myPets', jsonEncode(_pets)); // 리스트를 JSON 문자로 변환해 저장
  }

  // 3. 펫 삭제하기
  Future<void> _deletePet(int index) async {
    setState(() {
      _pets.removeAt(index);
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('myPets', jsonEncode(_pets));
  }

  // ★ 나이 자동 계산 로직
  // (현재 연도 - 태어난 연도 + 1) -> 한국 나이 방식 (만 나이 원하면 +1 제거)
  int _calculateAge(String birthYearStr) {
    int birthYear = int.tryParse(birthYearStr) ?? DateTime.now().year;
    int currentYear = DateTime.now().year;
    return currentYear - birthYear + 1;
  }

  // 펫 추가 다이얼로그
  void _showAddDialog() {
    final nameController = TextEditingController();
    final birthController = TextEditingController();
    String selectedType = '강아지';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder( // 다이얼로그 내부 상태 변경을 위해 필요
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('반려동물 등록'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: '이름'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: birthController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: '태어난 연도 (예: 2020)'),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildChoiceChip('강아지', selectedType, (val) => setStateDialog(() => selectedType = val)),
                      const SizedBox(width: 10),
                      _buildChoiceChip('고양이', selectedType, (val) => setStateDialog(() => selectedType = val)),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('취소')),
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty && birthController.text.isNotEmpty) {
                      _addPet(nameController.text, selectedType, birthController.text);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('등록'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildChoiceChip(String label, String currentSelection, Function(String) onSelect) {
    return ChoiceChip(
      label: Text(label),
      selected: currentSelection == label,
      onSelected: (_) => onSelect(label),
      selectedColor: Colors.orange[100],
      labelStyle: TextStyle(color: currentSelection == label ? Colors.orange : Colors.black),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('우리 아이 관리'), backgroundColor: Colors.white, foregroundColor: Colors.black),
      body: _pets.isEmpty
          ? const Center(child: Text('등록된 반려동물이 없습니다.\n우측 하단 버튼을 눌러 추가해주세요!'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _pets.length,
        itemBuilder: (context, index) {
          final pet = _pets[index];
          final age = _calculateAge(pet['birthYear']);
          final icon = pet['type'] == '강아지' ? Icons.pets : Icons.cruelty_free; // 고양이는 다른 아이콘 예시

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.orange[50],
                child: Icon(icon, color: Colors.orange),
              ),
              title: Text('${pet['name']} (${age}살)', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${pet['birthYear']}년생 | ${pet['type']}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.grey),
                onPressed: () => _deletePet(index),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}