import 'package:flutter/material.dart';

class AddressAddPage extends StatefulWidget {
  const AddressAddPage({super.key});

  @override
  State<AddressAddPage> createState() => _AddressAddPageState();
}

class _AddressAddPageState extends State<AddressAddPage> {
  final _nameController = TextEditingController();
  final _addrController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('새 배송지 입력')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: '받는 사람')),
            TextField(controller: _addrController, decoration: const InputDecoration(labelText: '주소')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // ★ 입력값을 묶어서 보냅니다.
                Navigator.pop(context, {
                  'name': _nameController.text,
                  'phone': '010-0000-0000',
                  'address': _addrController.text,
                  'detail': '직접 입력한 주소',
                });
              },
              child: const Text('이 주소 사용하기'),
            ),
          ],
        ),
      ),
    );
  }
}