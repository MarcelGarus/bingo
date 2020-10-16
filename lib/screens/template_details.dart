import 'package:flutter/material.dart';

// class TemplateScreen extends StatefulWidget {
//   @override
//   _TemplateScreenState createState() => _TemplateScreenState();
// }

// class _TemplateScreenState extends State<TemplateScreen> {
//   var _titleController = TextEditingController();
//   int _size = 2;
//   List<String> _words = [];

//   void _doneEditing() {
//     /*await Bloc.of(context)
//         .createGame(size: size, dictionary: Set.from(words));
//     setState(() {
//       Navigator.of(context).pushReplacement(MaterialPageRoute(
//         builder: (_) => SelectWordsScreen(),
//       ));
//     });*/
//   }

//   void _startGame() {}

//   bool _validateWord(String word) {
//     word = word.trim();
//     return word.isNotEmpty && !_words.contains(word);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: [
//           ListView(
//             padding: MediaQuery.of(context).padding + const EdgeInsets.all(16),
//             children: <Widget>[
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: MyFlatButton(
//                   label: 'Done',
//                   color: Colors.teal,
//                   onPressed: () {},
//                 ),
//               ),
//               TextField(
//                 controller: _titleController,
//                 style: TextStyle(fontSize: 36),
//                 maxLines: null,
//                 decoration: InputDecoration(hintText: 'Enter a title'),
//               ),
//               SizedBox(height: 16),
//               WordsDisplay(words: _words),
//               SizedBox(height: 56),
//             ],
//           ),
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: WordInput(
//               validator: _validateWord,
//               onDone: (word) => setState(() => _words.add(word)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class WordInput extends StatefulWidget {
//   WordInput({
//     @required this.validator,
//     @required this.onDone,
//   });

//   final bool Function(String word) validator;
//   final void Function(String word) onDone;

//   @override
//   _WordInputState createState() => _WordInputState();
// }

// class _WordInputState extends State<WordInput> {
//   var _controller = TextEditingController();
//   var _focusNode = FocusNode();
//   String _lastWord;

//   bool get _showButton => !_focusNode.hasFocus && _controller.text.isEmpty;

//   @override
//   void initState() {
//     super.initState();
//     _focusNode.addListener(() => setState(() {}));
//   }

//   void _onDone(String word) {
//     if (widget.validator(word)) {
//       _controller.text = '';
//       widget.onDone(word);
//       FocusScope.of(context).requestFocus(_focusNode);
//       _lastWord = word;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     var style = TextStyle(color: Colors.white, fontSize: 24);

//     return Material(
//       elevation: 24,
//       color: Colors.teal,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: Stack(
//           children: <Widget>[
//             Positioned.fill(
//               child: AnimatedOpacity(
//                 duration: Duration(milliseconds: 100),
//                 opacity: _showButton ? 1.0 : 0.0,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: <Widget>[
//                     Icon(Icons.add, color: Colors.white),
//                     SizedBox(width: 8),
//                     Text('Add a new word', style: style.copyWith(fontSize: 20)),
//                   ],
//                 ),
//               ),
//             ),
//             FlyingOutWord(word: _lastWord, style: style),
//             TextField(
//               controller: _controller,
//               focusNode: _focusNode,
//               decoration: InputDecoration(border: InputBorder.none),
//               cursorColor: Colors.white,
//               style: style,
//               onSubmitted: _onDone,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class FlyingOutWord extends StatefulWidget {
//   FlyingOutWord({@required this.word, this.style});

//   final String word;
//   final TextStyle style;

//   @override
//   _FlyingOutWordState createState() => _FlyingOutWordState();
// }

// class _FlyingOutWordState extends State<FlyingOutWord>
//     with SingleTickerProviderStateMixin {
//   AnimationController _controller;
//   Animation<Offset> _offset;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 200),
//     )..addListener(() => setState(() {}));
//     _offset = Tween<Offset>(begin: Offset.zero, end: Offset(1, 0)).animate(
//         CurvedAnimation(curve: Curves.easeInCirc, parent: _controller));
//   }

//   @override
//   void didUpdateWidget(FlyingOutWord oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.word == widget.word) return;

//     _controller.value = 0.0;
//     _controller.forward();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Positioned.fill(
//       child: FractionalTranslation(
//         translation: _offset?.value ?? Offset.zero,
//         child: Center(
//           child: Text(widget.word ?? '', style: widget.style),
//         ),
//       ),
//     );
//   }
// }

// class WordsDisplay extends StatefulWidget {
//   WordsDisplay({@required this.words});

//   final List<String> words;

//   @override
//   _WordsDisplayState createState() => _WordsDisplayState();
// }

// class _WordsDisplayState extends State<WordsDisplay> {
//   @override
//   Widget build(BuildContext context) {
//     return Wrap(
//       spacing: 8,
//       children: widget.words.map((word) => WordChip(word: word)).toList(),
//     );
//   }
// }

// class WordChip extends StatefulWidget {
//   WordChip({@required this.word});

//   final String word;

//   @override
//   _WordChipState createState() => _WordChipState();
// }

// class _WordChipState extends State<WordChip>
//     with SingleTickerProviderStateMixin {
//   AnimationController _controller;
//   Animation<double> _offset;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 100),
//     )..addListener(() => setState(() {}));
//     _offset = Tween<double>(begin: 1.0, end: 0.0).animate(
//         CurvedAnimation(curve: Curves.easeOutCirc, parent: _controller));
//     Future.delayed(Duration(milliseconds: 200), () => _controller.forward());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Transform.translate(
//       offset: Offset(MediaQuery.of(context).size.width * _offset.value, 0),
//       child: Chip(
//         label: Text(widget.word, style: TextStyle(color: Colors.white)),
//         backgroundColor: Colors.teal,
//         onDeleted: () {},
//         deleteIconColor: Colors.white,
//       ),
//     );
//   }
// }
