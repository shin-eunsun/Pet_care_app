// lib/screens/community/community_page.dart
import 'package:flutter/material.dart';
import '../../models.dart';
import 'community_write_page.dart'; // 같은 폴더에 있으므로 파일명만 적으면 됩니다.

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // 🛠️ 실시간 글 추가를 위해 final을 유지하되 리스트 내부를 변경할 수 있도록 선언합니다.
  // (만약 고정된 리스트 에러가 날 경우를 대비해 본문에서 다이나믹하게 추가 가능하도록 조치)
  final List<Post> _dynamicPosts = [
    Post(title: '우리 집 강아지 자랑해요', content: '너무 귀엽지 않나요? 오늘 산책하다가 노란 꽃 앞에서 인생샷 건졌어요!'),
    Post(title: '고양이 사료 추천 부탁드려요', content: '기호성 좋은 사료 있을까요? 눈물자국 개선에 좋은 영양 포뮬러면 좋겠습니다.'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDE7), // 크림 옐로우 배경
      appBar: AppBar(
        title: const Text(
          '게시판',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Color(0xFF1A1A1A),
            fontSize: 22,
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: const Color(0xFFFFFDE7),
        foregroundColor: Colors.black,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFFF8F00),
          indicatorWeight: 3,
          labelColor: const Color(0xFFFF8F00),
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          unselectedLabelColor: const Color(0xFF7F8C8D),
          tabs: const [
            Tab(text: '📸 이미지'),
            Tab(text: '🎥 영상'),
            Tab(text: '✍️ 일반'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildImageTab(),   // 📸 1. 이미지 카테고리
          _buildVideoTab(),   // 🎥 2. 영상 카테고리
          _buildGeneralTab(), // ✍️ 3. 일반 카테고리 (실시간 추가 반영 대상)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // 🛠️ [핵심 수정] 글쓰기 화면으로 이동 후, 유저가 작성하고 넘겨준 Post 객체를 기다립니다(await).
          final newPost = await Navigator.push<Post>(
            context,
            MaterialPageRoute(builder: (context) => const CommunityWritePage()),
          );

          // 🛠️ [핵심 수정] 새 글이 성공적으로 작성되어 돌아왔다면 리스트에 넣고 화면을 새로고침합니다.
          if (newPost != null) {
            setState(() {
              _dynamicPosts.insert(0, newPost); // 최신 글이 맨 위에 보이도록 0번 인덱스에 추가
              _tabController.animateTo(2);     // 글이 추가되면 자동으로 [✍️ 일반] 탭으로 이동시킵니다.
            });
          }
        },
        backgroundColor: const Color(0xFFFF8F00),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // 📸 1. 이미지 카테고리 탭
  // ---------------------------------------------------------------------
  Widget _buildImageTab() {
    final List<Map<String, String>> imageData = [
      {
        'imagePath': 'assets/images/image_918186.jpg',
        'title': '빼꼼 쳐다보는 울 고양이 🐱',
        'backupEmoji': '🐱'
      },
      {
        'imagePath': 'assets/images/image_9188e8.jpg',
        'title': '세상 얌전한 인형 강아지 🐶',
        'backupEmoji': '🐶'
      },
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: imageData.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.78,
      ),
      itemBuilder: (context, index) {
        final item = imageData[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFFE082).withOpacity(0.12),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Container(
                    width: double.infinity,
                    color: const Color(0xFFFFFDE7),
                    child: Image.asset(
                      item['imagePath']!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Text(item['backupEmoji']!, style: const TextStyle(fontSize: 48)),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title']!,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF2C3E50)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    const Text('❤️ 좋아요 77개', style: TextStyle(fontSize: 11, color: Color(0xFFFF8F00), fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------
  // 🎥 2. 영상 카테고리 탭
  // ---------------------------------------------------------------------
  Widget _buildVideoTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 2,
      itemBuilder: (context, index) {
        final videoTitles = ['우당탕탕 고양이 캣휠 정주행 🎥', '주인 퇴근했을 때 강아지 리액션 🐕'];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFFE082).withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 150,
                decoration: const BoxDecoration(
                  color: Color(0xFF34495E),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: const Center(
                  child: Icon(Icons.play_circle_filled_rounded, size: 50, color: Color(0xFFFFB300)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      videoTitles[index],
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
                    ),
                    const SizedBox(height: 4),
                    const Text('조회수 1.2만회 · 3시간 전', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------
  // ✍️ 3. 일반 카테고리 탭 (가변 리스트 _dynamicPosts 연동)
  // ---------------------------------------------------------------------
  Widget _buildGeneralTab() {
    // 만약 새로 작성한 글이 하나도 없다면 텅 비어있다는 안내 문구를 띄워줍니다.
    if (_dynamicPosts.isEmpty) {
      return const Center(
        child: Text(
          '아직 등록된 글이 없습니다.\n첫 번째 소통 글을 남겨보세요! ✍️',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 15, height: 1.5),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _dynamicPosts.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final post = _dynamicPosts[index];
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFFE082).withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFDE7),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      '자유 소통',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFF57F17)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                post.title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
              ),
              const SizedBox(height: 6),
              Text(
                post.content,
                style: const TextStyle(fontSize: 14, color: Color(0xFF7F8C8D), height: 1.4),
              ),
              const SizedBox(height: 14),
              const Divider(color: Color(0xFFF5F5F5), height: 1),
              const SizedBox(height: 8),
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.chat_bubble_outline_rounded, size: 16, color: Color(0xFFBDC3C7)),
                  SizedBox(width: 4),
                  Text('댓글 달며 소통하기', style: TextStyle(fontSize: 12, color: Color(0xFF7F8C8D))),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}