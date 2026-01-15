import 'package:flutter/material.dart';
import 'app_theme.dart';

class EditProfilePage extends StatefulWidget {
  final String currentName;
  final String currentEmail;
  final String currentPhotoUrl;

  const EditProfilePage({
    super.key,
    required this.currentName,
    required this.currentEmail,
    required this.currentPhotoUrl,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;

  bool isPublic = true;
  bool isSharing = true;
  bool pushNotifications = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: currentName);
    _emailController = TextEditingController(text: currentEmail);
    _phoneController = TextEditingController(text: '+1 234 567 8900');
    _bioController = TextEditingController(text: 'Fitness enthusiast');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  String get currentName => widget.currentName;
  String get currentEmail => widget.currentEmail;
  String get currentPhotoUrl => widget.currentPhotoUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: AppTheme.cardColor,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Profile updated successfully!'),
                    backgroundColor: AppTheme.accentColor,
                  ),
                );
                Navigator.pop(context, true);
              },
              child: Text(
                'Save',
                style: TextStyle(
                  color: AppTheme.accentColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        children: [
          _buildProfilePhotoSection(),
          const SizedBox(height: 24),
          _buildFormSection(),
          const SizedBox(height: 24),
          _buildSettingsSection(),
        ],
      ),
    );
  }

  Widget _buildProfilePhotoSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.dividerColor, width: 0.5),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.accentColor.withOpacity(0.3),
                ),
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: AppTheme.accentColor,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.accentColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Change Profile Photo',
            style: TextStyle(
              color: AppTheme.accentColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.dividerColor, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: AppTheme.isDarkMode
                ? Colors.black.withOpacity(0.2)
                : Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal Information',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _nameController,
            label: 'Full Name',
            icon: Icons.person_outline_rounded,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: _emailController,
            label: 'Email',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: _phoneController,
            label: 'Phone Number',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: _bioController,
            label: 'Bio',
            icon: Icons.info_outline_rounded,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.dividerColor, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: AppTheme.isDarkMode
                ? Colors.black.withOpacity(0.2)
                : Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Privacy Settings',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textColor,
            ),
          ),
          const SizedBox(height: 12),
          _buildSwitchTile(
            title: 'Public Profile',
            subtitle: 'Allow others to view your profile',
            value: isPublic,
            onChanged: (val) => setState(() => isPublic = val),
          ),
          _buildSwitchTile(
            title: 'Activity Sharing',
            subtitle: 'Share your workouts with followers',
            value: isSharing,
            onChanged: (val) => setState(() => isSharing = val),
          ),
          _buildSwitchTile(
            title: 'Push Notifications',
            subtitle: 'Receive workout reminders',
            value: pushNotifications,
            onChanged: (val) => setState(() => pushNotifications = val),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.dividerColor, width: 0.5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: TextStyle(color: AppTheme.textColor),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: AppTheme.subtextColor, fontSize: 12),
          prefixIcon: Icon(icon, color: AppTheme.accentColor, size: 18),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SwitchListTile(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppTheme.textColor,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 12, color: AppTheme.subtextColor),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.accentColor,
        contentPadding: EdgeInsets.zero,
        tileColor: Colors.transparent,
      ),
    );
  }
}
