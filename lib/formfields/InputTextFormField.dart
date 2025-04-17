// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_exchangeamountmanagement/data/currencyTarget.dart';

class TextFormFieldDouble extends StatefulWidget {
  /// 標題
  final String title;

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
    required this.title,
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
        String strNum =
            Currencytarget.currentNumber(widget.textEditingController.text);
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title,
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey)),
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
          onTap: () {
            widget.textEditingController.selection = TextSelection(
              baseOffset: 0,
              extentOffset: widget.textEditingController.text.length,
            );
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
