import '../model/character.dart';

class CharactersPagination {
  final List<CharactersMarvel> allCharacters;
  late DataMarvel dataMarvel;

  CharactersPagination({required this.allCharacters, required this.dataMarvel});

  List<CharactersMarvel> get characters {
    final startIndex = dataMarvel.offset * dataMarvel.limit;
    final endIndex = (startIndex + dataMarvel.limit).clamp(0, dataMarvel.total);
    return allCharacters.sublist(startIndex, endIndex);
  }

  int get pageCount {
    return (dataMarvel.total / dataMarvel.limit).ceil();
  }

  bool get isFirstPage {
    return dataMarvel.offset == 0;
  }

  bool get isLastPage {
    return dataMarvel.offset == pageCount - 1;
  }

  int get currentPage {
    return dataMarvel.offset;
  }

  int getTotalPages(int totalElements, int elementsPerPage) {
    return (totalElements / elementsPerPage).ceil();
  }

  int get totalPageCount {
    return getTotalPages(dataMarvel.total, dataMarvel.limit);
  }
}
