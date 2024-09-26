import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool _showThreadsBadge = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Edit profile'),
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
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.black,
                    child: Text('</>', style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(width: 16),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey[300],
                    child: Icon(Icons.face, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () {},
                child: const Text('Edit picture or avatar'),
              ),
            ),
            const SizedBox(height: 16),
            _buildTextField('Name', 'Huynh Anh Huy'),
            _buildTextField('Username', 'anhhuy_007'),
            _buildTextField('Pronouns', ''),
            _buildTextField('Bio', 'While ( i < you ) i++;'),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {},
              child: const Text('Add link'),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Add banners'),
            ),
            const SizedBox(height: 16),
            _buildDropdownField('Gender', 'Male'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Show Threads badge'),
                Switch(
                  value: _showThreadsBadge,
                  onChanged: (value) {
                    setState(() {
                      _showThreadsBadge = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {},
              child: const Text('Switch to professional account'),
            ),
            TextButton(
              onPressed: () {},
              child: const Text("Personal information settings"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String initialValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
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