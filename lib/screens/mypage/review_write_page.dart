import 'package:flutter/material.dart';

class ReviewWritePage extends StatefulWidget {
  const ReviewWritePage({super.key});

  @override
  State<ReviewWritePage> createState() => _ReviewWritePageState();
}

class _ReviewWritePageState extends State<ReviewWritePage> {
  final TextEditingController _controller = TextEditingController();
  bool _hasPhoto = false;
  int _expectedPoints = 0;

  void _calculatePoints() {
    setState(() {
      int points = 0;
      if (_controller.text.length >= 10) points += 50; // 글 작성 50P
      if (_hasPhoto) points += 100; // 사진 첨부 100P
      _expectedPoints = points;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('구매후기 작성'), backgroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('상품은 어떠셨나요?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            TextField(
              controller: _controller,
              maxLines: 5,
              onChanged: (_) => _calculatePoints(),
              decoration: const InputDecoration(hintText: '최소 10자 이상 작성해주세요.', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                setState(() => _hasPhoto = !_hasPhoto); // 사진 첨부 시뮬레이션
                _calculatePoints();
              },
              child: Container(
                width: 100, height: 100,
                decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(10)),
                child: _hasPhoto ? const Icon(Icons.check_circle, color: Colors.green) : const Icon(Icons.add_a_photo, color: Colors.grey),
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: Colors.orange[50], borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('작성 시 예상 적립 포인트:'),
                  Text('$_expectedPoints P', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 18)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text('등록하기', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}