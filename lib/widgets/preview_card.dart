import 'package:flutter/material.dart';

import '../utils.dart';

class PreviewCard extends StatelessWidget {
  const PreviewCard({
    Key key,
    @required this.title,
    @required this.board,
    @required this.footer,
    this.onTap,
  }) : super(key: key);

  final String title;
  final Widget board;
  final Widget footer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.theme.primaryColor,
      elevation: 4,
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 24)),
                SizedBox(height: 16),
                FittedBox(child: board),
                SizedBox(height: 16),
                Center(child: footer),
              ],
            ),
          ),
          Positioned.fill(
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: onTap,
              ),
            ),
          )
        ],
      ),
    );
  }
}
