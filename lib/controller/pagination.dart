import '../model/character.dart';

class CharactersPagination {
  final List<CharactersMarvel> allCharacters;
  final int itemsPerPage;

  CharactersPagination({required this.allCharacters, this.itemsPerPage = 4});

  int _currentPage = 0;

  List<CharactersMarvel> get characters {
    final startIndex = _currentPage * itemsPerPage;
    final endIndex = (startIndex + itemsPerPage).clamp(0, allCharacters.length);
    return allCharacters.sublist(startIndex, endIndex);
  }

  int get pageCount {
    return (allCharacters.length / itemsPerPage).ceil();
  }

  void nextPage() {
    if (_currentPage < pageCount - 1) {
      _currentPage++;
    }
  }

  void goToPage(int page) {
    if (page >= 0 && page < pageCount) {
      _currentPage = page;
    }
  }

  void previousPage() {
    if (_currentPage > 0) {
      _currentPage--;
    }
  }

  bool get isFirstPage {
    return _currentPage == 0;
  }

  bool get isLastPage {
    return _currentPage == pageCount - 1;
  }

  int get currentPage {
    return _currentPage;
  }

  int getTotalPages(int totalElements, int elementsPerPage) {
    return (totalElements / elementsPerPage).ceil();
  }

  int get totalPageCount {
    return getTotalPages(allCharacters.length, itemsPerPage);
  }
}
