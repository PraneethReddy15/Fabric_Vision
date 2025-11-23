import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as p;

class RecentsScreen extends StatefulWidget {
  const RecentsScreen({super.key});

  static Future<void> addToRecents(String path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> recents = prefs.getStringList('recents') ?? [];
    String normalizedPath = p.normalize(path);

    if (!recents.contains(normalizedPath)) {
      recents.add(normalizedPath);
      await prefs.setStringList('recents', recents);
    }
  }

  @override
  _RecentsScreenState createState() => _RecentsScreenState();
}

class _RecentsScreenState extends State<RecentsScreen>
    with SingleTickerProviderStateMixin {
  List<String> recents = [];
  List<DateTime> lastModifiedList = [];

  @override
  void initState() {
    super.initState();
    _loadRecents();
  }

  Future<void> _loadRecents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> storedRecents = prefs.getStringList('recents') ?? [];

    final now = DateTime.now();
    final cutoff = now.subtract(Duration(days: 30));

    List<String> valid = [];
    List<DateTime> validDates = [];

    for (var path in storedRecents) {
      final file = File(path);
      if (await file.exists()) {
        final modified = await file.lastModified();
        if (modified.isAfter(cutoff)) {
          valid.add(path);
          validDates.add(modified);
        } else {
          await file.delete();
        }
      }
    }

    setState(() {
      recents = valid;
      lastModifiedList = validDates;
    });

    await prefs.setStringList('recents', valid);
  }

  Future<void> _deleteRecent(int index) async {
    final file = File(recents[index]);

    if (await file.exists()) {
      await file.delete();
    }

    setState(() {
      recents.removeAt(index);
      lastModifiedList.removeAt(index);
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('recents', recents);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text(
          "Recents",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
      ),

      // ------------------- EMPTY STATE UI -------------------
      body: recents.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image_not_supported_outlined,
                    size: 100, color: Colors.grey[500]),
                SizedBox(height: 16),
                Text(
                  "No Recent Images",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 6),
                Text(
                  "Your scanned images will appear here",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            )

          // ------------------- GRID UI -------------------
          : GridView.builder(
              padding: EdgeInsets.all(10),
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: recents.length,
              itemBuilder: (context, index) {
                final modified = lastModifiedList[index];
                final deletionDate = modified.add(Duration(days: 30));
                final remaining = deletionDate.difference(DateTime.now()).inDays;

                final daysLeft = remaining > 0
                    ? "$remaining days left"
                    : "Deleting soon";

                return _RecentTile(
                  imagePath: recents[index],
                  daysLeft: daysLeft,
                  onDelete: () => _deleteRecent(index),
                  onTap: () => Navigator.pop(context, recents[index]),
                );
              },
            ),
    );
  }
}

class _RecentTile extends StatefulWidget {
  final String imagePath;
  final String daysLeft;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const _RecentTile({
    required this.imagePath,
    required this.daysLeft,
    required this.onDelete,
    required this.onTap,
  });

  @override
  State<_RecentTile> createState() => _RecentTileState();
}

class _RecentTileState extends State<_RecentTile>
    with SingleTickerProviderStateMixin {
  double scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => scale = 0.95),
      onTapUp: (_) {
        setState(() => scale = 1.0);
        widget.onTap();
      },
      onTapCancel: () => setState(() => scale = 1.0),

      child: AnimatedScale(
        scale: scale,
        duration: Duration(milliseconds: 140),
        curve: Curves.easeOut,

        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              // IMAGE
              Positioned.fill(
                child: Hero(
                  tag: widget.imagePath,
                  child: Image.file(
                    File(widget.imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // GRADIENT OVERLAY
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black45,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),

              // DAYS LEFT LABEL
              Positioned(
                left: 4,
                bottom: 4,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    widget.daysLeft,
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),

              // DELETE BUTTON
              Positioned(
                top: 2,
                right: 2,
                child: GestureDetector(
                  onTap: widget.onDelete,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
