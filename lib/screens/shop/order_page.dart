import 'package:flutter/material.dart';
import '../../models.dart';

class OrderPage extends StatefulWidget {
  final int totalAmount; // CartPage에서 넘어오는 숫자 데이터
  const OrderPage({super.key, required this.totalAmount});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  // 결제 수단 선택 상태 (0: 카드, 1: 페이, 2: 휴대폰)
  int _selectedMethodIndex = 0;

  // 배송 메시지 상태
  String _selectedMessage = "배송 메시지를 선택해주세요.";
  final List<String> _messageList = [
    "배송 전 미리 연락바랍니다.",
    "부재 시 경비실에 맡겨주세요.",
    "문 앞에 놓아주세요.",
    "택배함에 넣어주세요.",
    "직접 입력"
  ];

  // ★ 숫자를 세 자리마다 콤마(,)가 찍힌 문자열로 변환하는 함수
  String getCommaNumber(int value) {
    String str = value.toString();
    if (str.length <= 3) return str;

    List<String> result = [];
    int count = 0;

    for (int i = str.length - 1; i >= 0; i--) {
      count++;
      result.add(str[i]);
      if (count % 3 == 0 && i != 0) {
        result.add(',');
      }
    }
    return result.reversed.join();
  }

  @override
  Widget build(BuildContext context) {
    // 빌드 시점에 콤마가 적용된 금액 문자열 생성
    final String priceText = getCommaNumber(widget.totalAmount);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('주문/결제', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- 배송 정보 섹션 ---
            _buildSection(
              "배송 정보",
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("홍길동 | 010-1234-5678", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  const Text("서울특별시 강남구 테헤란로 123 (행복아파트)", style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: _showDeliveryPicker,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_selectedMessage,
                              style: TextStyle(color: _selectedMessage.contains("선택") ? Colors.grey : Colors.black)),
                          const Icon(Icons.arrow_drop_down, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- 결제 수단 선택 섹션 ---
            _buildSection(
              "결제 수단 선택",
              Column(
                children: [
                  RadioListTile<int>(
                    title: const Text("신용/체크카드"),
                    secondary: const Icon(Icons.credit_card),
                    value: 0,
                    groupValue: _selectedMethodIndex,
                    activeColor: Colors.orange,
                    onChanged: (val) => setState(() => _selectedMethodIndex = val!),
                  ),
                  const Divider(height: 1),
                  RadioListTile<int>(
                    title: const Text("카카오페이 / 네이버페이"),
                    secondary: const Icon(Icons.account_balance_wallet),
                    value: 1,
                    groupValue: _selectedMethodIndex,
                    activeColor: Colors.orange,
                    onChanged: (val) => setState(() => _selectedMethodIndex = val!),
                  ),
                  const Divider(height: 1),
                  RadioListTile<int>(
                    title: const Text("휴대폰 결제"),
                    secondary: const Icon(Icons.phone_android),
                    value: 2,
                    groupValue: _selectedMethodIndex,
                    activeColor: Colors.orange,
                    onChanged: (val) => setState(() => _selectedMethodIndex = val!),
                  ),
                ],
              ),
            ),

            // --- 최종 결제 금액 섹션 ---
            _buildSection(
              "최종 결제 금액",
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("결제 금액", style: TextStyle(fontSize: 16)),
                  Text("$priceText원", // ★ 콤마 적용
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.orange)),
                ],
              ),
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),

      // --- 하단 고정 결제 버튼 ---
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        height: 90,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.black12)),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () => _handlePayment(priceText),
          child: Text("$priceText원 결제하기", // ★ 콤마 적용
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      ),
    );
  }

  void _showDeliveryPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _messageList.map((msg) => ListTile(
            title: Text(msg),
            onTap: () {
              setState(() => _selectedMessage = msg);
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(top: 8),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  void _handlePayment(String price) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("주문 완료"),
        content: Text("$price원 결제가 완료되었습니다."),
        actions: [
          TextButton(
            onPressed: () {
              globalCartItems.clear();
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: const Text("확인", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}