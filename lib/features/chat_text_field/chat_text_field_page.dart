import 'package:flutter/material.dart';

class ChatTextFieldPage extends StatefulWidget {
  const ChatTextFieldPage({Key? key}) : super(key: key);

  @override
  State<ChatTextFieldPage> createState() => _ChatTextFieldPageState();
}

class _ChatTextFieldPageState extends State<ChatTextFieldPage> {
  bool textFieldReadOnly = false;
  GlobalKey textFieldKey = GlobalKey();
  ScrollController scrollController = ScrollController();
  TextEditingController editingController = TextEditingController(
      text:
          "LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng LinXunFeng ");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatTextField'),
      ),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionBtn(context),
    );
  }

  FloatingActionButton _buildFloatingActionBtn(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.change_circle),
      onPressed: () {
        setState(
          () {
            textFieldReadOnly = !textFieldReadOnly;
            _showSnackBar(
              context: context,
              text: 'readOnly: ${textFieldReadOnly ? 'true' : 'false'}',
            );
          },
        );
      },
    );
  }

  Widget _buildBody() {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      // child: _buildTextField(),
      child: Column(
        children: [
          _buildTextField(),
          TextButton(
            child: const Text('append'),
            onPressed: () {
              var result = editingController.text;
              // 新增的内容
              String content = fetchInsertContent();
              int selectionBefore = editingController.selection.start;
              if (selectionBefore < 0) selectionBefore = 0;
              // 更新内容后，光标的位置
              int selectionAfter = selectionBefore + content.length;

              result =
                  (result.split('')..insert(selectionBefore, content)).join('');
              editingController.text = result;
              // 设置光标
              // editingController.selection =
              //     TextSelection.fromPosition(TextPosition(
              //   offset: selectionAfter,
              // ));

              void visitor(Element element) {
                if (element.widget is EditableText) {
                  final editableText = element.widget as EditableText;
                  final editableTextState =
                      (editableText.key as GlobalKey<EditableTextState>)
                          .currentState;

                  editableTextState?.userUpdateTextEditingValue(
                    TextEditingValue(
                      text: result,
                      selection: TextSelection.fromPosition(
                        TextPosition(
                          offset: selectionAfter,
                        ),
                      ),
                    ),
                    null,
                  );
                  // editableTextState?.updateEditingValue(
                  //   TextEditingValue(
                  //     text: result,
                  //     selection: TextSelection.fromPosition(
                  //       TextPosition(
                  //         offset: focusAfter,
                  //       ),
                  //     ),
                  //   ),
                  // );
                  return;
                }
                element.visitChildren(visitor);
              }

              textFieldKey.currentContext?.visitChildElements(visitor);
            },
          ),
        ],
      ),
    );
  }

  String fetchInsertContent() {
    return String.fromCharCode(0x1f609) * 20;
  }

  Widget _buildTextField() {
    Widget resultWidget = Scrollbar(
      controller: scrollController,
      isAlwaysShown: true,
      child: TextField(
        key: textFieldKey,
        autofocus: true,
        decoration: const InputDecoration(
          border: InputBorder.none,
          isCollapsed: true,
        ),
        // onTap: logic.handlerEditClick,
        // focusNode: state.focusNode,
        controller: editingController,
        scrollController: scrollController,
        keyboardType: TextInputType.multiline,
        maxLines: 8,
        minLines: 1,
        showCursor: true,
        readOnly: textFieldReadOnly,
      ),
    );
    resultWidget = MediaQuery.removePadding(
      context: context,
      child: resultWidget,
      removeTop: true,
      removeBottom: true,
    );
    return resultWidget;
  }

  _showSnackBar({
    required BuildContext context,
    required String text,
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: const Duration(milliseconds: 2000),
      ),
    );
  }
}
