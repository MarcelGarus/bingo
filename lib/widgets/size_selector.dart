import 'package:flutter/material.dart';

const kMinimumSize = 2;

class SizeSelectionController extends ValueNotifier<int> {
  SizeSelectionController() : super(kMinimumSize);

  int get size => value;
  set size(int s) => value = s;
}

class SizeSelector extends StatefulWidget {
  SizeSelector({@required this.controller}) : assert(controller != null);

  final SizeSelectionController controller;

  @override
  _SizeSelectorState createState() => _SizeSelectorState();
}

class _SizeSelectorState extends State<SizeSelector> {
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (i) {
        var size = kMinimumSize + i;
        return SizeButton(
          size: size,
          isEnabled: size == widget.controller.size,
          onPressed: () => setState(() => widget.controller.size = size),
        );
      }),
    );
  }
}

class SizeButton extends StatelessWidget {
  const SizeButton({
    @required this.size,
    @required this.isEnabled,
    @required this.onPressed,
  });

  final int size;
  final bool isEnabled;
  final VoidCallback onPressed;

  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: isEnabled ? Colors.transparent : Colors.black,
            width: isEnabled ? 0 : 2,
          ),
          borderRadius: BorderRadius.circular(16),
          color: isEnabled ? Colors.white : Colors.white12,
        ),
        width: 48,
        height: 48,
        alignment: Alignment.center,
        child: Text('${size}x$size'),
      ),
    );
  }
}
