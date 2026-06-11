import 'package:flutter/material.dart';
import 'history_manager.dart';
import 'l10n/app_localizations.dart';


class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xff0F172A),
        title:  Text(
          AppLocalizations.of(context)!.history,
            //"History",
          style: TextStyle(
            color: Colors.white
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // ياحمار ده بيغير لون السهم
        ),
      ),
      body: ListView.builder(
        itemCount: HistoryManager.history.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              HistoryManager.history[index],
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}