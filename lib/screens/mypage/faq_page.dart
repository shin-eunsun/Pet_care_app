import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = [
      {'q': '로그아웃은 어떻게 하나요?', 'a': '마이페이지 하단의 [로그아웃] 버튼을 누르시면 안전하게 로그아웃 됩니다.'},
      {'q': '반품/환불은 어떻게 진행되나요?', 'a': '배송 완료 후 7일 이내에 [주문내역]에서 신청 가능하며, 단순 변심의 경우 배송비가 부과될 수 있습니다.'},
      {'q': '쿠폰은 어떻게 사용하나요?', 'a': '결제 화면의 [쿠폰 선택] 메뉴에서 보유하신 쿠폰을 적용하여 할인받으실 수 있습니다.'},
      {'q': '포인트 유효기간이 궁금해요.', 'a': '적립일로부터 1년간 유효하며, 소멸 30일 전 알림을 통해 안내해 드립니다.'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('자주 묻는 질문'), backgroundColor: Colors.white),
      body: ListView.builder(
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text('Q. ${faqs[index]['q']}', style: const TextStyle(fontWeight: FontWeight.w500)),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(faqs[index]['a']!, style: TextStyle(color: Colors.grey[700])),
              ),
            ],
          );
        },
      ),
    );
  }
}