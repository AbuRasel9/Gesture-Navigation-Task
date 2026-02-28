import 'package:flutter/material.dart';
import 'package:gesture_coordination_task/configs/extension.dart';
import 'package:http/http.dart';

import '../../providers/auth_provider.dart';
import 'package:provider/provider.dart';


class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _userCtrl = TextEditingController(text: 'mor_2314');
  final _passCtrl = TextEditingController(text: '83r5^_');
  bool _obscure = true;

  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final auth = context.read<AuthProvider>();
    final login = await auth.login(_userCtrl.text.trim(), _passCtrl.text.trim());
    if (login && mounted) {
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (_) => const ProductListingScreen()),
      // );
      print("------------------------------------$login");
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final theme=context.theme;
    return Scaffold(
      backgroundColor:theme.colorScheme.primary,
      body: SafeArea(
        child: Column(
          children: [
            // Top branding
            Expanded(
              flex: 2,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'daraz',
                      style: theme.textTheme.displayLarge?.copyWith(color: theme.colorScheme.onPrimary,fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                     Text(
                      'It\'s So Good',
                      style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onPrimary,fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            // Login form
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.onPrimary,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                ),
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Use: mor_2314 / 83r5^_',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    _field(
                      controller: _userCtrl,
                      label: 'Username',
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 16),
                    _field(
                      controller: _passCtrl,
                      label: 'Password',
                      icon: Icons.lock_outline,
                      obscure: _obscure,
                      suffix: IconButton(
                        icon: Icon(
                          _obscure ? Icons.visibility_off : Icons.visibility,
                          color: theme.colorScheme.surface,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    if (auth.error != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        auth.error!,
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error,),
                      ),
                    ],
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: auth.loading ? null : _login,

                        child: auth.loading
                            ? const CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2)
                            : const Text(
                          'LOGIN',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFFE31837)),
        suffixIcon: suffix,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE31837)),
        ),
      ),
    );
  }
}
