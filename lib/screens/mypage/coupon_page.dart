import 'package:flutter/material.dart';

class CouponPage extends StatelessWidget {
  const CouponPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('쿠폰함'), backgroundColor: Colors.white, foregroundColor: Colors.black),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildCouponCard('10% 할인', '신규 가입 축하 쿠폰', '2024.12.31까지'),
          _buildCouponCard('무료배송', '등급 업그레이드 감사 쿠폰', '2024.06.30까지'),
        ],
      ),
    );
  }

  Widget _buildCouponCard(String discount, String title, String date) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.orange),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(discount, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange)),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const Divider(),
          Text(date, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}