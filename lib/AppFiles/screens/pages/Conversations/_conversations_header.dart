import 'package:flutter/material.dart';
import 'package:odlay_services/Styles/styles.dart';

class Conversationtionsheader extends StatefulWidget {
  @override
  State<Conversationtionsheader> createState() =>
      _ConversationtionsheaderState();
}

class _ConversationtionsheaderState extends State<Conversationtionsheader> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text("Conversations"),
        backgroundColor: Colors.orange[900],
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        )),
      ),
      body: Container(
        child: Text(
          "Conversation Here",
          style: Styles.simpletextStyleGigColor,
        ),
      ),
    );
  }
}
