// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldDouble extends StatefulWidget {
  /// 整數長度
  final int integerLength;

  /// 小數長度
  final int decimalLength;

  /// 預設值
  final String textValue;

  final FocusNode focusNode;

  final TextEditingController textEditingController;

  /// 當數值變更時回傳
  final Function(String) onChanged;
  final Function(String) onSaved;
  const TextFormFieldDouble({
    super.key,
    this.integerLength = 10,
    this.decimalLength = 5,
    required this.textValue,
    required this.focusNode,
    required this.textEditingController,
    required this.onChanged,
    required this.onSaved,
  });

  @override
  TextFormFieldDoubleState createState() => TextFormFieldDoubleState();
}

class TextFormFieldDoubleState extends State<TextFormFieldDouble> {
  @override
  void initState() {
    super.initState();

    widget.focusNode.addListener(() {
      if (!widget.focusNode.hasFocus) {
        String strNum = currentNumber(widget.textValue);
        //print('textValue: ${widget.textValue}');
        //print('currentNumber: $strNum');
        widget.onSaved(strNum);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
      children: [
        Text('目標金額'),
        TextFormField(
          focusNode: widget.focusNode,
          controller: widget.textEditingController,
          //initialValue: widget.textValue,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,99}')),
            NumberLengthFormatter(
                decimalLength: widget.decimalLength,
                integerLength: widget.integerLength),
          ],
          // border
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            double setValue = double.tryParse(value) ?? 0;
            widget.onChanged(setValue.toString());
          },
          onSaved: (newValue) {
            double setValue = double.tryParse(newValue ?? '') ?? 0;
            widget.onChanged(setValue.toString());
          },
        ),
      ],
    ));
  }
}

// 數字輸入數量檢查
class NumberLengthFormatter extends TextInputFormatter {
  final int integerLength, decimalLength;

  NumberLengthFormatter(
      {required this.integerLength, required this.decimalLength});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    //print('newValue: ${newValue.text}');
    //print('oldValue: ${oldValue.text}');
    String value = newValue.text;
    int selectionIndex = newValue.selection.end;

    // 整數部分
    String beforePoint = '';
    // 小數部分
    String afterPoint = '';

    // 取得整數/小數部分數字
    if (newValue.text.contains('.')) {
      int pointIndex = newValue.text.indexOf('.');
      beforePoint = newValue.text.substring(0, pointIndex);
      afterPoint =
          newValue.text.substring(pointIndex + 1, newValue.text.length);
    } else {
      beforePoint = newValue.text;
    }

    // 整數檢查(不符合則維持舊的資料)
    if (beforePoint.length > integerLength) {
      value = oldValue.text;
      selectionIndex = oldValue.selection.end;
    }

    // 小數檢查(不符合則維持舊的資料)
    if (newValue.text.contains('.') && afterPoint.isNotEmpty) {
      if (afterPoint.length > decimalLength) {
        value = oldValue.text;
        selectionIndex = oldValue.selection.end;
      }
    }

    return TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

String currentNumber(String inputValue) {
  String result = '0';

  // 整數部分
  String beforePoint = '';
  // 小數部分
  String afterPoint = '';

  // 取得整數/小數部分數字
  if (inputValue.contains('.')) {
    int pointIndex = inputValue.indexOf('.');
    beforePoint = inputValue.substring(0, pointIndex);
    afterPoint = inputValue.substring(pointIndex + 1, inputValue.length);
  } else {
    beforePoint = inputValue;
  }

  // 整數
  int intBeforePoint = int.tryParse(beforePoint) ?? 0;

  // 小數
  dynamic doubleAfterPoint = double.tryParse(('0.$afterPoint')) ?? 0.0;

  if (doubleAfterPoint > 0) {
    dynamic curNum = intBeforePoint + doubleAfterPoint;
    result = curNum.toString();
  } else {
    result = intBeforePoint.toString();
  }

  return result;
}
