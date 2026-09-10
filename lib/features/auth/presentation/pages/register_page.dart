import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../widgets/auth_background.dart';
import 'forgot_password_page.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 32),
          child: Column(
            children: [
              const AuthIllustration(),
              _switcher(),
              const SizedBox(height: 26),
              Container(
                padding: const EdgeInsets.fromLTRB(26, 22, 26, 26),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _input(_name, 'Nombre completo', Icons.person_outline),
                      const Divider(height: 22),
                      _input(
                        _email,
                        'Correo electrónico',
                        Icons.email_outlined,
                        type: TextInputType.emailAddress,
                      ),
                      const Divider(height: 22),
                      _input(
                        _password,
                        'Contraseña',
                        Icons.lock_outline,
                        obscure: _obscure,
                        suffix: IconButton(
                          onPressed: () => setState(() => _obscure = !_obscure),
                          icon: Icon(
                            _obscure
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Cuenta lista para conectar con la API',
                                  ),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.pink,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'CREAR CUENTA',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
                ),
                child: const Text(
                  '¿Olvidaste tu contraseña?',
                  style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _switcher() {
    return Container(
      height: 66,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0x3D8D3F5A),
        borderRadius: BorderRadius.circular(36),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginPage()),
              ),
              child: const Center(
                child: Text(
                  'Existing',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Center(
                child: Text(
                  'New',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _input(
    TextEditingController controller,
    String hint,
    IconData icon, {
    TextInputType? type,
    bool obscure = false,
    Widget? suffix,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: obscure,
      validator: (value) =>
          value == null || value.trim().isEmpty ? 'Completa este campo' : null,
      decoration: InputDecoration(
        icon: Icon(icon, color: Colors.black87),
        hintText: hint,
        hintStyle: const TextStyle(
          color: AppColors.mutedText,
          fontWeight: FontWeight.w600,
        ),
        border: InputBorder.none,
        suffixIcon: suffix,
      ),
    );
  }
}
