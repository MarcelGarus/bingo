import 'package:flutter/material.dart';

class SizeSelector extends ImplicitlyAnimatedWidget {
  SizeSelector({
    @required this.sizes,
    @required int selectedSize,
    @required this.onSizeSelected,
  })  : assert(sizes != null),
        assert(selectedSize != null),
        assert(sizes.contains(selectedSize)),
        selectedSizeIndex = sizes.indexOf(selectedSize),
        assert(onSizeSelected != null),
        super(
          duration: Duration(milliseconds: 40),
          curve: Curves.easeInOutCubic,
        );

  final List<int> sizes;
  final int selectedSizeIndex;
  final void Function(int size) onSizeSelected;

  _SizeSelectorState createState() => _SizeSelectorState();
}

class _SizeSelectorState extends AnimatedWidgetBaseState<SizeSelector> {
  Tween<double> _valueTween;

  int get _selectedSize => widget.sizes[widget.selectedSizeIndex];
  double get _value => _valueTween.evaluate(animation);

  void forEachTween(visitor) {
    _valueTween = visitor(
      _valueTween,
      widget.selectedSizeIndex.toDouble() / (widget.sizes.length - 1),
      (val) => Tween<double>(begin: val),
    );
  }

  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return GestureDetector(
              onHorizontalDragUpdate: (details) {
                var globalOffset = details.globalPosition;
                RenderBox renderBox = context.findRenderObject();
                var localOffset = renderBox.globalToLocal(globalOffset);
                var valuePercentage =
                    (localOffset.dx / constraints.maxWidth).clamp(0.0, 1.0);
                var index =
                    (valuePercentage * (widget.sizes.length - 1)).round();
                widget.onSizeSelected(widget.sizes[index]);
              },
              child: Stack(
                children: [
                  _buildBar(constraints),
                  _buildKnob(constraints),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBar(BoxConstraints constraints) {
    var barWidth = constraints.maxWidth - 32;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      height: 8,
      decoration:
          ShapeDecoration(color: Colors.white24, shape: StadiumBorder()),
      alignment: Alignment.centerLeft,
      child: Container(
        width: barWidth * _value,
        decoration:
            ShapeDecoration(color: Colors.white70, shape: StadiumBorder()),
      ),
    );
  }

  Widget _buildKnob(BoxConstraints constraints) {
    var barWidth = constraints.maxWidth - 32;

    return Container(
      margin: EdgeInsets.only(left: barWidth * _value),
      width: 32,
      height: 32,
      child: Material(
        color: Colors.white,
        elevation: 4,
        shadowColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Center(
          child: Text(
            '$_selectedSize x $_selectedSize',
            style: TextStyle(fontSize: 12),
          ),
        ),
      ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 150),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: isEnabled ? Colors.white70 : Colors.white24,
          ),
          width: 48,
          height: 48,
          alignment: Alignment.center,
          child: Text('${size}x$size'),
        ),
      ),
    );
  }
}
