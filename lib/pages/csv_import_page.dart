import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';

class CsvImportPage extends StatefulWidget {
  @override
  _CsvImportPageState createState() => _CsvImportPageState();
}

class _CsvImportPageState extends State<CsvImportPage> {
  String _collectionName = '';

  void _importCsv(List<List<dynamic>> data) {
    if (data.isEmpty) return;

    final headers = data[0].cast<String>();
    final rows = data.skip(1).toList();

    final collectionRef = FirebaseFirestore.instance.collection(_collectionName);

    rows.forEach((row) {
      final rowData = Map<String, dynamic>.fromIterables(headers, row);
      collectionRef.add(rowData);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('CSV data imported successfully')),
    );
  }

  Future<void> _uploadCsv() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'tsv'],
    );

    if (result != null) {
      final file = result.files.first;
      final fileBytes = file.bytes;

      if (fileBytes != null) {
        final csvString = String.fromCharCodes(fileBytes);
        final List<List<dynamic>> csvData =
            const CsvToListConverter().convert(csvString);
        _importCsv(csvData);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CSV Import')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onChanged: (value) => _collectionName = value,
              decoration: InputDecoration(
                labelText: 'Collection Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadCsv,
              child: Text('Upload CSV'),
            ),
          ],
        ),
      ),
    );
  }
}