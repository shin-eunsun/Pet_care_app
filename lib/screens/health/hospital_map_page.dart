import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HealthMainPage extends StatefulWidget {
  const HealthMainPage({super.key});

  @override
  State<HealthMainPage> createState() => _HealthMainPageState();
}

class _HealthMainPageState extends State<HealthMainPage> {
  // 탭 선택 상태 (기본값을 병원찾기로 고정해서 테스트해보세요)
  String _selectedCategory = '병원찾기';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('건강관리')),
      body: Column(
        children: [
          // 카테고리 선택 영역
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _tabButton('예방접종'),
              _tabButton('건강수첩'),
              _tabButton('병원찾기'),
            ],
          ),
          const Divider(),
          // 내용 출력 영역
          Expanded(
            child: Center(
              child: _selectedCategory == '병원찾기'
                  ? _buildHospitalButton() // 병원찾기면 버튼을 보여줌
                  : Text('$_selectedCategory 화면 준비 중'),
            ),
          ),
        ],
      ),
    );
  }

  // 탭 버튼 위젯
  Widget _tabButton(String name) {
    bool isSelected = _selectedCategory == name;
    return TextButton(
      onPressed: () => setState(() => _selectedCategory = name),
      child: Text(name, style: TextStyle(color: isSelected ? Colors.orange : Colors.grey)),
    );
  }

  // ★ 이 버튼이 화면에 나와야 합니다!
  Widget _buildHospitalButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.local_hospital, size: 100, color: Colors.redAccent),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            const url = "https://www.google.com/maps/search/동물병원";
            if (await canLaunchUrl(Uri.parse(url))) {
              await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          ),
          child: const Text("내 근처 동물병원 찾기 (구글맵)", style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
      ],
    );
  }
}