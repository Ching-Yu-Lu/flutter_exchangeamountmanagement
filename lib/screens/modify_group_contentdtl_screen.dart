import 'package:flutter/material.dart';
import 'package:flutter_exchangeamountmanagement/data/currency_target.dart';
import 'package:flutter_exchangeamountmanagement/data/exchange_rate.dart';
import 'package:flutter_exchangeamountmanagement/formFields/input_textformfield.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ModifygroupcontentdtlScreen extends ConsumerStatefulWidget {
  /// 群組編號
  final int groupID;

  /// 明細編號
  final int dtlID;

  /// 幣別匯率列表
  final List<FetchAndExtract> currencyRateList;

  /// 目標資料列表
  final List<Currencytarget> currencyTargetList;

  const ModifygroupcontentdtlScreen(
      {super.key,
      required this.groupID,
      required this.dtlID,
      required this.currencyRateList,
      required this.currencyTargetList});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      ModifygroupcontentScreendtlState();
}

class ModifygroupcontentScreendtlState
    extends ConsumerState<ModifygroupcontentdtlScreen> {
  int pickerRangeDays = 720;

  // 輸入資料
  DateTime addDate = DateTime.now().add(const Duration(days: -30));
  num twCost = 0;
  num costRate = 0;
  num curCost = 0;

  // 幣別資料
  String currencyCode = '';
  String currencyCodeToName = '';

  // 焦點元件
  FocusNode twCostfocusNode = FocusNode();
  FocusNode costRatefocusNode = FocusNode();
  FocusNode curCostfocusNode = FocusNode();

  // 控制元件
  TextEditingController twCostController = TextEditingController(text: '0');
  TextEditingController costRateController = TextEditingController(text: '0');
  TextEditingController curCostController = TextEditingController(text: '0');

  @override
  void initState() {
    super.initState();

    if (widget.currencyTargetList.isNotEmpty &&
        widget.currencyRateList.isNotEmpty) {
      /// 取得目標資料
      Currencytarget defaultData = widget.currencyTargetList
          .firstWhere((element) => element.groupID == widget.groupID);

      /// 找到目標幣別資料
      FetchAndExtract defaultFetch = widget.currencyRateList.firstWhere(
          (element) => element.unitCurrency == defaultData.currency);

      costRate = defaultFetch.cashSellingRate;
      if (costRate == 0) {
        costRate = defaultFetch.spotSellingRate;
      }

      // 初始化幣別資料
      currencyCode = defaultFetch.unitCurrency;
      currencyCodeToName = defaultFetch.currencyCodeToName();
    }

    twCostController.text = twCost.toString();
    costRateController.text = costRate.toString();
    curCostController.text = curCost.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text('DTL Add'),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: ListView(
          children: [
            /* 日期 */
            Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('日期'),
                    InkWell(
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: addDate,
                          firstDate: DateTime.now()
                              .add(Duration(days: -pickerRangeDays)),
                          lastDate: DateTime.now()
                              .add(Duration(days: pickerRangeDays)),
                        ).then((value) {
                          if (value != null) {
                            setState(() {
                              addDate = value;
                            });
                            // wait 1 second
                            /*Future.delayed(Duration(seconds: 1), () {
                              setState(() {});
                            });*/
                          }
                        });
                      },
                      child: Container(
                        decoration: // rouned all borders
                            BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              child: Text(
                                '${addDate.year}-${addDate.month.toString().padLeft(2, '0')}-${addDate.day.toString().padLeft(2, '0')}',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ), //
                  ],
                ))
              ],
            ),
            SizedBox(height: 10),
            /* 台幣金額 */
            Row(
              children: [
                TextFormFieldDouble(
                  title: '台幣金額',
                  textValue: twCost.toString(),
                  decimalLength: 0,
                  focusNode: twCostfocusNode,
                  textEditingController: twCostController,
                  onChanged: (val) {
                    setState(() {
                      twCost = val.isEmpty ? 0 : double.parse(val);
                      //print('onChanged textValue: $inputTargetTotalCost');
                      curCost =
                          computingCurCost(currencyCode, twCost, costRate);
                      //print('onChanged curCost: $curCost');
                      curCostController.text =
                          Currencytarget.currentNumber(curCost.toString());
                    });
                  },
                  onSaved: (val) {
                    setState(() {
                      twCost = val.isEmpty ? 0 : double.parse(val);
                      twCostController.value = TextEditingValue(text: val);
                      //print('onSaved textValue: $inputTargetTotalCost');
                      curCost =
                          computingCurCost(currencyCode, twCost, costRate);
                      //print('onSaved curCost: $curCost');
                      curCostController.text =
                          Currencytarget.currentNumber(curCost.toString());
                    });
                  },
                )
              ],
            ),
            SizedBox(height: 15),
            /* 兌換幣別 */
            Row(
              children: [
                Text(
                  '兌換幣別: $currencyCodeToName',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            SizedBox(height: 15),
            /* 匯率 */
            Row(
              children: [
                TextFormFieldDouble(
                  title: '匯率',
                  textValue: costRate.toString(),
                  focusNode: costRatefocusNode,
                  textEditingController: costRateController,
                  onChanged: (val) {
                    setState(() {
                      costRate = val.isEmpty ? 0 : double.parse(val);
                      //print('onChanged textValue: $inputTargetTotalCost');
                      curCost =
                          computingCurCost(currencyCode, twCost, costRate);
                      curCostController.text =
                          Currencytarget.currentNumber(curCost.toString());
                    });
                  },
                  onSaved: (val) {
                    setState(() {
                      costRate = val.isEmpty ? 0 : double.parse(val);
                      costRateController.value = TextEditingValue(text: val);
                      //print('onSaved textValue: $inputTargetTotalCost');
                      curCost =
                          computingCurCost(currencyCode, twCost, costRate);
                      curCostController.text =
                          Currencytarget.currentNumber(curCost.toString());
                    });
                  },
                )
              ],
            ),
            SizedBox(height: 10),
            /* 外幣金額 */
            Row(
              children: [
                TextFormFieldDouble(
                  title: '外幣金額',
                  textValue: curCost.toString(),
                  decimalLength:
                      FetchAndExtract.currencyDecimalPlaces(currencyCode),
                  focusNode: curCostfocusNode,
                  textEditingController: curCostController,
                  onChanged: (val) {
                    setState(() {
                      curCost = val.isEmpty ? 0 : double.parse(val);
                      //print('onChanged textValue: $inputTargetTotalCost');
                    });
                  },
                  onSaved: (val) {
                    setState(() {
                      curCost = val.isEmpty ? 0 : double.parse(val);
                      curCostController.value = TextEditingValue(text: val);
                      //print('onSaved textValue: $inputTargetTotalCost');
                    });
                  },
                )
              ],
            ),
          ],
        ),
      ),
      /* 固定在底部按鈕 */
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                // 設定圓角矩形邊框圓角半徑
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: Text(
              '加入',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}

///計算外幣金額
num computingCurCost(String currencyCode, num twCost, num costRate) {
  num rt = 0;

  if (costRate != 0) {
    //計算兌換後外幣
    num curCost = twCost / costRate;

    //保留小數點後 N 位數
    int decimalPlacesNum = FetchAndExtract.currencyDecimalPlaces(currencyCode);
    //取得計算後外幣金額(小數N位數)文字
    String strCurCost = curCost.toStringAsFixed(decimalPlacesNum);
    rt = num.parse(strCurCost);
  }

  return rt;
}
