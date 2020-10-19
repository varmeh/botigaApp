import 'package:flutter/material.dart';

import '../theme/index.dart';

class SearchBar extends StatefulWidget {
  final String placeholder;
  final Function(String) onSubmit;
  final Function(String) onChange;

  SearchBar({
    @required this.placeholder,
    @required this.onSubmit,
    this.onChange,
  });

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  TextEditingController _textEditingController;
  String _query = '';
  final _height = 44.0;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    FocusScope.of(context).unfocus();
    widget.onSubmit(_textEditingController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 40.0,
      height: _height,
      decoration: BoxDecoration(
        color: AppTheme.color05,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: TextField(
              cursorHeight: 16.0,
              cursorColor: AppTheme.color05,
              textInputAction: TextInputAction.search,
              controller: _textEditingController,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.only(left: 16.0, top: 12.0, bottom: 12.0),
                hintText: widget.placeholder,
                hintStyle:
                    AppTheme.textStyle.w500.color50.size(15.0).lineHeight(1.3),
              ),
              onChanged: (value) {
                _query = value;
                if (_query.length <= 1) {
                  setState(() {});
                }
                if (widget.onChange != null) {
                  widget.onChange(value);
                }
              },
              onEditingComplete: _onSubmit,
            ),
          ),
          _clearButton(),
          _searchButton(),
        ],
      ),
    );
  }

  Container _clearButton() {
    return _query.length > 0
        ? Container(
            width: _height,
            height: _height,
            child: GestureDetector(
              onTap: () {
                _textEditingController.clear();
                setState(() {
                  _query = '';
                });
              },
              child: Icon(
                Icons.clear,
                color: AppTheme.color50,
              ),
            ),
          )
        : Container();
  }

  Container _searchButton() {
    return Container(
      width: _height,
      height: _height,
      child: GestureDetector(
        onTap: _onSubmit,
        child: Icon(
          Icons.search,
          color: AppTheme.color100,
        ),
      ),
    );
  }
}
