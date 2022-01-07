import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rock_and_morty_freezed_flutter/data/models/character.dart';
import 'package:rock_and_morty_freezed_flutter/ui/widgets/character_status.dart';

class CustomListTile extends StatelessWidget {
  final Results result;

  const CustomListTile({Key? key, required this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        height: MediaQuery.of(context).size.height / 7,
        color: const Color.fromRGBO(87, 87, 87, 0.8),
        child: Row(
          children: [
            CachedNetworkImage(
              imageUrl: result.image,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(
                  color: Colors.grey,
                ),
              ),
              errorWidget: (context, url, error) => const Icon(
                Icons.error,
                color: Colors.grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.name,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  const SizedBox(height: 8),
                  CharacterStatus(liveState: result.status),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Species',
                              style: Theme.of(context).textTheme.caption,
                            ),
                            Text(
                              result.species,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyText1,
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Gender',
                              style: Theme.of(context).textTheme.caption,
                            ),
                            Text(
                              result.gender,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyText1,
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
