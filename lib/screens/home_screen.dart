import 'package:flutter/material.dart';

class PracticalAiHomeScreen extends StatefulWidget {
  const PracticalAiHomeScreen({Key? key}) : super(key: key);

  @override
  State<PracticalAiHomeScreen> createState() => _PracticalAiHomeScreenState();
}

class _PracticalAiHomeScreenState extends State<PracticalAiHomeScreen> {
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          _currentTab == 1 ? '통합 게시판' : 'CO-PET AI CARE',
          style: const TextStyle(
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: _buildBodyByTab(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab,
        onTap: (index) => setState(() => _currentTab = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: '홈 케어'),
          BottomNavigationBarItem(icon: Icon(Icons.forum_rounded), label: '게시판'),
          BottomNavigationBarItem(icon: Icon(Icons.edit_calendar_rounded), label: '건강일지'),
          BottomNavigationBarItem(icon: Icon(Icons.pets_rounded), label: '내 새꾸'),
        ],
      ),
    );
  }

  Widget _buildBodyByTab() {
    switch (_currentTab) {
      case 0:
        return _buildHomeScreenBody();
      case 1:
        return _buildBoardScreenBody();
      case 2:
        return const Center(child: Text('건강일지 화면 (준비 중)'));
      case 3:
        return const Center(child: Text('내 새꾸 프로필 화면 (준비 중)'));
      default:
        return _buildHomeScreenBody();
    }
  }

  Widget _buildBoardScreenBody() {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: const TabBar(
              labelColor: Colors.teal,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.teal,
              indicatorWeight: 3,
              labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              tabs: [
                Tab(text: '일반 글'),
                Tab(text: '이미지'),
                Tab(text: '영상'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildGeneralTabContent(),
                _buildImageTabContent(),
                _buildVideoTabContent(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 1. 일반 게시판
  Widget _buildGeneralTabContent() {
    final List<Map<String, String>> generalPosts = [
      {'title': '우리 고양이 사료 추천 좀 해주세요ㅠㅠ', 'desc': '요즘 부쩍 눈물이 많아졌는데 알러지 없는 사료 있을까요?', 'user': '치즈집사', 'time': '5분 전'},
      {'title': '강아지 켄넬 훈련 팁 공유합니다!', 'desc': '처음에는 간식을 안쪽에 넣어두는 것부터 시작하시는 게 좋습니다.', 'user': '초코파파', 'time': '20분 전'},
      {'title': '정기 예방접종 비용 보통 얼마 나오시나요?', 'desc': '다니던 병원이 이사해서 새로 알아보는데 감이 안 잡히네요.', 'user': '펫러버', 'time': '1시간 전'},
    ];

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: generalPosts.length,
      itemBuilder: (context, index) {
        final post = generalPosts[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 4)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(post['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
              const SizedBox(height: 6),
              Text(post['desc']!, style: const TextStyle(fontSize: 13, color: Colors.grey), maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(post['user']!, style: const TextStyle(fontSize: 12, color: Colors.teal, fontWeight: FontWeight.w600)),
                  Text(post['time']!, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  // 2. 이미지 게시판
  Widget _buildImageTabContent() {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        List<String> titles = ['오늘 산책 대성공!🐾', '꿀잠 자는 중..💤', '새 옷 입어봤개 의젓', '간식 기다리는 눈빛'];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: const Center(child: Icon(Icons.image_rounded, color: Colors.teal, size: 40)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  titles[index],
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        );
      },
    );
  }

  // 3. 영상 게시판
  Widget _buildVideoTabContent() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: 2,
      itemBuilder: (context, index) {
        List<String> vTitles = ['치즈의 폭풍 우다다 타임 (심장주의)', '고양이 골골송 1시간 연속 듣기'];
        List<String> vTimes = ['조회수 1.2만회 · 2시간 전', '조회수 4.5천회 · 어제'];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 180,
                decoration: const BoxDecoration(
                  color: Color(0xFF263238),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
                ),
                child: const Center(
                  child: Icon(Icons.play_circle_filled_rounded, color: Colors.white, size: 50),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(vTitles[index], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
                    const SizedBox(height: 4),
                    Text(vTimes[index], style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  // 기존 AI 홈 케어 컴포넌트들
  Widget _buildHomeScreenBody() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAiHealthSearchBar(),
          _buildActiveHealthDashboard(),
          _buildRAGChatbotQuickBanner(),
          _buildAiSolutionProducts(),
        ],
      ),
    );
  }

  Widget _buildAiHealthSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.teal.withOpacity(0.3), width: 1.5),
        ),
        child: const TextField(
          decoration: InputDecoration(
            hintText: '구토, 설사, 사료 거부 등 증상을 입력하세요',
            hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
            prefixIcon: Icon(Icons.search_rounded, color: Colors.teal),
            suffixIcon: Icon(Icons.auto_awesome_rounded, color: Colors.amber),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveHealthDashboard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: const BoxDecoration(color: Color(0xFFE0F2F1), shape: BoxShape.circle),
                child: const Icon(Icons.pets, color: Colors.teal, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('치즈 (기타·3살·4kg)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
                    const SizedBox(height: 3),
                    Text('마지막 기록: 2026.06.15 몸무게 정상수치 유지 중', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1, thickness: 0.8),
          ),
          Row(
            children: [
              _buildDashboardMetricItem('오늘 식사량', '120g / 150g', Colors.orange),
              Container(width: 1, height: 30, color: Colors.grey.shade200),
              _buildDashboardMetricItem('이상 증상', '없음 (안정)', Colors.green),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardMetricItem(String title, String value, Color statusColor) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 5),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: statusColor)),
        ],
      ),
    );
  }

  Widget _buildRAGChatbotQuickBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF00796B), Color(0xFF009688)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.auto_awesome_rounded, color: Colors.amber, size: 20),
                SizedBox(width: 6),
                Text('수의학 지식 기반 AI RAG 상담', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              '"우리 아이가 갑자기 밥을 안 먹을 때는 어떻게 하나요?"\n질문 시 공인 수의학 정보를 기반으로 즉각 답변합니다.',
              style: TextStyle(color: Color(0xFFEFEFEF), fontSize: 12, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAiSolutionProducts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16, top: 16, bottom: 8),
          child: Text('치즈의 건강 맞춤 AI 솔루션 처방', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
        ),
        SizedBox(
          height: 190,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              _buildProductHorizontalCard('이나바 챠오츄르', '2,950원', '소화력 증진'),
              _buildProductHorizontalCard('웰니스 코어 사료', '18,900원', '체중 관리 가이드'),
              _buildProductHorizontalCard('치즈 전용 영양 캔', '1,200원', '하부요로 케어'),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildProductHorizontalCard(String name, String price, String healthTag) {
    return Container(
      width: 140,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, spreadRadius: 1)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: const Center(child: Icon(Icons.medication_liquid_rounded, color: Colors.teal, size: 28)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(healthTag, style: const TextStyle(color: Colors.teal, fontSize: 10, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(price, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
              ],
            ),
          )
        ],
      ),
    );
  }
}