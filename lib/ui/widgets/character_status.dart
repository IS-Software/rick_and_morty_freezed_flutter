import 'package:flutter/material.dart';

class CharacterStatus extends StatelessWidget {
  final String liveState;

  const CharacterStatus({Key? key, required this.liveState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: liveState == 'Alive'
                ? Colors.green[400]
                : liveState == 'Dead'
                    ? Colors.red
                    : Colors.grey,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          liveState,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ],
    );
  }
}
