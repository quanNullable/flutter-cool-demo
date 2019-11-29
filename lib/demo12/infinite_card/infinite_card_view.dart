import 'package:flutter/widgets.dart';

import 'anim_helper.dart';
import 'infinite_cards_controller.dart';

//Three types of animation
enum AnimType {
  TO_FRONT,//custom animation for chosen card, common animation for other cards
  SWITCH,//witch the position by custom animation of the first card and the chosen card
  TO_END,//moving the first card to last position by custom animation, common animation for others
}

class InfiniteCards extends StatefulWidget {
  final double width, height;
  final Color background;
  final InfiniteCardsController controller;

  InfiniteCards({
    @required this.controller,
    this.width,
    this.height,
    this.background,
  });

  @override
  _InfiniteCardsState createState() => _InfiniteCardsState();
}

class _InfiniteCardsState extends State<InfiniteCards>
    with TickerProviderStateMixin {
  double _width, _height;
  Color _background;
  AnimHelper _helper;

  @override
  void initState() {
    super.initState();
    //init background, helper, controller
    _background = widget.background ?? Color(0xffffffff);
    _helper = AnimHelper(
        controller: widget.controller,
        listenerForSetState: () {
          setState(() {});
        });
    _helper.init(this, context);
    if (widget.controller != null) {
      widget.controller.animHelper = _helper;
    }
  }

  @override
  Widget build(BuildContext context) {
    _width = widget.width ?? MediaQuery.of(context).size.width;
    _height = widget.height ?? MediaQuery.of(context).size.height;
    return Container(
      width: _width,
      height: _height,
      color: _background,
      child: Stack(
        children: _helper.getCardList(_width, _height),
      ),
    );
  }
}
