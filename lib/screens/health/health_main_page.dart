import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http; // AI API 통신용 (필요 시 pubspec.yaml에 추가)

class PetHealthScreen extends StatefulWidget {
  const PetHealthScreen({Key? key}) : super(key: key);

  @override
  State<PetHealthScreen> createState() => _PetHealthScreenState();
}

class _PetHealthScreenState extends State<PetHealthScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // 건강 기록용 변수들
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _mealController = TextEditingController();
  String _selectedSymptom = '없음';
  List<Map<String, dynamic>> _healthLogs = [];

  // 챗봇용 변수들
  final TextEditingController _chatController = TextEditingController();
  final List<Map<String, String>> _chatMessages = [
    {'role': 'assistant', 'message': '안녕하세요! 우리 아이의 건강 상태나 증상에 대해 무엇이든 물어보세요. 인터넷 실시간 정보를 바탕으로 답변해 드립니다! 🐾'}
  ];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadHealthLogs();
  }

  // --- [건강 관리 로직] ---
  Future<void> _loadHealthLogs() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedLogs = prefs.getStringList('health_logs') ?? [];
    setState(() {
      _healthLogs = savedLogs.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
    });
  }

  Future<void> _saveHealthLog() async {
    if (_weightController.text.isEmpty || _mealController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('몸무게와 식사량을 모두 입력해주세요!'), backgroundColor: Colors.orange),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> newLog = {
      'date': DateTime.now().toString().substring(0, 10),
      'weight': _weightController.text,
      'meal': _mealController.text,
      'symptom': _selectedSymptom,
    };

    _healthLogs.insert(0, newLog); // 최신 정보를 맨 앞으로
    List<String> updatedLogs = _healthLogs.map((e) => jsonEncode(e)).toList();
    await prefs.setStringList('health_logs', updatedLogs);

    setState(() {
      _weightController.clear();
      _mealController.clear();
      _selectedSymptom = '없음';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('오늘의 건강 일지가 기록되었습니다!'), backgroundColor: Colors.green),
    );
  }

  // --- [RAG 챗봇 통신 로직] ---
  Future<void> _sendChatMessage(String userMessage) async {
    if (userMessage.trim().isEmpty) return;

    setState(() {
      _chatMessages.add({'role': 'user', 'message': userMessage});
      _isLoading = true;
    });
    _chatController.clear();

    try {
      // 💡 [실제 RAG 구현 팁]
      // 앱에서 직접 인터넷 검색 기반 답변을 얻으려면 Gemini API의 Search Grounding 기능을 호출하거나,
      // 서버(Python)에 질문을 보내서 크롤링/VectorDB 결과를 받아와야 합니다.
      // 여기서는 이해를 돕기 위한 구조적 예시 답변을 처리하며, 아래에 API 연동 코드를 주석으로 첨부합니다.

      String aiResponse = await _fetchRAGAIResponse(userMessage);

      setState(() {
        _chatMessages.add({'role': 'assistant', 'message': aiResponse});
      });
    } catch (e) {
      setState(() {
        _chatMessages.add({'role': 'assistant', 'message': '죄송합니다. 정보를 가져오는 중 오류가 발생했습니다.'});
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 인터넷/정보 소스 연동 RAG 가상 함수
  Future<String> _fetchRAGAIResponse(String query) async {
    // 실제 프로젝트 시:
    // 본인의 Python RAG 서버 혹은 Gemini API(Google Search Tool 활성화)로 HTTP Post 요청을 보냅니다.
    await Future.delayed(const Duration(seconds: 2)); // 서버 통신 대기 시간 시뮬레이션

    if (query.contains('밥') || query.contains('사료')) {
      return '[인터넷 수의학 정보 검색 결과]\n강아지나 고양이가 갑자기 밥을 먹지 않을 때는 다음과 같은 원인이 있을 수 있습니다:\n\n1. 스트레스 및 환경 변화: 최근 사료를 바꿨거나 가구 배치 변경 등이 원인일 수 있습니다.\n2. 구강 질환: 치주염이나 구내염으로 인해 통식증이 생겼을 수 있으니 입안을 확인해보세요.\n3. 소화기 문제: 일시적인 구토나 설사가 동반된다면 하루 정도 절식 후 부드러운 유동식을 급여해보시고, 24시간 이상 거부 시 병원 방문이 필요합니다.\n\n💡 꿀팁: 사료를 살짝 전자레인지에 데워 향을 강하게 해주면 식욕을 돋우는 데 도움이 됩니다.';
    }
    return '[검색 정보 반영] 질문하신 "$query"에 대해 국내 동물병원 데이터베이스 및 반려동물 건강 정보 채널을 검색한 결과, 일시적인 증상일 수 있으나 증상이 지속된다면 전문 수의사의 진료를 권장합니다.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('아이 건강 케어 Center', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.orange,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.orange,
          tabs: const [
            Tab(text: '구체적인 건강 일지'),
            Tab(text: 'AI 건강 상담소 (RAG)'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildHealthLogTab(), // 1번 탭: 건강기능 관리
          _buildChatbotTab(),   // 2번 탭: RAG 챗봇
        ],
      ),
    );
  }

  // --- [1번 탭: 건강 관리 화면 UI] ---
  Widget _buildHealthLogTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('오늘의 건강 상태 기록', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),

          // 몸무게 입력
          TextField(
            controller: _weightController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: '오늘의 몸무게 (kg)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.monitor_weight_outlined),
            ),
          ),
          const SizedBox(height: 15),

          // 식사량 입력
          TextField(
            controller: _mealController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: '오늘 먹은 사료/간식 양 (g)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.restaurant),
            ),
          ),
          const SizedBox(height: 15),

          // 이상 증상 선택 (구체화된 관리)
          DropdownButtonFormField<String>(
            value: _selectedSymptom,
            decoration: const InputDecoration(
              labelText: '특이 사항 및 이상 증상',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.warning_amber_rounded),
            ),
            items: ['없음', '구토', '설사', '기력 저하', '피부 발진', '과도한 그루밍/긁음']
                .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (val) => setState(() => _selectedSymptom = val!),
          ),
          const SizedBox(height: 20),

          // 저장 버튼
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _saveHealthLog,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text('건강 데이터 기록하기', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 30),

          // 기록된 리스트 보여주기
          const Text('지난 건강 히스토리', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _healthLogs.isEmpty
              ? const Center(child: Padding(padding: EdgeInsets.all(20.0), child: Text('아직 기록된 건강 일지가 없습니다.')))
              : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _healthLogs.length,
            itemBuilder: (context, index) {
              final log = _healthLogs[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: const Icon(Icons.assignment_turned_in, color: Colors.orange),
                  title: Text('${log['date']} 기록'),
                  subtitle: Text('몸무게: ${log['weight']}kg | 식사량: ${log['meal']}g\n이상증상: ${log['symptom']}'),
                  isThreeLine: true,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // --- [2번 탭: RAG 챗봇 화면 UI] ---
  Widget _buildChatbotTab() {
    return Column(
      children: [
        // 채팅 메시지 리스트
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _chatMessages.length,
            itemBuilder: (context, index) {
              final chat = _chatMessages[index];
              bool isUser = chat['role'] == 'user';
              return Align(
                alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUser ? Colors.orange[100] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12).copyWith(
                      bottomRight: isUser ? const Radius.circular(0) : const Radius.circular(12),
                      topLeft: isUser ? const Radius.circular(12) : const Radius.circular(0),
                    ),
                  ),
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                  child: Text(
                    chat['message']!,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),
              );
            },
          ),
        ),

        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(color: Colors.orange),
          ),

        // 입력창 영역
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5, spreadRadius: 1)],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _chatController,
                  decoration: const InputDecoration(
                    hintText: 'ex) 고양이가 사료를 잘 안 먹을 땐 어떻게 하나요?',
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.orange),
                onPressed: () => _sendChatMessage(_chatController.text),
              ),
            ],
          ),
        ),
      ],
    );
  }
}