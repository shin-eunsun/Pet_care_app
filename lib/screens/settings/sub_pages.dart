// lib/screens/settings/sub_pages.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ★ [중요] 이 클래스가 없어서 오류가 났던 겁니다! (서브 페이지용 빈 화면)
// settings_page.dart의 _navigateToSubPage에서 사용됩니다.
class SubPage extends StatelessWidget {
  final String title;
  const SubPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.construction, size: 60, color: Colors.grey),
            const SizedBox(height: 20),
            Text("$title 화면은\n준비 중입니다.", textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}


// 1. 주문 내역 화면
class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("주문 내역", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)), backgroundColor: Colors.white, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 3,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderDetailPage())),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade200)),
              child: Row(
                children: [
                  Container(width: 60, height: 60, color: Colors.orange.shade100, child: const Icon(Icons.shopping_bag, color: Colors.orange)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("2025.05.${20 - index} 주문", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        const SizedBox(height: 4),
                        Text("프리미엄 강아지 사료 외 ${index + 1}건", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        const Text("배송완료", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// 2. 주문 상세 화면
class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("주문 상세", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)), backgroundColor: Colors.white, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("주문번호: 20250520-000123", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 20),
            _buildSection("주문한 물품", "프리미엄 사료 2kg\n오리목뼈 간식 500g"),
            const Divider(),
            _buildSection("배송 정보", "김은선\n010-1234-5678\n서울시 마포구 ..."),
            const Divider(),
            _buildSection("배송 메모", "문 앞에 놔주세요."),
            const Divider(),
            _buildSection("결제 정보", "카카오페이 35,000원"),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: () {}, child: const Text("배송조회"))),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ReviewWritePage())),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                      child: const Text("후기작성", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 8),
        Text(content, style: const TextStyle(fontSize: 15, height: 1.5)),
        const SizedBox(height: 10),
      ],
    );
  }
}

// 3. 후기 작성 화면
class ReviewWritePage extends StatefulWidget {
  const ReviewWritePage({super.key});

  @override
  State<ReviewWritePage> createState() => _ReviewWritePageState();
}

class _ReviewWritePageState extends State<ReviewWritePage> {
  final _textController = TextEditingController();

  Future<void> _submitReview() async {
    if (_textController.text.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    int currentPoints = prefs.getInt('user_points') ?? 0;
    await prefs.setInt('user_points', currentPoints + 100);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("후기 작성 완료! 100P가 지급되었습니다. 🎉"), backgroundColor: Colors.green));
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("후기 작성"), backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("상품은 어떠셨나요?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(
              controller: _textController,
              maxLines: 5,
              decoration: const InputDecoration(hintText: "솔직한 후기를 남겨주세요. (10자 이상)", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _submitReview,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text("등록하고 포인트 받기", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 4. 쿠폰함
class CouponPage extends StatelessWidget {
  const CouponPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> coupons = ["신규가입 환영 10% 할인", "배송비 무료 쿠폰", "간식 전용 3,000원 할인"];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("쿠폰함"), backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: coupons.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            color: Colors.orange.shade50,
            child: ListTile(
              leading: const Icon(Icons.airplane_ticket, color: Colors.orange),
              title: Text(coupons[index], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text("2025.12.31까지"),
              trailing: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.orange, elevation: 0),
                  child: const Text("사용")
              ),
            ),
          );
        },
      ),
    );
  }
}

// 5. FAQ (자주 묻는 질문)
class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> faqs = [
      {"q": "쿠폰은 어떻게 쓰나요?", "a": "주문 결제 페이지에서 '쿠폰 적용' 버튼을 눌러 사용하실 수 있습니다."},
      {"q": "회원 탈퇴는 어디서 하나요?", "a": "설정 > 내 정보 관리 > 맨 하단 회원 탈퇴 버튼을 통해 가능합니다."},
      {"q": "배송은 얼마나 걸리나요?", "a": "평일 기준 2~3일 내에 도착합니다."},
      {"q": "주문 취소/반품은 어떻게 하나요?", "a": "주문내역 > 주문상세 > 주문취소/반품신청 버튼을 이용해주세요."},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("자주 묻는 질문"), backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0),
      body: ListView.builder(
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text(faqs[index]['q']!, style: const TextStyle(fontWeight: FontWeight.bold)),
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Colors.grey[50],
                child: Text(faqs[index]['a']!),
              )
            ],
          );
        },
      ),
    );
  }
}

// 6. 1:1 문의 (채팅)
class ChatSupportPage extends StatefulWidget {
  const ChatSupportPage({super.key});

  @override
  State<ChatSupportPage> createState() => _ChatSupportPageState();
}

class _ChatSupportPageState extends State<ChatSupportPage> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = ["안녕하세요! 무엇을 도와드릴까요? 🤖"];

  void _sendMessage() {
    if (_controller.text.isEmpty) return;
    setState(() {
      _messages.add(_controller.text);
      _messages.add("잠시만 기다려주시면 상담원이 연결됩니다.");
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("1:1 문의"), backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                bool isMe = index % 2 != 0;
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.orange : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(_messages[index], style: TextStyle(color: isMe ? Colors.white : Colors.black)),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(child: TextField(controller: _controller, decoration: const InputDecoration(hintText: "문의 내용을 입력하세요", border: OutlineInputBorder()))),
                IconButton(icon: const Icon(Icons.send, color: Colors.orange), onPressed: _sendMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}