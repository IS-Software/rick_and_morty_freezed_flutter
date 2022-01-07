import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rock_and_morty_freezed_flutter/bloc/character_bloc.dart';
import 'package:rock_and_morty_freezed_flutter/data/models/character.dart';
import 'package:rock_and_morty_freezed_flutter/ui/widgets/custom_list_tile.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late Character _currentCharacter;
  List<Results> _currentResults = [];
  int _currentPage = 1;
  String _currentSearchString = '';

  final RefreshController _refreshController = RefreshController();
  bool _isPagination = false;

  Timer? _searchDebounce;

  @override
  void initState() {
    if (_currentResults.isEmpty) {
      if (_currentResults.isEmpty) {
        context
            .read<CharacterBloc>()
            .add(const CharacterEvent.fetch(name: '', page: 1));
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //release pattern 'Matching'
    final state = context.watch<CharacterBloc>().state;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //search
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: TextField(
            style: const TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color.fromRGBO(86, 86, 86, 0.8),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none),
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
              hintText: 'Search name',
              hintStyle: const TextStyle(
                color: Colors.white,
              ),
            ),
            onChanged: (value) {
              _currentPage = 1;
              _currentResults = [];
              _currentSearchString = value;

              _searchDebounce?.cancel();
              _searchDebounce = Timer(const Duration(microseconds: 500), () {
                context
                    .read<CharacterBloc>()
                    .add(CharacterEvent.fetch(name: value, page: _currentPage));
              });
            },
          ),
        ),
        //BLoC module
        Expanded(
          child: state.when(
            loading: () {
              if (!_isPagination) {
                return Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                      SizedBox(width: 10),
                      Text('Loading...')
                    ],
                  ),
                );
              } else {
                return _customListView(_currentResults);
              }
            },
            loaded: (characterLoaded) {
              _currentCharacter = characterLoaded;
              if (_isPagination) {
                _currentResults.addAll(_currentCharacter.results);
                _refreshController.loadComplete();
                _isPagination = false;
              } else {
                _currentResults = _currentCharacter.results;
              }
              return _currentResults.isNotEmpty
                  ? _customListView(characterLoaded.results)
                  : Container();
            },
            error: () => const Text('Nothing found...'),
          ),
        ),
      ],
    );
  }

  Widget _customListView(List<Results> charactersList) => SmartRefresher(
        controller: _refreshController,
        enablePullUp: true,
        enablePullDown: false,
        onLoading: () {
          _isPagination = true;
          _currentPage++;
          if (_currentPage <= _currentCharacter.info.pages) {
            context.read<CharacterBloc>().add(CharacterEvent.fetch(
                name: _currentSearchString, page: _currentPage));
          } else {
            _refreshController.loadNoData();
          }
        },
        child: ListView.separated(
          shrinkWrap: true,
          separatorBuilder: (_, index) => const SizedBox(height: 5),
          itemCount: charactersList.length,
          itemBuilder: (context, index) {
            final character = charactersList[index];
            return CustomListTile(result: character);
          },
        ),
      );
}
