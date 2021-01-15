import 'package:flutter/material.dart';

import '../theme/index.dart';

class SearchBar extends StatefulWidget {
  final String placeholder;
  final Function(String) onSubmit;
  final Function(String) onChange;
  final Function onClear;
  final bool showLeadingSearch;
  final bool autoFocus;

  SearchBar(
      {@required this.placeholder,
      @required this.onSubmit,
      this.onChange,
      this.onClear,
      this.autoFocus = false,
      this.showLeadingSearch = false});

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
          widget.showLeadingSearch ? _searchButton() : SizedBox.shrink(),
          Expanded(
            flex: 6,
            child: TextField(
              autofocus: widget.autoFocus,
              cursorHeight: 16.0,
              cursorColor: AppTheme.color05,
              textInputAction: TextInputAction.search,
              controller: _textEditingController,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: widget.showLeadingSearch
                    ? const EdgeInsets.only(left: 4.0, top: 12.0, bottom: 12.0)
                    : const EdgeInsets.only(
                        left: 16.0, top: 12.0, bottom: 12.0),
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
          widget.showLeadingSearch ? SizedBox.shrink() : _searchButton(),
          _clearButton(),
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
              behavior: HitTestBehavior.opaque,
              onTap: () {
                _textEditingController.clear();
                setState(() => _query = '');
                if (widget.onClear != null) {
                  widget.onClear();
                }
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
        behavior: HitTestBehavior.opaque,
        onTap: _onSubmit,
        child: Image.asset(
          'assets/images/search.png',
          color: AppTheme.color100,
        ),
      ),
    );
  }
}
