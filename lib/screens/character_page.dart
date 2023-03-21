import 'package:flutter/material.dart';
import '../controller/character_list_controller.dart';
import '../controller/pagination.dart';
import '../model/character.dart';
import 'description_character.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({super.key});

  @override
  _CharactersScreenState createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  CharactersPagination _charactersPagination = CharactersPagination(
    allCharacters: [],
    dataMarvel:
        DataMarvel(offset: 0, limit: 4, total: 1562, count: 4, results: []),
  );
  final _searchController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  double _listViewWidth = 0;
  int offSet = 0;
  DataMarvel data =
      DataMarvel(offset: 0, limit: 0, total: 0, count: 0, results: []);
  int qtd = 0;
  var isLoading = false;
  List<CharactersMarvel> filteredCharacters = [];

  @override
  void initState() {
    super.initState();
    _loadCharacters();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _listViewWidth = _scrollController.position.viewportDimension;
    });
  }

  Future<void> _loadCharacters() async {
    setState(() {
      isLoading = true;
    });
    var load = await fetchMarvelCharacters(0);
    setState(() {
      data = load;
      qtd = data.total;
      _charactersPagination = CharactersPagination(
        allCharacters: data.results,
        dataMarvel: data,
      );
      isLoading = false;
    });
  }

  void _filterCharacters(String query) {
    if (query.isEmpty) {
      _loadCharacters();
    } else {
      final filteredCharacters =
          _charactersPagination.allCharacters.where((character) {
        final nameLower = character.name.toLowerCase();
        final queryLower = query.toLowerCase();
        return nameLower.contains(queryLower);
      }).toList();
      final filteredData = DataMarvel(
        offset: _charactersPagination.dataMarvel.offset,
        limit: _charactersPagination.dataMarvel.limit,
        total: filteredCharacters.length,
        count: filteredCharacters.length,
        results: filteredCharacters,
      );
      setState(() {
        _charactersPagination = CharactersPagination(
          allCharacters: filteredCharacters,
          dataMarvel: filteredData,
        );
      });
    }
  }

  buildList() async {
    setState(() {
      isLoading = true;
    });
    var marvel = await fetchMarvelCharacters(offSet);
    setState(() {
      data = marvel;
      qtd = _charactersPagination.totalPageCount;
      _charactersPagination =
          CharactersPagination(allCharacters: data.results, dataMarvel: data);
      filteredCharacters = _charactersPagination.allCharacters;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        _header(),
        Container(
          height: 37,
          width: double.infinity,
          color: const Color(0xffD42026),
          child: const Align(
            child: Text(
              "Maria Júlia Bochembuzo",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
          ),
        ),
        Expanded(
          child: !isLoading
              ? ListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(
                    height: 2,
                    color: Color(0xffD42026),
                    thickness: 1,
                  ),
                  itemCount: _charactersPagination.dataMarvel.results.length,
                  itemBuilder: (context, index) {
                    final character =
                        _charactersPagination.dataMarvel.results[index];
                    return _cardCharacter(
                      character: character,
                      onCardTap: (character) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CharacterDetails(
                              characterMarvel: character,
                            ),
                          ),
                        );
                      },
                    );
                  },
                )
              : const Center(
                  child: CircularProgressIndicator(
                  color: Color(0xffD42026),
                )),
        ),
        _buttonsPagination(),
        Container(
          height: 12,
          width: double.infinity,
          color: const Color(0xffD42026),
        ),
      ],
    ));
  }

  Widget _header() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 35, top: 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Text(
                  "BUSCA MARVEL",
                  style: TextStyle(
                      color: Color(0xffD42026),
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "TESTE FRONT-END",
                  style: TextStyle(
                      color: Color(0xffD42026),
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w300),
                ),
              ],
            ),
            const SizedBox(height: 3),
            Container(
              width: 54,
              height: 4,
              color: const Color(0xffD42026),
            ),
            const SizedBox(height: 12),
            const Text(
              "Nome do Personagem",
              style: TextStyle(
                color: Color(0xffD42026),
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12, right: 35),
              child: Container(
                height: 31,
                child: TextFormField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  onChanged: _filterCharacters,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buttonsPagination() {
    bool isFirstPage = offSet == 0;
    bool isLastPage = offSet == qtd - 1;

    return Container(
      height: 74,
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color(0xffD42026),
            width: 1,
          ),
          bottom: BorderSide.none,
          left: BorderSide.none,
          right: BorderSide.none,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 30, left: 30),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: isFirstPage
                  ? null
                  : () {
                      setState(() {
                        offSet -= 1;
                        buildList();
                      });
                    },
              child: Icon(
                Icons.arrow_left,
                color: isFirstPage ? Colors.grey : const Color(0xffD42026),
                size: 60,
              ),
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: qtd,
                controller: _scrollController,
                itemBuilder: (context, index) {
                  bool isSelected = _charactersPagination.currentPage == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        offSet = index;
                        buildList();
                      });
                      _scrollToSelected(index);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 6, left: 6),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? Colors.red : Colors.white,
                          border: Border.all(
                            color: const Color(0xffD42026),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            (index + 1).toString(),
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xffD42026),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            GestureDetector(
              onTap: isLastPage
                  ? null
                  : () {
                      setState(() {
                        offSet += 1;
                        buildList();
                      });
                    },
              child: Icon(
                Icons.arrow_right_sharp,
                color: isLastPage ? Colors.grey : const Color(0xffD42026),
                size: 60,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _scrollToSelected(int index) {
    const itemWidth = 32.0;
    const margin = 6.0;
    final listViewWidth = MediaQuery.of(context).size.width - 60;

    final selectedItemPosition =
        (itemWidth + margin) * index + itemWidth / 2 - listViewWidth / 2;

    _scrollController.animateTo(selectedItemPosition,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  Widget _cardCharacter(
      {required CharactersMarvel character, required Function onCardTap}) {
    return InkWell(
      onTap: () => onCardTap(character),
      child: Container(
        height: 95,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              child: Padding(
                padding: const EdgeInsets.only(top: 18, bottom: 18),
                child: ClipOval(
                  child: Image.network(
                    '${character.thumbnail.path}.${character.thumbnail.extension}',
                    width: 58,
                    height: 58,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Align(
              child: Text(
                character.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
