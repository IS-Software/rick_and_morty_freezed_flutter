import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rock_and_morty_freezed_flutter/bloc/character_bloc.dart';
import 'package:rock_and_morty_freezed_flutter/data/repository/character_repo.dart';
import 'package:rock_and_morty_freezed_flutter/ui/pages/search_page.dart';

class HomePage extends StatelessWidget {
  final String title;
  final repository = CharacterRepo();

  HomePage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black54,
        centerTitle: true,
        title: Text(
          title,
          style: Theme.of(context).textTheme.headline3,
        ),
      ),
      body: BlocProvider(
        create: (context) => CharacterBloc(characterRepo: repository),
        child: Container(
          color: Colors.black87,
          child: const SearchPage(),
        ),
      ),
    );
  }
}
