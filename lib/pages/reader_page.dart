import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ReaderPage extends StatefulWidget {
  @override
  _ReaderPageState createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event.runtimeType == RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        _scrollController.animateTo(
          _scrollController.offset - 400,
          duration: Duration(milliseconds: 100),
          curve: Curves.easeInOut,
        );
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        _scrollController.animateTo(
          _scrollController.offset + 400,
          duration: Duration(milliseconds: 100),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Greek John Reader')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('GreekJohn')
            .orderBy('abspos')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final documents = snapshot.data!.docs;

          return RawKeyboardListener(
            focusNode: _focusNode,
            onKey: (event) {
              _handleKeyEvent(event);
            },
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: documents.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final previousData = documents.indexOf(doc) > 0
                        ? documents[documents.indexOf(doc) - 1].data() as Map<String, dynamic>
                        : null;
                    final showReference = previousData == null ||
                        data['book'] != previousData['book'] ||
                        data['chapter'] != previousData['chapter'] ||
                        data['verse'] != previousData['verse'];

                    return IntrinsicWidth(
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              showReference ? '${data['book']} ${data['chapter']}:${data['verse']}' : '',
                              style: TextStyle(fontFamily: 'Greek',),
                            ),
                            Text(
                              data['display'],
                              style: TextStyle(fontFamily: 'Greek', fontSize: 18,),
                            ),
                            Text(data['lemma'], style: TextStyle(fontFamily: 'Greek',)),
                            Text(data['parsing'], style: TextStyle(fontFamily: 'Greek',)),
                            Text(data['gloss'], style: TextStyle(fontFamily: 'Greek',)),
                            if (data['parse1'] != null && data['parse1'].isNotEmpty)
                              Text(data['parse1'], style: TextStyle(fontFamily: 'Greek',)),
                            if (data['parse2'] != null && data['parse2'].isNotEmpty)
                              Text(data['parse2'], style: TextStyle(fontFamily: 'Greek',)),
                            if (data['parse3'] != null && data['parse3'].isNotEmpty)
                              Text(data['parse3'], style: TextStyle(fontFamily: 'Greek',)),
                            if (data['parse4'] != null && data['parse4'].isNotEmpty)
                              Text(data['parse4'], style: TextStyle(fontFamily: 'Greek',)),
                            if (data['parse5'] != null && data['parse5'].isNotEmpty)
                              Text(data['parse5'], style: TextStyle(fontFamily: 'Greek',)),
                            if (data['parse6'] != null && data['parse6'].isNotEmpty)
                              Text(data['parse6'], style: TextStyle(fontFamily: 'Greek',)),
                            if (data['parse7'] != null && data['parse7'].isNotEmpty)
                              Text(data['parse7'], style: TextStyle(fontFamily: 'Greek',)),
                            if (data['parse8'] != null && data['parse8'].isNotEmpty)
                              Text(data['parse8'], style: TextStyle(fontFamily: 'Greek',)),
                            if (data['parse9'] != null && data['parse9'].isNotEmpty)
                              Text(data['parse9'], style: TextStyle(fontFamily: 'Greek',)),
                            if (data['parse10'] != null && data['parse10'].isNotEmpty)
                              Text(data['parse10'], style: TextStyle(fontFamily: 'Greek',)),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}