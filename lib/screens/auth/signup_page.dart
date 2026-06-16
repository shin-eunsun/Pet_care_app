import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pet_registration_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  // 입력 컨트롤러
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // 약관 동의 상태 변수
  bool _isAllAgreed = false;
  bool _isServiceAgreed = false; // 필수
  bool _isPrivacyAgreed = false; // 필수
  bool _isMarketingAgreed = false; // 선택
  bool _isAdAgreed = false; // 선택

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // 전체 동의 체크박스 로직
  void _setAllAgreed(bool? value) {
    if (value == null) return;
    setState(() {
      _isAllAgreed = value;
      _isServiceAgreed = value;
      _isPrivacyAgreed = value;
      _isMarketingAgreed = value;
      _isAdAgreed = value;
    });
  }

  // 개별 체크박스 변경 시 전체 동의 상태 업데이트
  void _updateAllAgreed() {
    setState(() {
      _isAllAgreed = _isServiceAgreed && _isPrivacyAgreed && _isMarketingAgreed && _isAdAgreed;
    });
  }

  // 회원가입 실행
  Future<void> _signUp() async {
    // 필수 약관 동의 확인
    if (!_isServiceAgreed || !_isPrivacyAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('필수 약관에 동의해야 가입이 가능합니다.')),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userName', _nameController.text.trim());
        await prefs.setString('userId', _idController.text.trim());
        await prefs.setString('userPassword', _passwordController.text.trim());
        // 마케팅 동의 여부도 저장 가능
        await prefs.setBool('marketingAgreed', _isMarketingAgreed);

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PetRegistrationPage()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('오류가 발생했습니다.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("회원가입", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text("반려동물 케어 앱\n계정을 생성하세요! 🎉", textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.orange)),
                const SizedBox(height: 30),

                // --- 입력 필드 섹션 ---
                _buildTextField(_nameController, '이름', Icons.person_outline),
                const SizedBox(height: 12),
                _buildTextField(_idController, '아이디', Icons.account_circle_outlined),
                const SizedBox(height: 12),
                _buildTextField(_passwordController, '비밀번호', Icons.lock_outline, isObscure: true),
                const SizedBox(height: 12),
                _buildTextField(_confirmPasswordController, '비밀번호 확인', Icons.lock_reset, isObscure: true),

                const SizedBox(height: 30),
                const Divider(),

                // --- 약관 동의 섹션 ---
                const Text("약관 동의", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),

                // 1. 전체 동의
                CheckboxListTile(
                  value: _isAllAgreed,
                  onChanged: _setAllAgreed,
                  title: const Text("전체 약관에 동의합니다.", style: TextStyle(fontWeight: FontWeight.bold)),
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: Colors.orange,
                  contentPadding: EdgeInsets.zero,
                ),

                // 2. 서비스 이용약관 (필수)
                _buildTermsItem("서비스 이용약관 동의 (필수)", _isServiceAgreed, (val) {
                  setState(() => _isServiceAgreed = val!);
                  _updateAllAgreed();
                }),

                // 3. 개인정보 처리방침 (필수)
                _buildTermsItem("개인정보 수집 및 이용 동의 (필수)", _isPrivacyAgreed, (val) {
                  setState(() => _isPrivacyAgreed = val!);
                  _updateAllAgreed();
                }),

                // 4. 마케팅 수신 (선택)
                _buildTermsItem("마케팅 정보 수신 동의 (선택)", _isMarketingAgreed, (val) {
                  setState(() => _isMarketingAgreed = val!);
                  _updateAllAgreed();
                }),

                // 5. 광고성 알림 (선택)
                _buildTermsItem("광고성 푸시 알림 동의 (선택)", _isAdAgreed, (val) {
                  setState(() => _isAdAgreed = val!);
                  _updateAllAgreed();
                }),

                const SizedBox(height: 30),

                // 가입하기 버튼
                SizedBox(
                  height: 55,
                  child: ElevatedButton(
                    onPressed: (_isServiceAgreed && _isPrivacyAgreed) ? _signUp : null, // 필수 동의 시에만 활성화
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      disabledBackgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('가입하기', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 입력 필드 위젯 헬퍼
  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isObscure = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.orange),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: (val) => val!.isEmpty ? '$label을 입력해주세요.' : null,
    );
  }

  // 약관 항목 위젯 헬퍼
  Widget _buildTermsItem(String title, bool value, ValueChanged<bool?> onChanged) {
    return CheckboxListTile(
      value: value,
      onChanged: onChanged,
      title: Text(title, style: const TextStyle(fontSize: 14)),
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: Colors.orange,
      contentPadding: EdgeInsets.zero,
      dense: true, // 높이를 압축해서 보기 편하게 함
    );
  }
}