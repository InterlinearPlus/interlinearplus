import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReaderSettingsPage extends StatefulWidget {
  @override
  _ReaderSettingsPageState createState() => _ReaderSettingsPageState();
}

class _ReaderSettingsPageState extends State<ReaderSettingsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  final TextEditingController _textController = TextEditingController();

  void _saveHighlightSettings() {
    if (_currentUser != null) {
      final userDocRef = _firestore.collection('users').doc(_currentUser!.uid);
      final highlightSettings = _textController.text.trim();

      userDocRef.update({
        'highlightSettings': FieldValue.arrayUnion([highlightSettings]),
      });

      _textController.clear();
    }
  }

  void _deleteHighlightSetting(String setting) {
    if (_currentUser != null) {
      final userDocRef = _firestore.collection('users').doc(_currentUser!.uid);

      userDocRef.update({
        'highlightSettings': FieldValue.arrayRemove([setting]),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reader Settings')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'e.g. Imperfect = Green',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveHighlightSettings,
              child: Text('Enter'),
            ),
            SizedBox(height: 16.0),
            if (_currentUser != null)
              StreamBuilder<DocumentSnapshot>(
                stream: _firestore.collection('users').doc(_currentUser!.uid).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data?.data() == null) {
                    return Container();
                  }

                  final userData = snapshot.data!.data() as Map<String, dynamic>;
                  final highlightSettings = List<String>.from(userData['highlightSettings'] ?? []);

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: highlightSettings.length,
                    itemBuilder: (context, index) {
                      final setting = highlightSettings[index];
                      return ListTile(
                        title: Text(setting),
                        trailing: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () => _deleteHighlightSetting(setting),
                        ),
                      );
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}