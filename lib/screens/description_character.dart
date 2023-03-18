import 'package:flutter/material.dart';
import '../model/character.dart';

class CharacterDetails extends StatefulWidget {
  final CharactersMarvel characterMarvel;

  const CharacterDetails({Key? key, required this.characterMarvel})
      : super(key: key);

  @override
  State<CharacterDetails> createState() => _CharacterDetailsState();
}

class _CharacterDetailsState extends State<CharacterDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffD42026),
        title: const Text('Descrição'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
                '${widget.characterMarvel.thumbnail.path}.${widget.characterMarvel.thumbnail.extension}'),
            const SizedBox(height: 16.0),
            Text(
              widget.characterMarvel.name,
              style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffD42026)),
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                  text: widget.characterMarvel.description == ''
                      ? "Sem descrição"
                      : widget.characterMarvel.description,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
