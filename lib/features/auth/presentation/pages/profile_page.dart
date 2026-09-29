import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/warm_gradient_background.dart';
import '../../data/auth_api.dart';
import '../../data/auth_user.dart';
import 'login.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _authApi = AuthApi();
  late Future<AuthUser> _profile;
  bool _loggingOut = false;

  @override
  void initState() {
    super.initState();
    _profile = _authApi.getProfile();
  }

  Future<void> _logout() async {
    if (_loggingOut) return;
    setState(() => _loggingOut = true);
    try {
      await _authApi.logout();
    } catch (_) {}
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Mi perfil'),
        backgroundColor: AppColors.mutedMagenta,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: WarmGradientBackground(
        child: FutureBuilder<AuthUser>(
          future: _profile,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        snapshot.error.toString().replaceFirst(
                          'Exception: ',
                          '',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      TextButton(
                        onPressed: () => setState(() {
                          _profile = _authApi.getProfile();
                        }),
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final user = snapshot.data!;
            return ListView(
              padding: const EdgeInsets.all(24),
              children: [
                CircleAvatar(
                  radius: 42,
                  backgroundColor: AppColors.pink,
                  child: Text(
                    user.name.isEmpty ? '?' : user.name[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user.name,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 28),
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Nombre'),
                  subtitle: Text(user.name),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.email_outlined),
                  title: const Text('Correo electrónico'),
                  subtitle: Text(user.email),
                ),
                const SizedBox(height: 28),
                FilledButton.icon(
                  onPressed: _loggingOut ? null : _logout,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.pink,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  icon: const Icon(Icons.logout),
                  label: Text(
                    _loggingOut ? 'Cerrando sesión...' : 'Cerrar sesión',
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
