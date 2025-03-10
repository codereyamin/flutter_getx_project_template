import 'package:flutter/material.dart';
import 'package:flutter_getx_project_template/utils/error_log.dart';

class CustomExpansionTile extends StatefulWidget {
  final Widget title;
  final List<Widget> children;
  final bool initiallyExpanded;
  final Duration duration;
  final Curve curve;
  final Curve reverseCurve;
  final Function()? onCollapse;
  final Function()? onExpand;
  final GlobalKey cKey;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Decoration? decoration;
  const CustomExpansionTile({
    super.key,
    required this.cKey,
    required this.title,
    required this.children,
    this.initiallyExpanded = false,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.reverseCurve = Curves.easeInOut,
    this.onCollapse,
    this.onExpand,
    this.margin,
    this.padding,
    this.decoration,
  });

  @override
  State createState() => CustomExpansionTileState();
}

class CustomExpansionTileState extends State<CustomExpansionTile> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    try {
      _isExpanded = widget.initiallyExpanded;
      _controller = AnimationController(duration: widget.duration, reverseDuration: widget.duration, vsync: this);
      _animation = CurvedAnimation(parent: _controller, curve: widget.curve, reverseCurve: widget.reverseCurve);

      if (_isExpanded) {
        _controller.forward();
      }
    } catch (e) {
      errorLog("initial iniState", e);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    try {
      setState(() {
        _isExpanded = !_isExpanded;
        if (_isExpanded) {
          _controller.forward();
          if (widget.onExpand != null) {
            widget.onExpand!();
          }
        } else {
          _controller.reverse();
          if (widget.onCollapse != null) {
            widget.onCollapse!();
          }
        }
      });
    } catch (e) {
      errorLog("handle tap", e);
    }
  }

  void expand() {
    try {
      if (!_isExpanded) {
        _handleTap();
      }
    } catch (e) {
      errorLog("handle tap", e);
    }
  }

  void collapse() {
    try {
      if (_isExpanded) {
        _handleTap();
      }
    } catch (e) {
      errorLog("collapse function", e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Column(
        key: widget.cKey,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: widget.padding,
            margin: widget.margin,
            decoration: widget.decoration,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [Expanded(child: widget.title), AnimatedContainer(duration: Durations.medium4, child: _isExpanded ? Icon(Icons.expand_less_outlined) : Icon(Icons.expand_more_outlined))],
            ),
          ),
          SizeTransition(sizeFactor: _animation, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: widget.children)),
        ],
      ),
    );
  }
}
