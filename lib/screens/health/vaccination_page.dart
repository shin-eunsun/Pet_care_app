import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VaccinationPage extends StatefulWidget {
  const VaccinationPage({super.key});

  @override
  State<VaccinationPage> createState() => _VaccinationPageState();
}

class _VaccinationPageState extends State<VaccinationPage> {
  String _petType = '전체'; // 기본값

  @override
  void initState() {
    super.initState();
    _loadPetType();
  }

  // ★ 저장된 펫 종류 불러오기
  Future<void> _loadPetType() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // 저장된 값이 없거나 'none', '기타'면 '전체'를 보여줌
      _petType = prefs.getString('petType') ?? '전체';
    });
  }

  @override
  Widget build(BuildContext context) {
    // 펫 종류에 따른 탭 구성 결정
    List<Widget> tabs = [];
    List<Widget> tabViews = [];

    if (_petType == '강아지') {
      tabs = [const Tab(text: '우리 강아지 접종 🐶')];
      tabViews = [_buildDogList()];
    } else if (_petType == '고양이') {
      tabs = [const Tab(text: '우리 고양이 접종 🐱')];
      tabViews = [_buildCatList()];
    } else {
      // 건너뛰었거나 기타인 경우 모두 보여줌
      tabs = [const Tab(text: '강아지 🐶'), const Tab(text: '고양이 🐱')];
      tabViews = [_buildDogList(), _buildCatList()];
    }

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('예방접종 관리'),
          bottom: TabBar(
            tabs: tabs,
            labelColor: Colors.orange,
            indicatorColor: Colors.orange,
          ),
        ),
        body: TabBarView(children: tabViews),
      ),
    );
  }

  // 강아지 리스트 UI (기존 코드와 동일)
  Widget _buildDogList() {
    return _buildVaccineList([
      {'name': '종합백신 (DHPPL)', 'period': '기초 3회 후 매년 1회', 'desc': '홍역, 간염 등 예방'},
      {'name': '광견병', 'period': '매년 1회 필수', 'desc': '법적 필수 예방접종'},
      {'name': '심장사상충', 'period': '매월 1회', 'desc': '모기 매개 질병 예방'},
    ]);
  }

  // 고양이 리스트 UI (기존 코드와 동일)
  Widget _buildCatList() {
    return _buildVaccineList([
      {'name': '종합백신 (FVRCP)', 'period': '기초 3회 후 매년 1회', 'desc': '범백, 허피스 등 예방'},
      {'name': '고양이 백혈병', 'period': '기초 2회 후 매년 1회', 'desc': '면역 결핍 예방'},
      {'name': '심장사상충', 'period': '매월 1회', 'desc': '실내묘도 필수 권장'},
    ]);
  }

  Widget _buildVaccineList(List<Map<String, String>> vaccines) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: vaccines.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text(vaccines[index]['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(vaccines[index]['period']!, style: const TextStyle(color: Colors.blue)),
            trailing: const Icon(Icons.notifications_active_outlined, color: Colors.orange),
          ),
        );
      },
    );
  }
}