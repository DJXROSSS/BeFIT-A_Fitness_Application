import '../services/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  final String currentName;
  final String currentEmail;
  final String currentPhotoUrl;

  const EditProfilePage({
    Key? key,
    required this.currentName,
    required this.currentEmail,
    required this.currentPhotoUrl,
  }) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _photoUrlController;
  bool isSaving = false;

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.currentName);
    _emailController = TextEditingController(text: widget.currentEmail);
    _photoUrlController = TextEditingController(text: widget.currentPhotoUrl);
    super.initState();
  }

  Future<void> saveChanges() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => isSaving = true);

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
            'name': _nameController.text,
            'email': _emailController.text,
            'photoUrl': _photoUrlController.text,
          });

      // Optionally update FirebaseAuth user info
      await user.updateDisplayName(_nameController.text);
      await user.updateEmail(_emailController.text);
      await user.updatePhotoURL(_photoUrlController.text);

      Navigator.pop(context, true); // Indicate changes were made
    } catch (e) {
      print("Error saving profile changes: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save changes. Please try again.")),
      );
    } finally {
      setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: AppTheme.cardColor,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        children: [
          const SizedBox(height: 8),
          _buildSectionTitle("Basic Information"),
          const SizedBox(height: 16),
          _buildTextField(
            "Full Name",
            _nameController,
            Icons.person_outline_rounded,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            "Email Address",
            _emailController,
            Icons.email_outlined,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            "Photo URL",
            _photoUrlController,
            Icons.image_outlined,
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 54,
            child: ElevatedButton.icon(
              onPressed: isSaving ? null : saveChanges,
              icon: isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.save_rounded),
              label: Text(isSaving ? "Saving..." : "Save Changes"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppTheme.textColor,
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.dividerColor, width: 0.5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: controller,
        style: TextStyle(color: AppTheme.textColor, fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: AppTheme.subtextColor,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(icon, color: AppTheme.accentColor, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}
