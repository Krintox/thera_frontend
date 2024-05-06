import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late String _username = ''; // Initialize with an empty string
  late String _email = ''; // Initialize with an empty string
  String _password = '********'; // Placeholder for password
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initializePreferences();
  }

  void _initializePreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _fetchUserProfile(); // Call fetchUserProfile after _prefs is initialized
  }

  Future<void> _fetchUserProfile() async {
    final String apiUrl = 'https://occ-therapy-backend.onrender.com/api/user/profile';
    final String jwtToken = _prefs.getString('jwtToken') ?? '';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Authorization': 'Bearer $jwtToken'},
    );

    if (response.statusCode == 200) {
      final userProfile = json.decode(response.body);
      setState(() {
        _username = userProfile['username'];
        _email = userProfile['email'];
      });
    } else {
      print('Failed to fetch user profile');
    }
  }

  Future<void> _updateUsername(String newUsername) async {
    final String apiUrl = 'https://occ-therapy-backend.onrender.com/api/user/update-username';
    final String jwtToken = _prefs.getString('jwtToken') ?? '';

    final Map<String, dynamic> data = {'username': newUsername};

    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      setState(() {
        _username = newUsername;
      });
      print('Username updated successfully');
    } else {
      print('Failed to update username');
    }
  }

  Future<void> _updateEmail(String newEmail) async {
    final String apiUrl = 'https://occ-therapy-backend.onrender.com/api/user/update-email';
    final String jwtToken = _prefs.getString('jwtToken') ?? '';

    final Map<String, dynamic> data = {'email': newEmail};

    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      setState(() {
        _email = newEmail;
      });
      print('Email updated successfully');
    } else {
      print('Failed to update email');
    }
  }

  Future<void> _updatePassword(String newPassword) async {
    final String apiUrl = 'https://occ-therapy-backend.onrender.com/api/user/update-password';
    final String jwtToken = _prefs.getString('jwtToken') ?? '';

    final Map<String, dynamic> data = {'password': newPassword};

    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      setState(() {
        _password = newPassword;
      });
      print('Password updated successfully');
    } else {
      print('Failed to update password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.green[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile Settings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            ListTile(
              title: Text(
                'Username',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                _username,
                style: TextStyle(color: Colors.grey),
              ),
              trailing: IconButton(
                icon: Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  // Add logic to edit username
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      backgroundColor: Colors.grey[800],
                      title: Text('Change Username', style: TextStyle(color: Colors.white)),
                      content: TextField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Enter new username',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        onChanged: (value) {
                          // Update username
                          _username = value;
                        },
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel', style: TextStyle(color: Colors.white)),
                        ),
                        TextButton(
                          onPressed: () async {
                            // Save changes to username
                            await _updateUsername(_username);
                            Navigator.pop(context);
                          },
                          child: Text('Save', style: TextStyle(color: Colors.green[200])),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Divider(color: Colors.grey[600]),
            ListTile(
              title: Text(
                'Email',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                _email,
                style: TextStyle(color: Colors.grey),
              ),
              trailing: IconButton(
                icon: Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  // Add logic to edit email
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      backgroundColor: Colors.grey[800],
                      title: Text('Change Email', style: TextStyle(color: Colors.white)),
                      content: TextField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Enter new email',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        onChanged: (value) {
                          // Update email
                          _email = value;
                        },
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel', style: TextStyle(color: Colors.white)),
                        ),
                        TextButton(
                          onPressed: () async {
                            // Save changes to email
                            await _updateEmail(_email);
                            Navigator.pop(context);
                          },
                          child: Text('Save', style: TextStyle(color: Colors.green[200])),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Divider(color: Colors.grey[600]),
            ListTile(
              title: Text(
                'Password',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                _password,
                style: TextStyle(color: Colors.grey),
              ),
              trailing: IconButton(
                icon: Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  // Add logic to edit password
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      backgroundColor: Colors.grey[800],
                      title: Text('Change Password', style: TextStyle(color: Colors.white)),
                      content: TextField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Enter new password',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        onChanged: (value) {
                          // Update password
                          _password = value;
                        },
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel', style: TextStyle(color: Colors.white)),
                        ),
                        TextButton(
                          onPressed: () async {
                            // Save changes to password
                            await _updatePassword(_password);
                            Navigator.pop(context);
                          },
                          child: Text('Save', style: TextStyle(color: Colors.green[200])),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
