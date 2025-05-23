import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:frontend/data/user_data.dart';
import 'package:frontend/services/user_repository.dart';

class EditProfilePage extends StatefulWidget {
  final UserProfile user;

  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final UserRepository _userRepo = UserRepository();
  final _nameController = TextEditingController();
  String? _avatarPath;
  // final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.name;
    _avatarPath = widget.user.avatarUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // Fungsi untuk memilih gambar dari galeri
  // Future<void> _pickImage() async {
  //   final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     setState(() {
  //       _avatarPath = pickedFile.path; // Simpan path lokal
  //     });
  //   }
  // }

  // Fungsi untuk menyimpan perubahan profil
  Future<void> _saveProfile() async {
    final updatedUser = widget.user.copyWith(
      name: _nameController.text,
      avatarUrl: _avatarPath,
    );
    await _userRepo.saveUser(updatedUser);
    Navigator.pop(context); // Kembali ke halaman profil
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _saveProfile),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
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
                          _avatarPath != null && _avatarPath!.isNotEmpty
                              ? (_avatarPath!.startsWith('http')
                                      ? NetworkImage(_avatarPath!)
                                      : FileImage(File(_avatarPath!)))
                                  as ImageProvider
                              : null,
                      child:
                          _avatarPath == null || _avatarPath!.isEmpty
                              ? const Icon(Icons.person, size: 60)
                              : null,
                    ),
                  ),
                  // Positioned(
                  //   bottom: 0,
                  //   right: 0,
                  //   child: GestureDetector(
                  //     onTap: _pickImage,
                  //     child: Container(
                  //       padding: const EdgeInsets.all(8),
                  //       decoration: BoxDecoration(
                  //         shape: BoxShape.circle,
                  //         color: Colors.blue,
                  //         border: Border.all(color: Colors.white, width: 2),
                  //       ),
                  //       child: const Icon(
                  //         Icons.camera_alt,
                  //         color: Colors.white,
                  //         size: 24,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Email: ${widget.user.email}',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
