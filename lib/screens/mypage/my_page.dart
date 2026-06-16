import 'dart:convert'; // JSON 디코딩용
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 연결할 페이지 임포트
import '../auth/login_page.dart';
import 'order_history_page.dart';
import 'point_history_page.dart';
import 'coupon_page.dart';
import 'faq_page.dart';
import 'my_pet_manage_page.dart'; // ★ 방금 만든 펫 관리 페이지

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  List<Map<String, dynamic>> _myPets = [];

  // 화면에 들어올 때마다 펫 데이터 갱신
  @override
  void initState() {
    super.initState();
    _loadMyPets();
  }

  // 다른 페이지 갔다가 돌아올 때도 갱신하기 위해 didChangeDependencies나 화면 전환 후 콜백 활용
  // 여기서는 간단하게 build 될 때 갱신하거나, 관리 페이지에서 돌아왔을 때 갱신하도록 구성
  Future<void> _loadMyPets() async {
    final prefs = await SharedPreferences.getInstance();
    final String? petsJson = prefs.getString('myPets');
    if (petsJson != null) {
      if (mounted) {
        setState(() {
          _myPets = List<Map<String, dynamic>>.from(jsonDecode(petsJson));
        });
      }
    }
  }

  // 나이 계산 (현재 연도 - 생년 + 1)
  int _calculateAge(String birthYearStr) {
    int birthYear = int.tryParse(birthYearStr) ?? DateTime.now().year;
    return DateTime.now().year - birthYear + 1;
  }

  void _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginPage()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    // 화면이 다시 그려질 때마다 최신 데이터를 가져오기 위해 FutureBuilder를 쓰거나
    // 관리 페이지에서 pop해서 돌아왔을 때 then()으로 _loadMyPets()를 호출해야 함.
    // 여기서는 간단히 UI 구성에 집중.

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('마이페이지', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(icon: const Icon(Icons.settings_outlined), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. 프로필 섹션 (펫 정보 포함)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      const CircleAvatar(radius: 35, backgroundColor: Colors.orange, child: Icon(Icons.person, size: 40, color: Colors.white)),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('홍길동 님', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: Colors.orange[50], borderRadius: BorderRadius.circular(5)),
                            child: const Text('우주 대스타 등급 🌟', style: TextStyle(fontSize: 12, color: Colors.orange)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ★ [추가됨] 우리 아이들 (펫 정보) 섹션
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('우리 아이들 🐾', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      GestureDetector(
                        onTap: () async {
                          // 관리 페이지로 이동하고, 돌아오면(_then) 데이터를 새로고침
                          await Navigator.push(context, MaterialPageRoute(builder: (_) => const MyPetManagePage()));
                          _loadMyPets();
                        },
                        child: const Text('관리 >', style: TextStyle(color: Colors.grey, fontSize: 13)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // 펫 리스트 가로 스크롤
                  _myPets.isEmpty
                      ? GestureDetector(
                    onTap: () async {
                      await Navigator.push(context, MaterialPageRoute(builder: (_) => const MyPetManagePage()));
                      _loadMyPets();
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey[200]!)),
                      child: const Column(
                        children: [
                          Icon(Icons.add_circle_outline, color: Colors.orange),
                          SizedBox(height: 5),
                          Text('반려동물을 등록해주세요', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  )
                      : SizedBox(
                    height: 90,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _myPets.length,
                      itemBuilder: (context, index) {
                        final pet = _myPets[index];
                        final age = _calculateAge(pet['birthYear']);
                        return Container(
                          width: 80,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.orange.withOpacity(0.3)),
                            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5)],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(pet['type'] == '강아지' ? Icons.pets : Icons.cruelty_free, color: Colors.orange, size: 28),
                              const SizedBox(height: 5),
                              Text(pet['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis),
                              Text('${age}살', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 25),

                  // 포인트, 쿠폰 요약
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSummaryItem(context, '포인트', '1,250P', const PointHistoryPage()),
                      _buildSummaryItem(context, '쿠폰함', '3장', const CouponPage()),
                      _buildSummaryItem(context, '구매후기', '2건', null),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // 쇼핑 정보 메뉴
            _buildMenuSection(context, '쇼핑 정보', [
              {'title': '주문/배송 조회', 'page': const OrderHistoryPage()},
              {'title': '취소/반품/교환 내역', 'page': null},
              {'title': '자주 구매한 상품', 'page': null},
            ]),

            // 고객 센터 메뉴
            _buildMenuSection(context, '고객 센터', [
              {'title': '자주 묻는 질문 (FAQ)', 'page': const FAQPage()},
              {'title': '1:1 문의하기', 'page': null},
              {'title': '공지사항', 'page': null},
            ]),

            Padding(
              padding: const EdgeInsets.all(20),
              child: TextButton(
                onPressed: () => _logout(context),
                child: const Text('로그아웃', style: TextStyle(color: Colors.grey, decoration: TextDecoration.underline)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(BuildContext context, String title, String value, Widget? page) {
    return GestureDetector(
      onTap: () => page != null ? Navigator.push(context, MaterialPageRoute(builder: (_) => page)) : null,
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 5),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context, String sectionTitle, List<Map<String, dynamic>> items) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text(sectionTitle, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          ...items.map((item) => ListTile(
            title: Text(item['title']),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
            onTap: () => item['page'] != null ? Navigator.push(context, MaterialPageRoute(builder: (_) => item['page'])) : null,
          )).toList(),
        ],
      ),
    );
  }
}