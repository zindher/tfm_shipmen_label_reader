import 'package:flutter/material.dart';

class ProgressBar {
  ProgressBar._internal();

  static final ProgressBar _instance = ProgressBar._internal();
  static ProgressBar get instance => _instance;
  late OverlayEntry _progressOverlayEntry;

  void show(BuildContext context) {
    _progressOverlayEntry = _createdProgressEntry(context);
    Overlay.of(context).insert(_progressOverlayEntry);
  }

  void hide() {
    _progressOverlayEntry.remove();
  }

  OverlayEntry _createdProgressEntry(BuildContext context) => OverlayEntry(
      builder: (BuildContext context) => Stack(
            children: [
              Container(
                color: Colors.grey.withOpacity(0.5),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height / 2,
                left: MediaQuery.of(context).size.width / 2,
                child: CircularProgressIndicator(),
              )
            ],
          ));
}