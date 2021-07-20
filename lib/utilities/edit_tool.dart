import 'package:flutter/material.dart';

class EditTool extends StatefulWidget {
  final Widget child;
  EditTool(this.child);

  @override
  _EditToolState createState() => _EditToolState();
}

class _EditToolState extends State<EditTool> {
  bool enable = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: widget.child,
            ),
          ),
        );
      },
      onTapDown: (TapDownDetails details) {
        setState(() {
          enable = true;
        });
      },
      onTapCancel: () {
        setState(() {
          enable = false;
        });
      },
      child: Icon(
        Icons.edit,
        color: enable ? Colors.purple : Colors.white,
      ),
    );
  }
}
