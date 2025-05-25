import 'package:flutter/material.dart';
import 'package:frontend/services/user_repository.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:frontend/data/user_data.dart';
import 'package:frontend/views/pages/auth_page/login_page.dart';
import 'package:frontend/views/pages/edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserRepository _userRepo = UserRepository();

  Future<UserProfile?> _getUser() async {
    final userId = await _userRepo.getCurrentUserId();
    if (userId == null) return null;
    return _userRepo.getUser(userId);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: FutureBuilder<UserProfile?>(
        future: _getUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return Scaffold(
              appBar: AppBar(title: const Text('Profil Saya')),
              body: const Center(child: Text('Gagal memuat profil pengguna')),
            );
          }

          final user = snapshot.data!;
          final completedMaterials =
              user.levelProgress.values.where((lp) => lp.isCompleted).length;
          final averageScore = _calculateAverageScore(user);

          return Scaffold(
            appBar: AppBar(
              title: const Text('Profil Saya'),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfilePage(user: user),
                      ),
                    ).then((_) {
                      setState(() {});
                    });
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildProfileHeader(user),
                  const SizedBox(height: 24),
                  _buildStatisticsSection(
                    user,
                    completedMaterials,
                    averageScore,
                  ),
                  const SizedBox(height: 24),
                  _buildSettingsSection(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  double _calculateAverageScore(UserProfile user) {
    final completedLevels =
        user.levelProgress.values.where((lp) => lp.isCompleted).toList();
    if (completedLevels.isEmpty) return 0.0;

    final totalScore = completedLevels.fold<int>(
      0,
      (sum, lp) => sum + (lp.score ?? 0),
    );
    return (totalScore / completedLevels.length).toDouble();
  }

  Widget _buildProfileHeader(UserProfile user) {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.blue.shade200, width: 3),
          ),
          child: CircleAvatar(
            radius: 56,
            backgroundImage:
                user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                    ? (user.avatarUrl!.startsWith('http')
                            ? NetworkImage(user.avatarUrl!)
                            : FileImage(File(user.avatarUrl!)))
                        as ImageProvider
                    : null,
            child:
                user.avatarUrl == null || user.avatarUrl!.isEmpty
                    ? const Icon(Icons.person, size: 60)
                    : null,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          user.name,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          user.email,
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        const SizedBox(height: 8),
        Text(
          'Bergabung sejak ${DateFormat('MMMM yyyy').format(user.joinDate)}',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[500],
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticsSection(
    UserProfile user,
    int completedMaterials,
    double averageScore,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Statistik Belajar',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  icon: Icons.library_books,
                  value: completedMaterials.toString(),
                  label: 'Materi Selesai',
                  color: Colors.blue,
                ),
                _buildStatItem(
                  icon: Icons.star,
                  value: averageScore.toStringAsFixed(
                    1,
                  ), // Rata-rata skor dengan 1 desimal
                  label: 'Rata-rata Skor',
                  color: Colors.amber,
                ),
                _buildStatItem(
                  icon: Icons.badge,
                  value: user.achievements.length.toString(),
                  label: 'Badges',
                  color: Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            const Text(
              'Pencapaian Terbaru',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            user.achievements.isNotEmpty
                ? Column(
                  children:
                      user.achievements.take(3).map((achievement) {
                        return ListTile(
                          leading: const Icon(
                            Icons.emoji_events,
                            color: Colors.orange,
                          ),
                          title: Text(achievement),
                          dense: true,
                        );
                      }).toList(),
                )
                : const Text(
                  'Belum ada pencapaian.',
                  style: TextStyle(color: Colors.grey),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.1),
          ),
          child: Icon(icon, size: 32, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            _buildSettingTile(
              icon: Icons.notifications,
              title: 'Notifikasi',
              onTap: () {},
            ),
            const Divider(height: 1, indent: 16),
            _buildSettingTile(
              icon: Icons.security,
              title: 'Privasi & Keamanan',
              onTap: () {},
            ),
            const Divider(height: 1, indent: 16),
            _buildSettingTile(
              icon: Icons.help_center,
              title: 'Bantuan & Dukungan',
              onTap: () {},
            ),
            const Divider(height: 1, indent: 16),
            _buildSettingTile(
              icon: Icons.info,
              title: 'Tentang Aplikasi',
              onTap: () {},
            ),
            const Divider(height: 1, indent: 16),
            _buildSettingTile(
              icon: Icons.logout,
              title: 'Keluar',
              color: Colors.red,
              onTap: () async {
                await _userRepo.logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.blue),
      title: Text(
        title,
        style: TextStyle(
          color: color ?? Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
