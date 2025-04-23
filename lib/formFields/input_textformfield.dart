// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_exchangeamountmanagement/data/currency_target.dart';
import 'package:number_precision/number_precision.dart';

class TextFormFieldDouble extends StatefulWidget {
  /// 標題
  final String title;

  /// 整數長度
  final int integerLength;

  /// 小數長度
  final int decimalLength;

  /// 預設值
  final String textValue;

  /// 焦點元件
  final FocusNode focusNode;

  /// 控制元件
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

    // 焦點監聽
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
    String strRegex = widget.decimalLength > 0 ? r'^\d+\.?\d{0,99}' : r'^\d+';

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
            FilteringTextInputFormatter.allow(RegExp(strRegex)),
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

// 將輸入數字轉換為符合的位數
num currentDecimalLength(String inputValue,
    {int integerLength = 10, int decimalLength = 0}) {
  num rt = 0;

  // 整數部分
  String beforePoint = '';
  // 小數部分
  String afterPoint = '';

  // 取得整數/小數部分數字
  if (inputValue.contains('.')) {
    int pointIndex = inputValue.indexOf('.');
    beforePoint = inputValue.substring(0, pointIndex);
    afterPoint = inputValue.substring(pointIndex + 1, inputValue.length);

    var tempBefPoint = int.tryParse(beforePoint);
    var tempAftPoint = int.tryParse(afterPoint);

    int intBefPoint = int.parse(tempBefPoint.toString());
    int intAftPoint = int.parse(tempAftPoint.toString());

    rt = intBefPoint;
    if (intAftPoint > 0 && decimalLength > 0) {
      rt = NP.plus(intBefPoint, num.parse('0.$intAftPoint'));
    }
  } else {
    var tempValue = num.tryParse(inputValue);
    rt = num.parse(tempValue.toString());
  }

  return rt;
}
