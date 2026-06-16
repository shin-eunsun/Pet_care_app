import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const PetCareApp());
}

class PetCareApp extends StatelessWidget {
  const PetCareApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(debugShowCheckedModeBanner: false, home: MainNavigation());
  }
}

// 🧭 네비게이션
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [const HomePage(), const BoardPage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: Colors.orange,
        items: const [BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'), BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: '게시판')],
      ),
    );
  }
}

// 📋 게시판 페이지
class BoardPage extends StatefulWidget {
  const BoardPage({super.key});
  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  List<Map<String, dynamic>> posts = [{'title': '우리 강아지 산책했어요!', 'content': '오늘 날씨가 정말 좋네요.', 'author': '멍멍이주인', 'likes': 0, 'comments': [{'user': '냥이집사', 'text': '귀여워요!'}]}];
  List<Map<String, dynamic>> photos = [];
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(title: const Text('게시판', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)), backgroundColor: const Color(0xFFFFFDE7), elevation: 0, bottom: const TabBar(labelColor: Colors.orange, unselectedLabelColor: Colors.grey, indicatorColor: Colors.orange, tabs: [Tab(text: '사진'), Tab(text: '동영상'), Tab(text: '커뮤니티')])),
        body: TabBarView(children: [
          Stack(children: [
            GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 25, childAspectRatio: 0.75),
              itemCount: photos.length,
              itemBuilder: (c, i) => GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => PhotoDetailScreen(photo: photos[i]))).then((_) => setState(() {})),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(image: FileImage(photos[i]['file']), fit: BoxFit.cover)))),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4), child: Text(photos[i]['author'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: Text('좋아요 ${photos[i]['likes']} • 댓글 ${photos[i]['comments'].length}', style: const TextStyle(color: Colors.grey, fontSize: 11))),
                ]),
              ),
            ),
            Positioned(right: 20, bottom: 20, child: FloatingActionButton(backgroundColor: Colors.orange, child: const Icon(Icons.add_photo_alternate, color: Colors.white), onPressed: () => _pickImage())),
          ]),

          // 동영상 탭 (썸네일 적용)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => const YoutubePlayerDetail())),
              child: Column(
                children: [
                  Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey[300],
                      image: const DecorationImage(
                        image: NetworkImage('https://img.youtube.com/vi/xKWR4-e2l54/0.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: const Center(child: Icon(Icons.play_circle_fill, size: 60, color: Colors.white70)),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("반려동물 영상 보러가기", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  )
                ],
              ),
            ),
          ),

          Stack(children: [
            ListView.separated(padding: const EdgeInsets.all(16), itemCount: posts.length, separatorBuilder: (c, i) => const Divider(), itemBuilder: (c, i) => ListTile(title: Text(posts[i]['title'], style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text('${posts[i]['author']} • 좋아요 ${posts[i]['likes']} • 댓글 ${posts[i]['comments'].length}'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => PostDetailScreen(post: posts[i]))).then((_) => setState(() {})))),
            Positioned(right: 20, bottom: 20, child: FloatingActionButton(backgroundColor: Colors.orange, child: const Icon(Icons.create, color: Colors.white), onPressed: () async { final newPost = await Navigator.push(context, MaterialPageRoute(builder: (ctx) => const WritePostScreen())); if (newPost != null) setState(() => posts.add({...newPost, 'author': '나', 'likes': 0, 'comments': []})); })),
          ]),
        ]),
      ),
    );
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) setState(() => photos.add({'file': File(image.path), 'author': '나', 'likes': 0, 'comments': []}));
  }
}

// 🎥 유튜브 재생 상세 화면
class YoutubePlayerDetail extends StatelessWidget {
  const YoutubePlayerDetail({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("동영상 재생")),
      body: const YoutubeVideoPlayer(url: 'https://youtube.com/shorts/xKWR4-e2l54?si=Y2Vodu1XtQX0J0NM'),
    );
  }
}

// 🎥 유튜브 영상 재생 위젯
class YoutubeVideoPlayer extends StatefulWidget {
  final String url;
  const YoutubeVideoPlayer({super.key, required this.url});
  @override
  State<YoutubeVideoPlayer> createState() => _YoutubeVideoPlayerState();
}

class _YoutubeVideoPlayerState extends State<YoutubeVideoPlayer> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
  }
}

// 📸 사진 상세 페이지
class PhotoDetailScreen extends StatefulWidget {
  final Map<String, dynamic> photo;
  const PhotoDetailScreen({super.key, required this.photo});
  @override
  State<PhotoDetailScreen> createState() => _PhotoDetailScreenState();
}

class _PhotoDetailScreenState extends State<PhotoDetailScreen> {
  TextEditingController commentCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('사진 상세')),
      body: Column(children: [
        Expanded(child: Column(children: [
          Image.file(widget.photo['file'], width: double.infinity, height: 250, fit: BoxFit.cover),
          Padding(padding: const EdgeInsets.all(16), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('작성자: ${widget.photo['author']}'), IconButton(icon: Icon(Icons.favorite, color: widget.photo['likes'] > 0 ? Colors.red : Colors.grey), onPressed: () => setState(() => widget.photo['likes']++))])),
          Expanded(child: ListView.builder(itemCount: widget.photo['comments'].length, itemBuilder: (c, i) => ListTile(leading: const Icon(Icons.person), title: Text(widget.photo['comments'][i]['user'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)), subtitle: Text(widget.photo['comments'][i]['text'])))),
        ])),
        SafeArea(child: Padding(padding: const EdgeInsets.all(8.0), child: Row(children: [Expanded(child: TextField(controller: commentCtrl, decoration: InputDecoration(hintText: '댓글 입력', border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))))), IconButton(icon: const Icon(Icons.send, color: Colors.orange), onPressed: () { setState(() => widget.photo['comments'].add({'user': '나', 'text': commentCtrl.text})); commentCtrl.clear(); })]))),
      ]),
    );
  }
}

// ✍️ 글쓰기 화면
class WritePostScreen extends StatefulWidget { const WritePostScreen({super.key}); @override State<WritePostScreen> createState() => _WritePostScreenState(); }
class _WritePostScreenState extends State<WritePostScreen> { final _titleCtrl = TextEditingController(); final _contentCtrl = TextEditingController(); @override Widget build(BuildContext context) { return Scaffold(appBar: AppBar(title: const Text('글 쓰기'), actions: [TextButton(onPressed: () { if (_titleCtrl.text.isNotEmpty) Navigator.pop(context, {'title': _titleCtrl.text, 'content': _contentCtrl.text}); }, child: const Text('완료', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)))]), body: Padding(padding: const EdgeInsets.all(16), child: Column(children: [TextField(controller: _titleCtrl, decoration: const InputDecoration(hintText: '제목을 입력하세요', border: InputBorder.none), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), const Divider(), Expanded(child: TextField(controller: _contentCtrl, decoration: const InputDecoration(hintText: '내용을 입력하세요', border: InputBorder.none), maxLines: null))]))); } }

// 💬 글 상세 페이지
class PostDetailScreen extends StatefulWidget {
  final Map<String, dynamic> post;
  const PostDetailScreen({super.key, required this.post});
  @override State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  TextEditingController commentCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(title: const Text('게시글')),
        body: Column(children: [
          Expanded(child: Column(children: [
            Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(widget.post['title'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), Text('작성자: ${widget.post['author']}', style: const TextStyle(color: Colors.grey)), const SizedBox(height: 10), Text(widget.post['content'], style: const TextStyle(fontSize: 16)), IconButton(icon: Icon(Icons.favorite, color: widget.post['likes'] > 0 ? Colors.red : Colors.grey), onPressed: () => setState(() => widget.post['likes']++))])),
            const Divider(),
            Expanded(child: ListView.builder(itemCount: widget.post['comments'].length, itemBuilder: (context, i) => ListTile(leading: const Icon(Icons.person), title: Text(widget.post['comments'][i]['user'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)), subtitle: Text(widget.post['comments'][i]['text'])))),
          ])),
          SafeArea(child: Padding(padding: const EdgeInsets.all(8.0), child: Row(children: [Expanded(child: TextField(controller: commentCtrl, decoration: InputDecoration(hintText: '댓글을 입력하세요', border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))))), IconButton(icon: const Icon(Icons.send, color: Colors.orange), onPressed: () { setState(() => widget.post['comments'].add({'user': '나', 'text': commentCtrl.text})); commentCtrl.clear(); })])))
        ]));
  }
}

// 🏠 메인 홈 화면
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, String>> pets = [{'name': '코코', 'type': '고양이', 'age': '2살'}];
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController ageCtrl = TextEditingController();
  String selectedType = '강아지';

  void _addPet() {
    if (nameCtrl.text.isNotEmpty && ageCtrl.text.isNotEmpty) {
      setState(() {
        pets.add({'name': nameCtrl.text, 'type': selectedType, 'age': ageCtrl.text});
        nameCtrl.clear();
        ageCtrl.clear();
      });
      Navigator.pop(context);
    }
  }

  void _showGuidebook(BuildContext context, String type) {
    String title = '';
    String content = '';

    if (type == 'vaccine') {
      title = '예방접종 가이드';
      content = '🐶 강아지: 종합백신, 코로나, 켄넬코프, 광견병\n\n🐱 고양이: 종합백신, 복막염, 광견병';
    } else if (type == 'supplement') {
      title = '반려동물 필수 영양제';
      content = '🐶 강아지: 관절 보호용 글루코사민, 면역 강화 오메가3\n\n🐱 고양이: 요로 건강용 크랜베리, 필수 타우린';
    } else if (type == 'food') {
      title = '맞춤 사료 정보';
      content = '🐶 강아지: 저알러지 가수분해 단백질 사료\n\n🐱 고양이: 육식성 영양 고려 고단백 습식 주식캔';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(title),
        content: Text(content),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('확인'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDE7),
      appBar: AppBar(title: const Text('Pet AI Care', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black)), backgroundColor: const Color(0xFFFFFDE7), elevation: 0),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('오늘 우리 아이, 어디를 체크할까요?', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    ...pets.asMap().entries.map((entry) => Row(
                      children: [
                        Text(entry.value['type'] == '강아지' ? '🐶' : '🐱', style: const TextStyle(fontSize: 30)),
                        const SizedBox(width: 10),
                        Expanded(child: Text('${entry.value['name']} (${entry.value['type']}, ${entry.value['age']})')),
                        IconButton(icon: const Icon(Icons.remove_circle, color: Colors.red), onPressed: () => setState(() => pets.removeAt(entry.key)))
                      ],
                    )),
                    IconButton(icon: const Icon(Icons.add_circle, color: Colors.orange), onPressed: () => showDialog(context: context, builder: (ctx) => AlertDialog(
                        title: const Text('펫 추가'),
                        content: Column(mainAxisSize: MainAxisSize.min, children: [
                          TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: '이름')),
                          TextField(controller: ageCtrl, decoration: const InputDecoration(labelText: '나이 (예: 2살)')),
                          DropdownButton<String>(value: selectedType, items: ['강아지', '고양이'].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(), onChanged: (v) => setState(() => selectedType = v!)),
                        ]),
                        actions: [TextButton(onPressed: _addPet, child: const Text('추가'))]
                    )))
                  ],
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(onTap: () => _showGuidebook(context, 'vaccine'), child: _buildMainGradientCard('예방접종', '필수 리스트 확인', Icons.vaccines_rounded)),
              const SizedBox(height: 16),
              Row(children: [Expanded(child: GestureDetector(onTap: () => _showGuidebook(context, 'supplement'), child: _buildSubCard('영양제 추천', Icons.medication_rounded))), const SizedBox(width: 16), Expanded(child: GestureDetector(onTap: () => _showGuidebook(context, 'food'), child: _buildSubCard('사료 정보', Icons.restaurant_menu_rounded)))]),
              const SizedBox(height: 30),
              const Text('실시간 인기 추천템', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 14),
              Column(
                children: [
                  _buildShopItem('독 프레쉬 그레인프리 스몰브리드', '29,844원', 'https://images.pet-friends.co.kr/storage/pet_friends/product/id/f/5/5/6/8/7/2/f5568723c2fb24061648e42b3585fba1/10001/dbfea7277aa151b3e1a1ebe66c996ae5.jpeg'),
                  const SizedBox(height: 14),
                  _buildShopItem('캐츠랑 전연령 20kg', '47,000원', 'https://images.pet-friends.co.kr/storage/pet_friends/product/id/f/c/2/5/b/a/1/fc25ba10e253d3ac81d2ba4ae1dafdb3/10001/23ab8df0535e244209b601942b253c2b.jpeg'),
                  const SizedBox(height: 100),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (ctx) => const ChatBotScreen()),
        backgroundColor: const Color(0xFFFF8F00),
        label: const Text('건강 상담소', style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.chat_bubble_rounded, color: Colors.white),
      ),
    );
  }

  Widget _buildMainGradientCard(String t, String d, IconData i) => Container(height: 125, padding: const EdgeInsets.all(16), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFFFE082), Color(0xFFFF9800)]), borderRadius: BorderRadius.circular(24)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)), Text(d)]), Icon(i, size: 48, color: Colors.white.withOpacity(0.5))]));
  Widget _buildSubCard(String t, IconData i) => Container(height: 135, padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(t, style: const TextStyle(fontWeight: FontWeight.bold)), const Spacer(), Icon(i, size: 34, color: Colors.orange)]));
  Widget _buildShopItem(String name, String price, String imgUrl) => Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)), child: Row(children: [Container(width: 80, height: 80, decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(image: NetworkImage(imgUrl), fit: BoxFit.cover))), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(name), Text(price, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange))]))]));
}

// 💬 AI 챗봇 화면
class ChatBotScreen extends StatefulWidget { const ChatBotScreen({super.key}); @override State<ChatBotScreen> createState() => _ChatBotScreenState(); }
class _ChatBotScreenState extends State<ChatBotScreen> {
  final List<Map<String, dynamic>> _msgs = [{'text': '안녕하세요! 강아지/고양이의 증상이나 궁금한 점을 말씀해 주세요.', 'isUser': false}];
  final TextEditingController _ctr = TextEditingController();

  void _send() {
    if (_ctr.text.trim().isEmpty) return;
    setState(() {
      _msgs.add({'text': _ctr.text, 'isUser': true});
      String q = _ctr.text;
      bool isDog = q.contains('강아지') || q.contains('멍멍이');
      bool isCat = q.contains('고양이') || q.contains('냥이');
      String ans = '궁금한 점을 더 자세히 말씀해 주시면 맞춤 상담을 도와드릴게요!';

      if (q.contains('구토')) {
        ans = isDog ? '🐶 [강아지 구토] 공복 시간이 길면 노란토를 할 수 있어요. 식사 횟수를 나누어 급여하세요.' : '🐱 [고양이 구토] 헤어볼 때문일 수 있습니다. 자주 빗질해 주세요.';
      } else if (q.contains('소화') || q.contains('설사')) {
        ans = isDog ? '🐶 [강아지 소화] 저자극 사료로 교체하고 소량씩 자주 급여하세요.' : '🐱 [고양이 소화] 급격한 식단 변경은 피하고 유산균 급여를 권장합니다.';
      } else if (q.contains('영양') || q.contains('영양제')) {
        ans = isDog ? '🐶 [강아지 영양] 관절(글루코사민)과 피모(오메가3) 케어가 중요합니다.' : '🐱 [고양이 영양] 타우린이 함유된 보조제와 수분 공급이 필수입니다.';
      } else if (q.contains('사료')) {
        ans = isDog ? '🐶 [강아지 사료] 알레르기 반응이 없다면 가수분해 사료가 좋습니다.' : '🐱 [고양이 사료] 고단백 고기 위주의 습식 사료를 추천합니다.';
      } else if (q.contains('눈') || q.contains('충혈')) {
        ans = '💡 [안구] 결막염이나 알레르기일 수 있습니다. 병원 방문을 권장합니다.';
      }
      _msgs.add({'text': ans, 'isUser': false});
    });
    _ctr.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(color: Color(0xFFFFFDE7), borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
        child: Column(children: [
          Container(padding: const EdgeInsets.all(16), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('AI 상담', style: TextStyle(fontWeight: FontWeight.bold)), IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context))])),
          Expanded(child: ListView.builder(padding: const EdgeInsets.all(20), itemCount: _msgs.length, itemBuilder: (context, i) => Align(alignment: _msgs[i]['isUser'] ? Alignment.centerRight : Alignment.centerLeft, child: Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: _msgs[i]['isUser'] ? const Color(0xFFFF8F00) : Colors.white, borderRadius: BorderRadius.circular(16)), child: Text(_msgs[i]['text']))))),
          SafeArea(child: Container(padding: const EdgeInsets.all(12), child: Row(children: [Expanded(child: TextField(controller: _ctr, decoration: const InputDecoration(hintText: "메시지를 입력하세요..."))), IconButton(icon: const Icon(Icons.send), onPressed: _send)])))
        ]),
      ),
    );
  }
}