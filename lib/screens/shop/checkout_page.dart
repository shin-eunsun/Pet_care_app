// lib/screens/shop/checkout_page.dart
import 'package:flutter/material.dart';
import '../../models.dart'; // 💡 상대 경로로 확실하게 연결

class CheckoutPage extends StatefulWidget {
  final Map<Product, int> orderItems;
  final int totalPrice;

  const CheckoutPage({
    super.key,
    required this.orderItems,
    required this.totalPrice
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _addressController = TextEditingController();

  // 💡 패키지 없이 플러터 자체 기능으로 주소 선택 창을 띄우는 함수
  void _showAddressPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '자주 쓰는 배송지 선택',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.home, color: Colors.orange),
                      title: const Text('우리집'),
                      subtitle: const Text('서울특별시 강남구 테헤란로 123'),
                      onTap: () {
                        setState(() {
                          _addressController.text = 'An 주소: 서울특별시 강남구 테헤란로 123';
                        });
                        Navigator.pop(context);
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.work, color: Colors.blue),
                      title: const Text('회사 / 학교'),
                      subtitle: const Text('경기도 성남시 분당구 판교역로 456'),
                      onTap: () {
                        setState(() {
                          _addressController.text = '회사 주소: 경기도 성남시 분당구 판교역로 456';
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('주문 / 결제', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('배송지 정보', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _addressController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      hintText: '주소를 선택해 주세요',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _showAddressPicker, // 💡 버튼 누르면 자체 주소창이 열립니다!
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                  ),
                  child: const Text('주소 선택'),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text('결제 금액 정보', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              '총 결제 금액: ${widget.totalPrice}원',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              if (_addressController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('배송지 주소를 선택해 주세요.')),
                );
                return;
              }
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('결제 완료'),
                  content: const Text('성공적으로 주문이 완료되었습니다.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        globalCartItems.clear();
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text('확인'),
                    ),
                  ],
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('결제하기', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ),
      ),
    );
  }
}