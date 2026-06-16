import 'package:flutter/material.dart';
import 'address_add_page.dart'; // [파일명 확인 필수]

class AddressListPage extends StatefulWidget {
  const AddressListPage({super.key});

  @override
  State<AddressListPage> createState() => _AddressListPageState();
}

class _AddressListPageState extends State<AddressListPage> {
  // 샘플 주소 데이터 (나중에는 서버나 로컬 DB에서 가져오게 됩니다)
  List<Map<String, String>> addressList = [
    {
      'name': '우리집',
      'phone': '010-1234-5678',
      'address': '서울시 강남구 테헤란로 123',
      'detail': '101동 101호',
    },
    {
      'name': '회사',
      'phone': '010-9876-5432',
      'address': '경기도 판교역로 231',
      'detail': 'S동 12층',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('배송지 선택'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          // 1. 기존 주소 리스트 (onTap 포함)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: addressList.length,
              itemBuilder: (context, index) {
                final item = addressList[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(item['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${item['address']} ${item['detail']}'),
                    // ★ 기존 주소를 딱 누르면! 정보를 가지고 PurchasePage로 돌아갑니다.
                    onTap: () {
                      print("기존 주소 선택됨: $item");
                      Navigator.pop(context, item);
                    },
                    trailing: const Icon(Icons.chevron_right),
                  ),
                );
              },
            ),
          ),

          // 2. 하단 새로운 주소지 입력 버튼
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () async {
                  // 새로운 주소지 입력 페이지로 이동
                  final newAddr = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddressAddPage()),
                  );

                  // ★ 만약 새 주소를 입력하고 돌아왔다면? 바로 주문서로 던져줍니다!
                  if (newAddr != null) {
                    print("새 주소 입력받음: $newAddr");
                    if (mounted) Navigator.pop(context, newAddr);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text(
                  '새로운 주소지 입력하기',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}