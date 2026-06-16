import 'package:flutter/material.dart';

class AddressChangePage extends StatefulWidget {
  const AddressChangePage({super.key});

  @override
  State<AddressChangePage> createState() => _AddressChangePageState();
}

class _AddressChangePageState extends State<AddressChangePage> {
  // 입력 필드 컨트롤러
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _addressController = TextEditingController();
  final _detailAddressController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _zipCodeController.dispose();
    _addressController.dispose();
    _detailAddressController.dispose();
    super.dispose();
  }

  // ★ 저장 버튼 눌렀을 때 실행되는 함수
  void _saveAddress() {
    if (_nameController.text.isEmpty || _addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이름과 주소를 입력해주세요.')),
      );
      return;
    }

    // 입력된 데이터를 Map 형태로 묶음
    final newAddressData = {
      'recipient': "${_nameController.text} (${_phoneController.text})",
      'address': "${_addressController.text} ${_detailAddressController.text}",
    };

    // ★ 이전 화면(PurchasePage)으로 데이터를 가지고 돌아감
    Navigator.pop(context, newAddressData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('배송지 변경'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('받는 사람'),
            _buildTextField(_nameController, '이름을 입력하세요'),
            const SizedBox(height: 10),
            _buildTextField(_phoneController, '휴대폰 번호 (- 없이 입력)', keyboardType: TextInputType.phone),

            const SizedBox(height: 30),
            _buildSectionTitle('주소'),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(_zipCodeController, '우편번호', readOnly: true),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // 주소 찾기 시뮬레이션
                    setState(() {
                      _zipCodeController.text = '06234';
                      _addressController.text = '서울시 강남구 테헤란로 123';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.black,
                    elevation: 0,
                  ),
                  child: const Text('주소 찾기'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildTextField(_addressController, '기본 주소', readOnly: true),
            const SizedBox(height: 10),
            _buildTextField(_detailAddressController, '상세 주소 (예: 101동 101호)'),

            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveAddress,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('저장하기', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {bool readOnly = false, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        filled: true,
        fillColor: readOnly ? Colors.grey[100] : Colors.white,
      ),
    );
  }
}