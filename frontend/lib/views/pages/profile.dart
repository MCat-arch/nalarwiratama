import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:frontend/data/user_data.dart';

class ProfilePage extends StatelessWidget {
  final UserProfile user = UserProfile(
    name: 'John Doe',
    email: 'john.doe@example.com',
    avatarUrl: 'https://example.com/avatar.jpg',
    completedMaterials: 12,
    totalScore: 1250,
    rank: 42,
    joinDate: DateTime(2023, 1, 15),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigasi ke halaman edit profil
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Bagian Avatar dan Info Dasar
            _buildProfileHeader(),
            const SizedBox(height: 24),

            // Bagian Statistik
            _buildStatisticsSection(),
            const SizedBox(height: 24),

            // Bagian Pengaturan
            _buildSettingsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        // Avatar
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.blue.shade200, width: 3),
          ),
          child: CircleAvatar(
            radius: 56,
            backgroundImage: NetworkImage(user.avatarUrl),
            child:
                user.avatarUrl.isEmpty
                    ? const Icon(Icons.person, size: 60)
                    : null,
          ),
        ),
        const SizedBox(height: 16),

        // Nama
        Text(
          user.name,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),

        // Email
        Text(
          user.email,
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        const SizedBox(height: 8),

        // Tanggal Bergabung
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

  Widget _buildStatisticsSection() {
    return Card(
      elevation: 2,
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
                  value: user.completedMaterials.toString(),
                  label: 'Materi Selesai',
                ),
                _buildStatItem(
                  icon: Icons.star,
                  value: user.totalScore.toString(),
                  label: 'Total Skor',
                ),
                _buildStatItem(
                  icon: Icons.leaderboard,
                  value: '#${user.rank}',
                  label: 'Peringkat',
                ),
              ],
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
  }) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Colors.blue),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildSettingsSection() {
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
              onTap: () {
                // Handle logout
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
