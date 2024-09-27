import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/core/utils/navigator_services.dart';
import 'package:tiktok_clone/core/utils/size_utils.dart';
import 'package:tiktok_clone/presentation/profile/profile_page_container/models/profile_page_container_model.dart';
import 'package:tiktok_clone/presentation/profile/profile_page_container/notifiers/profile_page_container_notifier.dart';
import 'package:tiktok_clone/presentation/reels/notifiers/feed_providers.dart';
import 'package:tiktok_clone/route/app_routes.dart';
import '../../../../widget/custom_image_view.dart';

class CreateProfilePage extends ConsumerStatefulWidget {
  const CreateProfilePage({required this.userModel, super.key});
  final UserInfoModel userModel;

  @override
  _CreateProfilePageState createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends ConsumerState<CreateProfilePage> {
  bool _darkMode = false;
  bool _showEditNewThumbnail = false;
  File? _profileImage;
  File? _thumbnailImage;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _handleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isUploading = false;

  Future<void> _pickImage(ImageSource source, bool isProfileImage) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        if (isProfileImage) {
          _profileImage = File(pickedFile.path);
        } else {
          _thumbnailImage = File(pickedFile.path);
        }
      });
    }
  }

  void _showImageSourceActionSheet(bool isProfileImage) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery, isProfileImage);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take a Photo'),
                onTap: () {
                  _pickImage(ImageSource.camera, isProfileImage);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController.text = widget.userModel.name;
    _handleController.text = widget.userModel.handle;
    _descriptionController.text = widget.userModel.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit profile',
            style: TextStyle(color: Colors.black, fontSize: 24)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => _showImageSourceActionSheet(true),
                    child: _profileImage != null
                        ? CircleAvatar(
                      radius: 35,
                      backgroundImage: FileImage(_profileImage!),
                    )
                        : CustomImageView(
                      imagePath: widget.userModel.avatarUrl,
                      height: 70.adaptSize,
                      width: 70.adaptSize,
                      borderRadius: BorderRadius.circular(60.h),
                    ),
                  ),
                  const SizedBox(width: 16),
                  InkWell(
                    onTap: () => _showImageSourceActionSheet(true),
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.grey[300],
                      child: Icon(Icons.face, color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () => _showImageSourceActionSheet(true),
                child: const Text('Edit picture or avatar'),
              ),
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField('Name', _nameController),
                  _buildTextField('Handle', _handleController),
                  _buildTextField('Description', _descriptionController),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildDropdownField('Gender', 'Male'),
            const SizedBox(height: 16),
            InkWell(
              onTap: () {
                setState(() {
                  _showEditNewThumbnail = !_showEditNewThumbnail;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Change channel thumbnail'),
                  IconButton(
                    onPressed: () => _showImageSourceActionSheet(false),
                    icon: const Icon(Icons.image_outlined),
                  ),
                ],
              ),
            ),
            if (_showEditNewThumbnail)
              GestureDetector(
                onTap: () => _showImageSourceActionSheet(false),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Center(
                      child: _thumbnailImage != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(10.h),
                        child: Image.file(
                          _thumbnailImage!,
                          height: 170.adaptSize,
                          width: 1000.adaptSize,
                          fit: BoxFit.cover,
                        ),
                      )
                          : CustomImageView(
                        imagePath: widget.userModel.thumbnailUrl,
                        height: 170.adaptSize,
                        width: 1000.adaptSize,
                        borderRadius: BorderRadius.circular(10.h),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: TextButton(
                        onPressed: () => _showImageSourceActionSheet(false),
                        child: const Text('Add new thumbnail'),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Dark mode'),
                Switch(
                  value: _darkMode,
                  onChanged: (value) {
                    setState(() {
                      _darkMode = value;
                    });
                  },
                ),
              ],
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Switch to professional account'),
            ),
            TextButton(
              onPressed: () {},
              child: const Text("Personal information settings"),
            ),
            const SizedBox(height: 26),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 170.h,
                  child: OutlinedButton(
                      onPressed: () {
                        NavigatorService.goBack();
                      },
                      child: const Text('Cancel')),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 170.h,
                  child: ElevatedButton(
                    onPressed: () {
                      _onEditProfileSubmit();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    child: _isUploading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white))
                        : const Text('Confirm',
                        style: TextStyle(color: Colors.white)),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _onEditProfileSubmit() async {
    // check if the form is valid
    if (_formKey.currentState!.validate()) {
      // upload images to firebase storage
      _isUploading = true;

      final FirebaseStorage storage = FirebaseStorage.instance;
      String avatarFilePath = 'image/avatar/${DateTime.now()}.png';
      String thumbnailFilePath = 'image/thumbnail/${DateTime.now()}.png';

      String avatarUrl = widget.userModel.avatarUrl;
      String thumbnailUrl = widget.userModel.thumbnailUrl;

      if (_profileImage != null) {
        await storage.ref(avatarFilePath).putFile(_profileImage!);
        avatarUrl = await storage.ref(avatarFilePath).getDownloadURL();
      }

      if (_thumbnailImage != null) {
        await storage.ref(thumbnailFilePath).putFile(_thumbnailImage!);
        thumbnailUrl = await storage.ref(thumbnailFilePath).getDownloadURL();
      }

      bool result = await ref.read(apiServiceProvider).updateProfile(
        userId: widget.userModel.userId,
        name: _nameController.text.trim(),
        handle: _handleController.text.trim(),
        description: _descriptionController.text.trim(),
        avatarUrl: avatarUrl,
        thumbnailUrl: thumbnailUrl,
      );

      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created successfully, please login to continue')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile')),
        );

        _isUploading = false;
        return;
      }

      _isUploading = false;
      NavigatorService.popAndPushNamed(AppRoutes.loginPage);
    }
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field should not be empty';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDropdownField(String label, String initialValue) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      value: initialValue,
      items: ['Male', 'Female', 'Other'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (value) {},
    );
  }
}
