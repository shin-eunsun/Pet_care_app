import 'package:flutter/material.dart';
import 'address_list_page.dart';

class PurchasePage extends StatefulWidget {
  const PurchasePage({super.key});

  @override
  State<PurchasePage> createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  Map<String, String> _selectedAddress = {
    'name': '홍길동',
    'phone': '010-1234-5678',
    'address': '서울시 강남구 테헤란로 123',
    'detail': '101동 101호',
  };

  // ★ 결제 수단 선택 상태 관리
  String _selectedPaymentMethod = "신용카드";
  final List<Map<String, dynamic>> _methods = [
    {'name': '신용카드', 'icon': Icons.credit_card},
    {'name': '계좌이체', 'icon': Icons.account_balance},
    {'name': '카카오페이', 'icon': Icons.payment},
    {'name': '휴대폰결제', 'icon': Icons.smartphone},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('주문/결제')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 배송지 섹션 (이전과 동일)
            const Text('배송지', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_selectedAddress['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('${_selectedAddress['address']}'),
                    ],
                  ),
                  TextButton(
                    onPressed: () async {
                      final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddressListPage()));
                      if (result != null) setState(() => _selectedAddress = result);
                    },
                    child: const Text('변경'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ★ 결제 수단 섹션
            const Text('결제 수단', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Column(
              children: _methods.map((method) {
                return RadioListTile<String>(
                  title: Row(
                    children: [
                      Icon(method['icon'], size: 20, color: Colors.grey[700]),
                      const SizedBox(width: 10),
                      Text(method['name']),
                    ],
                  ),
                  value: method['name'],
                  groupValue: _selectedPaymentMethod, // 현재 선택된 값과 비교
                  onChanged: (val) {
                    setState(() {
                      _selectedPaymentMethod = val!; // 클릭하면 상태 업데이트!
                    });
                  },
                  activeColor: Colors.orange,
                  contentPadding: EdgeInsets.zero,
                );
              }).toList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, minimumSize: const Size(double.infinity, 60)),
        child: Text('$_selectedPaymentMethod로 결제하기', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}