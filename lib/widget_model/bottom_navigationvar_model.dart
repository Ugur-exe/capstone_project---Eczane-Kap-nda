import 'package:flutter/material.dart';

class BottomNavigationBarModel with ChangeNotifier {
  int currentPageIndex = 0;
  void setCurrentPageIndex(int index) {
    currentPageIndex = index;
    notifyListeners();
  }

  int get getCurrentPageIndex => currentPageIndex;

  int pages = 0;
  void setPages(int page) {
    pages = page;
    notifyListeners();
  }

  int get getPages => pages;
}
