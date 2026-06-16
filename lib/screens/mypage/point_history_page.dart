import 'package:flutter/material.dart';

class PointHistoryPage extends StatelessWidget {
  const PointHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 샘플 데이터
    final List<Map<String, dynamic>> histories = [
      {'title': '구매후기 작성 적립', 'date': '2024.05.21', 'point': '+150P', 'isPlus': true},
      {'title': '상품 구매 사용', 'date': '2024.05.20', 'point': '-2,000P', 'isPlus': false},
      {'title': '신규 가입 축하 포인트', 'date': '2024.05.15', 'point': '+3,000P', 'isPlus': true},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('포인트 상세 내역'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          // 상단 총 포인트 카드
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            color: Colors.orange[50],
            child: const Column(
              children: [
                Text('사용 가능한 포인트', style: TextStyle(color: Colors.grey)),
                SizedBox(height: 10),
                Text('1,250 P', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.orange)),
              ],
            ),
          ),
          // 내역 리스트
          Expanded(
            child: ListView.builder(
              itemCount: histories.length,
              itemBuilder: (context, index) {
                final item = histories[index];
                return ListTile(
                  title: Text(item['title']),
                  subtitle: Text(item['date']),
                  trailing: Text(
                    item['point'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: item['isPlus'] ? Colors.blue : Colors.red,
                      fontSize: 16,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}