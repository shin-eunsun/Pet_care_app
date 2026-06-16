// lib/screens/home/health_info_page.dart
import 'package:flutter/material.dart';

class HealthInfoPage extends StatelessWidget {
  final String title;
  const HealthInfoPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (title.contains('예방접종')) ...[
            _buildVaccineInfo(),
          ] else if (title.contains('사료')) ...[
            _buildFoodInfo(),
          ] else ...[
            const Center(child: Text('피부 모질 스캔 기능입니다.')),
          ]
        ],
      ),
    );
  }

  Widget _buildVaccineInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('🐶 강아지 필수 접종', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Text('• 종합백신(DHPPL)\n• 코로나 장염\n• 켄넬코프\n• 광견병'),
        const SizedBox(height: 20),
        const Text('🐱 고양이 필수 접종', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Text('• 종합백신(범백혈구 감소증 등)\n• 복막염\n• 광견병'),
      ],
    );
  }

  Widget _buildFoodInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('🐶 강아지 사료 선택법', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Text('강아지는 잡식성 경향이 있어 단백질과 적절한 탄수화물이 필요합니다. 눈물이 많다면 저알러지 사료를 추천합니다.'),
        const SizedBox(height: 20),
        const Text('🐱 고양이 사료 선택법', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Text('고양이는 육식동물로 타우린과 동물성 단백질이 필수입니다. 수분 섭취를 위해 습식 사료를 병행하는 것이 좋습니다.'),
      ],
    );
  }
}