import 'package:flutter/material.dart';
import '../settings/sub_pages.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('주문 내역'), backgroundColor: Colors.white, foregroundColor: Colors.black),
      body: ListView.builder(
        itemCount: 2,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('2024.05.21 배송 완료', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                const Divider(),
                Row(
                  children: [
                    Container(width: 80, height: 80, color: Colors.grey[200], child: const Icon(Icons.pets)),
                    const SizedBox(width: 15),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('[프리미엄] 유기농 강아지 사료 2kg', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('25,000원 / 1개', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReviewWritePage())),
                    child: const Text('구매후기 작성 (최대 150P)'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}