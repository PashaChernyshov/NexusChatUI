import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileSettingsScreen extends StatefulWidget {
  final String userName;
  final String phoneNumber;
  final String status;
  final Function(Map<String, String>) onUpdateProfile;
  final String avatarUrl;

  const ProfileSettingsScreen({
    super.key,
    required this.userName,
    required this.phoneNumber,
    required this.status,
    required this.onUpdateProfile,
    required this.avatarUrl,
  });

  @override
  _ProfileSettingsScreenState createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _statusController;
  String? _updatedAvatarUrl;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userName);
    _phoneController = TextEditingController(text: widget.phoneNumber);
    _statusController = TextEditingController(text: widget.status);
    _updatedAvatarUrl = widget.avatarUrl;
  }

  void _saveProfile() {
    String phoneNumber = _phoneController.text;
    phoneNumber = phoneNumber.replaceFirst('+7', '').trim();

    widget.onUpdateProfile({
      'newName': _nameController.text,
      'newPhoneNumber': '+7 $phoneNumber',
      'newStatus': _statusController.text,
      'avatarUrl': _updatedAvatarUrl ?? widget.avatarUrl,
    });

    Navigator.pop(context);
  }

  Future<void> _changeAvatar() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _updatedAvatarUrl = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Настройки профиля'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveProfile,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _changeAvatar,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _updatedAvatarUrl != null &&
                            File(_updatedAvatarUrl!).existsSync()
                        ? FileImage(File(_updatedAvatarUrl!))
                        : NetworkImage(widget.avatarUrl) as ImageProvider,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Нажмите, чтобы изменить аватар',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildInputField(
              label: 'Имя',
              controller: _nameController,
              icon: Icons.person,
            ),
            const SizedBox(height: 16),
            _buildInputField(
              label: 'Номер телефона',
              controller: _phoneController,
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
              ],
            ),
            const SizedBox(height: 16),
            _buildInputField(
              label: 'Статус',
              controller: _statusController,
              icon: Icons.info_outline,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _saveProfile,
                child: const Text(
                  'Сохранить',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        filled: true,
        fillColor: const Color(0xFF2A2A2E),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.deepPurple),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
