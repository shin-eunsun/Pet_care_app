import 'package:flutter/material.dart';
import '../../main.dart';
import 'signup_page.dart';
// MainScreen import를 지우고, HomePage가 있는 경로를 import 하세요
// 만약 같은 파일에 있다면 import가 필요 없습니다.
import '../home/home_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Pet Care App', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.orange)),
            const SizedBox(height: 50),
            const TextField(decoration: InputDecoration(labelText: '아이디')),
            const TextField(decoration: InputDecoration(labelText: '비밀번호'), obscureText: true),
            const SizedBox(height: 30),

            // 로그인 버튼 (MainScreen 대신 HomePage 호출)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HomePage()) // 수정 완료
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text('로그인', style: TextStyle(color: Colors.white)),
              ),
            ),

            // 회원가입 버튼
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupPage())),
              child: const Text('계정이 없으신가요? 회원가입'),
            ),
          ],
        ),
      ),
    );
  }
}