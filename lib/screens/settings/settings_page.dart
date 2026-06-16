// lib/screens/settings/settings_page.dart
import 'package:flutter/material.dart';
import '../../models.dart';
// 💡 에러 나던 경로 대신 상대 경로를 사용합니다.
// 만약 sub_pages.dart가 같은 폴더에 있다면 아래처럼 고치세요.
import 'sub_pages.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: ListView(
        children: [
          // 🚨 [오류 해결] 클래스가 없다고 뜨는 페이지들은
          // 실제 파일이 존재하지 않거나 이름이 다른 경우입니다.
          // 임시로 이름을 맞춰두었으니, 실제 파일명과 클래스명을 확인해 보세요.
          ListTile(title: const Text('주문 내역'), onTap: () {}), // OrderHistoryPage 연결 필요
          ListTile(title: const Text('쿠폰함'), onTap: () {}),   // CouponPage 연결 필요
          ListTile(title: const Text('FAQ'), onTap: () {}),    // FAQPage 연결 필요
          ListTile(title: const Text('고객센터'), onTap: () {}), // ChatSupportPage 연결 필요
        ],
      ),
    );
  }
}