// lib/screens/home/home_page.dart
import 'package:flutter/material.dart';

// 💬 AI 챗봇 화면 클래스
class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});
  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final List<Map<String, dynamic>> _msgs = [
    {
      'text': '반갑습니다! 건강지식 기반 챗봇입니다. ✨\n아이의 종류(강아지/고양이)와 증상을 함께 말씀해 주세요!\n(예: 강아지가 구토해요, 고양이가 눈곱이 껴요)',
      'isUser': false
    }
  ];
  final TextEditingController _ctr = TextEditingController();

  void _send() {
    if (_ctr.text.trim().isEmpty) return;

    setState(() {
      _msgs.add({'text': _ctr.text, 'isUser': true});
      String query = _ctr.text;
      String answer = _generateSmartAnswer(query);

      _msgs.add({'text': answer, 'isUser': false});
    });
    _ctr.clear();
  }

  // 🧠 강아지/고양이 구분 맞춤형 답변 생성 로직
  String _generateSmartAnswer(String query) {
    bool isDog = query.contains('강아지') || query.contains('댕댕이') || query.contains('멍멍이');
    bool isCat = query.contains('고양이') || query.contains('냥이');

    // 기본 답변
    String answer = '말씀해 주신 내용("$query")을 분석 중입니다. 증상이 며칠간 지속되었는지 명시해 주시면 더 상세히 가이드해 드릴게요!';

    // 1. 눈 관련
    if (query.contains('눈') || query.contains('충혈') || query.contains('눈곱')) {
      if (isDog) {
        answer = '💡 [강아지 안구 케어]\n강아지는 알레르기성 결막염이 잦습니다. 생리식염수로 눈가를 부드럽게 닦아주시고, 긁지 못하게 넥카라를 씌워주세요.';
      } else if (isCat) {
        answer = '💡 [고양이 안구 케어]\n고양이는 허피스 바이러스 등 호흡기 질환과 연관된 결막염일 수 있습니다. 눈곱 색깔이 노랗다면 즉시 병원 검진을 권장합니다.';
      } else {
        answer = '💡 [안구질환 매뉴얼]\n결막염 혹은 각막 상처일 위험이 있습니다. 생리식염수로 눈가를 청결히 닦고, 긁지 않도록 주의해 주세요.';
      }
    }
    // 2. 피부/각질 관련
    else if (query.contains('피부') || query.contains('긁어') || query.contains('각질')) {
      if (isDog) {
        answer = '💡 [강아지 피모 케어]\n강아지 피부염은 음식 알레르기인 경우가 많습니다. 최근 사료를 바꾸셨나요? 실내 습도를 45% 전후로 유지해 주세요.';
      } else if (isCat) {
        answer = '💡 [고양이 피모 케어]\n고양이는 스트레스성 과도한 그루밍이나 링웜(곰팡이성)일 수 있습니다. 환부를 확인하고 약용 샴푸 또는 연고 처방을 위해 수의사와 상담하세요.';
      } else {
        answer = '💡 [피모 케어 매뉴얼]\n알레르기성 피부염이나 감염의 소지가 있습니다. 실내 습도를 조절하고 꾸준한 빗질과 케어를 권장합니다.';
      }
    }
    // 3. 구토 관련
    else if (query.contains('토') || query.contains('구토')) {
      if (isDog) {
        answer = '💡 [강아지 소화기 케어]\n공복 시간 때문일 수 있습니다. 식사 횟수를 3~4회로 나누어 주세요. 만약 혈토나 이물질이 섞여 있다면 즉시 병원에 방문하세요.';
      } else if (isCat) {
        answer = '💡 [고양이 소화기 케어]\n헤어볼 때문인가요? 빗질을 자주 해주고 헤어볼 배출 사료를 급여해 보세요. 잦은 구토는 신부전 등 질환의 신호일 수 있습니다.';
      } else {
        answer = '💡 [소화기 케어 매뉴얼]\n반나절 금식 후 미온수로 수분을 공급해 보세요. 구토가 3회 이상 반복되면 즉시 병원 진료가 필요합니다.';
      }
    }
    // 4. 설사 관련
    else if (query.contains('설사')) {
      answer = '💡 [소화기 케어 매뉴얼]\n급격한 사료 변화나 과식이 원인일 수 있습니다. 반나절 공복 유지 후, 소화 부담이 적은 유동식이나 북어국(염분제거)을 소량 급여해 보세요.';
    }
    // 5. 사료/영양 관련
    else if (query.contains('사료') || query.contains('영양') || query.contains('밥')) {
      if (isDog) {
        answer = '💡 [강아지 영양 매뉴얼]\n강아지는 단백질과 탄수화물 균형이 중요합니다. 눈물 자국이 있다면 저알러지 포뮬러 사료를 추천드립니다.';
      } else if (isCat) {
        answer = '💡 [고양이 영양 매뉴얼]\n고양이는 육식 동물입니다. 타우린이 함유된 고단백 습식 사료를 추천하며, 항상 신선한 물을 넉넉히 제공해 주세요.';
      }
    }

    return answer;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(color: Color(0xFFFFFDE7), borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    CircleAvatar(backgroundColor: Color(0xFFFF8F00), radius: 12, child: Icon(Icons.bolt_rounded, color: Colors.white, size: 14)),
                    SizedBox(width: 8),
                    Text('공공데이터 지식 가이드 매니저', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50))),
                  ],
                ),
                IconButton(icon: const Icon(Icons.close, color: Color(0xFF7F8C8D)), onPressed: () => Navigator.pop(context))
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _msgs.length,
              itemBuilder: (context, index) {
                final m = _msgs[index];
                final u = m['isUser'] as bool;
                return Align(
                  alignment: u ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(
                        color: u ? const Color(0xFFFF8F00) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: u ? [] : [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))]
                    ),
                    child: Text(m['text'] as String, style: TextStyle(color: u ? Colors.white : const Color(0xFF2C3E50), fontSize: 14, height: 1.4)),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.all(12),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _ctr,
                      decoration: InputDecoration(
                        hintText: '궁금한 증상을 물어보세요...',
                        filled: true,
                        fillColor: const Color(0xFFF5F5F5),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: const Color(0xFFFF8F00),
                    child: IconButton(icon: const Icon(Icons.send_rounded, color: Colors.white, size: 16), onPressed: _send),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}