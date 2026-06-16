import 'package:flutter/material.dart';

class HealthRecordPage extends StatefulWidget {
  const HealthRecordPage({super.key});

  @override
  State<HealthRecordPage> createState() => _HealthRecordPageState();
}

class _HealthRecordPageState extends State<HealthRecordPage> {
  // 샘플 데이터 및 사용자가 작성한 기록이 담길 리스트
  final List<Map<String, String>> _records = [
    {'date': '2024-05-20', 'content': '오늘 몸무게 5.2kg 측정. 사료를 평소보다 잘 먹음.'},
    {'date': '2024-05-18', 'content': '산책 30분 완료. 대변 상태 양호.'},
  ];

  // 글 작성을 위한 컨트롤러
  final TextEditingController _contentController = TextEditingController();

  // 새로운 기록을 추가하는 함수
  void _addNewRecord() {
    if (_contentController.text.trim().isEmpty) {
      // 내용이 비어있으면 저장하지 않음
      return;
    }

    setState(() {
      _records.insert(0, {
        'date': DateTime.now().toString().split(' ')[0], // 오늘 날짜 (YYYY-MM-DD)
        'content': _contentController.text,
      });
    });

    _contentController.clear(); // 입력창 초기화
    Navigator.pop(context); // 다이얼로그 닫기

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('건강 기록이 저장되었습니다.')),
    );
  }

  // 글 작성 팝업창(다이얼로그) 호출 함수
  void _showWriteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('오늘의 건강기록 작성', style: TextStyle(fontWeight: FontWeight.bold)),
          content: TextField(
            controller: _contentController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: '반려동물의 상태, 몸무게, 식사량 등을 기록해주세요.',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              filled: true,
              fillColor: Colors.grey[100],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _contentController.clear();
                Navigator.pop(context);
              },
              child: const Text('취소', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: _addNewRecord,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('저장하기', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('건강 기록', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: _records.isEmpty
          ? const Center(child: Text('작성된 기록이 없습니다.\n첫 기록을 남겨보세요!', textAlign: TextAlign.center))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _records.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _records[index]['date']!,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 16),
                      ),
                      const Icon(Icons.edit_note, color: Colors.grey, size: 20),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _records[index]['content']!,
                    style: const TextStyle(fontSize: 15, height: 1.5),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      // 기록 추가 버튼
      floatingActionButton: FloatingActionButton(
        onPressed: _showWriteDialog,
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}