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
  CharactersPagination _charactersPagination =
      CharactersPagination(allCharacters: []);
  final _searchController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadCharacters();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _listViewWidth = _scrollController.position.viewportDimension;
    });
  }

  Future<void> _loadCharacters() async {
    final characters = await fetchMarvelCharacters();
    setState(() {
      _charactersPagination = CharactersPagination(allCharacters: characters);
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
      setState(() {
        _charactersPagination =
            CharactersPagination(allCharacters: filteredCharacters);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final characters = _charactersPagination.characters;
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
            child: ListView.separated(
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                height: 2,
                color: Color(0xffD42026),
                thickness: 1,
              ),
              itemCount: characters.length,
              itemBuilder: (context, index) {
                final character = characters[index];
                return _cardCharacter(
                  character: character,
                  onCardTap: (character) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CharacterDetails(
                                characterMarvel: character,
                              )),
                    );
                  },
                );
              },
            ),
          ),
          _buttonsPagination(),
          Container(
            height: 12,
            width: double.infinity,
            color: const Color(0xffD42026),
          ),
        ],
      ),
    );
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
              onTap: () {
                setState(() {
                  _charactersPagination.previousPage();
                });
              },
              child: const Icon(
                Icons.arrow_left,
                color: Color(0xffD42026),
                size: 60,
              ),
            ),
            Expanded(
                child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: _charactersPagination.totalPageCount,
              controller: _scrollController,
              itemBuilder: (context, index) {
                bool isSelected = _charactersPagination.currentPage == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _charactersPagination.goToPage(index);
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
                            color: const Color(0xffD42026), width: 1),
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
            )),
            GestureDetector(
              onTap: () {
                setState(() {
                  _charactersPagination.nextPage();
                });
              },
              child: const Icon(
                Icons.arrow_right_sharp,
                color: Color(0xffD42026),
                size: 60,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ScrollController _scrollController = ScrollController();

  void _scrollToSelected(int index) {
    final itemWidth = 32.0;
    final margin = 6.0;
    final listViewWidth = MediaQuery.of(context).size.width -
        60; // 60 is the total padding from left and right

    final selectedItemPosition =
        (itemWidth + margin) * index + itemWidth / 2 - listViewWidth / 2;

    _scrollController.animateTo(selectedItemPosition,
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  double _listViewWidth = 0;

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
