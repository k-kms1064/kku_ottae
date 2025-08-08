import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class JoinScreen extends StatefulWidget {
  const JoinScreen({super.key});

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _codeSent = false;
  bool _isVerified = false;

  // 인증 메일 보내기
  Future<void> sendVerificationEmail() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirm = _confirmPasswordController.text.trim();
    final emailRegex = RegExp(r'^[\w\.-]+@kku\.ac\.kr$');

    if (email.isEmpty || password.isEmpty || confirm.isEmpty) {
      Fluttertoast.showToast(msg: '모든 필드를 입력해주세요.');
      return;
    }
    if (!emailRegex.hasMatch(email)) {
      Fluttertoast.showToast(msg: '📛 반드시 @kku.ac.kr 이메일을 입력해주세요.');
      return;
    }
    if (password != confirm) {
      Fluttertoast.showToast(msg: '비밀번호가 일치하지 않습니다.');
      return;
    }

    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      print("✅ 계정 생성 성공: ${credential.user?.email}");

      await credential.user?.sendEmailVerification();
      print("📧 인증 메일 발송 완료");

      Fluttertoast.showToast(msg: '📨 인증 메일을 보냈습니다!');
      setState(() => _codeSent = true);
    } on FirebaseAuthException catch (e) {
      print("❌ FirebaseAuth 오류: ${e.code} / ${e.message}");
      Fluttertoast.showToast(msg: e.message ?? '회원가입 실패');
    } catch (e) {
      print("❌ 기타 오류 발생: $e");
      Fluttertoast.showToast(msg: '알 수 없는 오류 발생');
    }
  }

  // 이메일 인증 확인
  Future<void> checkEmailVerified() async {
    final user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    if (user != null && user.emailVerified) {
      Fluttertoast.showToast(msg: '✅ 이메일 인증 완료!');
      setState(() => _isVerified = true);
    } else {
      Fluttertoast.showToast(msg: '⛔ 이메일 인증이 아직 완료되지 않았습니다.');
    }
  }

  // Firestore에 사용자 정보 저장 후 이동
  Future<void> completeSignup() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('❌ 유저 없음!');
      return;
    }

    try {
      print('📦 Firestore 저장 시작');
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': _nameController.text.trim(),
        'studentId': _studentIdController.text.trim(),
        'email': user.email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      print('✅ Firestore 저장 완료');
      Fluttertoast.showToast(msg: '🎉 회원가입 완료!');

      await Future.delayed(const Duration(milliseconds: 300));
      // 로그인 화면으로 이동
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } catch (e) {
      print("❌ Firestore 저장 오류: $e");
      Fluttertoast.showToast(msg: '회원정보 저장 실패');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00552E),
      appBar: AppBar(
        title: const Text(
          '회원가입',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF00552E),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListView(
              shrinkWrap: true,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: '이름',
                    prefixIcon: Icon(Icons.badge),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _studentIdController,
                  decoration: const InputDecoration(
                    labelText: '학번',
                    prefixIcon: Icon(Icons.numbers),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: '건국대학교 이메일 (@kku.ac.kr)',
                    prefixIcon: const Icon(Icons.email),
                    suffixIcon: TextButton(
                      onPressed: sendVerificationEmail,
                      child: const Text('인증 요청'),
                    ),
                  ),
                ),
                if (_codeSent) ...[
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: checkEmailVerified,
                    child: const Text('인증 확인'),
                  ),
                ],
                const SizedBox(height: 12),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: '비밀번호',
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: '비밀번호 확인',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isVerified ? completeSignup : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00552E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    '가입하기',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
