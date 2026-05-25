import 'package:flutter/material.dart';
import 'package:remote/constants/key_codes.dart';
import 'package:remote/ui/widgets/remote_controls/components/controller_button.dart';
import 'package:remote/ui/widgets/remote_controls/tv_actions.dart';

class DirectionKeys extends StatelessWidget {
  const DirectionKeys({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Semantics(
              label: 'Smart hub',
              button: true,
              child: ControllerButton(
                onPressed: () => context.sendTvKey(KeyCodes.KEY_HOME),
                child: const _CornerLabel('SMART'),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Semantics(
              label: 'Input source',
              button: true,
              child: ControllerButton(
                onPressed: () => context.sendTvKey(KeyCodes.KEY_SOURCE),
                child: const _CornerLabel('INPUT'),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Semantics(
              label: 'Back',
              button: true,
              child: ControllerButton(
                onPressed: () => context.sendTvKey(KeyCodes.KEY_RETURN),
                child: const _CornerLabel('BACK'),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Semantics(
              label: 'Exit',
              button: true,
              child: ControllerButton(
                onPressed: () => context.sendTvKey(KeyCodes.KEY_EXT41),
                child: const _CornerLabel('EXIT'),
              ),
            ),
          ),
          Align(
            child: Semantics(
              label: 'OK',
              button: true,
              child: ControllerButton(
                onPressed: () => context.sendTvKey(KeyCodes.KEY_ENTER),
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0, -0.6),
            child: Semantics(
              label: 'Up',
              button: true,
              child: ControllerButton(
                borderRadius: 10,
                onPressed: () => context.sendTvKey(KeyCodes.KEY_UP),
                child: const Icon(Icons.arrow_drop_up,
                    size: 30, color: Colors.white),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0, 0.6),
            child: Semantics(
              label: 'Down',
              button: true,
              child: ControllerButton(
                borderRadius: 10,
                onPressed: () => context.sendTvKey(KeyCodes.KEY_DOWN),
                child: const Icon(Icons.arrow_drop_down,
                    size: 30, color: Colors.white),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0.6, 0),
            child: Semantics(
              label: 'Right',
              button: true,
              child: ControllerButton(
                borderRadius: 10,
                onPressed: () => context.sendTvKey(KeyCodes.KEY_RIGHT),
                child: const Icon(Icons.arrow_right,
                    size: 30, color: Colors.white),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(-0.7, 0),
            child: Semantics(
              label: 'Left',
              button: true,
              child: ControllerButton(
                borderRadius: 10,
                onPressed: () => context.sendTvKey(KeyCodes.KEY_LEFT),
                child: const Icon(Icons.arrow_left,
                    size: 30, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CornerLabel extends StatelessWidget {
  const _CornerLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: Colors.white54,
      ),
    );
  }
}
