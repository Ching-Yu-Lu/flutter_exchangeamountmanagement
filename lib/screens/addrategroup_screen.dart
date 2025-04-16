import 'package:flutter/material.dart';
import 'package:flutter_exchangeamountmanagement/data/exchangerate.dart';
import 'package:flutter_exchangeamountmanagement/formfields/InputTextFormField.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddrategroupScreen extends ConsumerStatefulWidget {
  final List<FetchAndExtract> currencyRateList;
  const AddrategroupScreen({super.key, required this.currencyRateList});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      AddrategroupScreenState();
}

class AddrategroupScreenState extends ConsumerState<AddrategroupScreen> {
  String currencySelect = 'PleaseSelect';
  int pickerRangeDays = 720;
  DateTime selectedDateBeg = DateTime.now().add(const Duration(days: -30));
  DateTime selectedDateEnd = DateTime.now().add(const Duration(days: 30));

  // tempValue
  dynamic tempTextValue = 0;

  // 目標金額(焦點/Value編輯)
  FocusNode focusNodeTargetCost = FocusNode();
  TextEditingController textEditingControllerTargetCost =
      TextEditingController(text: '0');

  @override
  Widget build(BuildContext context) {
    List<FetchAndExtract> currencySelectListList = [
      FetchAndExtract(
          unitCurrency: 'PleaseSelect',
          targetCurrency: 'PleaseSelect',
          cashBuyingRate: 0.0,
          cashSellingRate: 0.0,
          spotBuyingRate: 0.0,
          spotSellingRate: 0.0,
          bankName: '',
          updateTime: ''),
    ];
    currencySelectListList.addAll(widget.currencyRateList);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Group'),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: ListView(
          children: [
            // 名稱
            Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('名稱'),
                    TextFormField(
                      initialValue: 'enteredLastName',
                      // border
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          //enteredLastName = value;
                        });
                      },
                    ),
                  ],
                ))
              ],
            ),
            SizedBox(height: 10),
            // 幣別
            Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('幣別'),
                    SizedBox(
                      height: 51,
                      child: DropdownButtonFormField(
                        value: currencySelect,
                        decoration: // rouned all borders
                            InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        items: currencySelectListList.map((item) {
                          return DropdownMenuItem(
                            value: item.unitCurrency,
                            child: Text(item.currencyCodeToName()),
                          );
                        }).toList(),
                        onChanged: (v) {
                          setState(() {
                            currencySelect = v as String;
                          });
                          // wait 1 second
                          /*Future.delayed(Duration(seconds: 1), () {
                            setState(() {});
                          });*/
                        },
                      ),
                    ) // */
                  ],
                ))
              ],
            ),
            SizedBox(height: 10),
            // 預定達成日期(起)
            Row(
              children: [
                Expanded(
                    child: Column(
                  children: [
                    Text('預定達成日期(起)'),
                    InkWell(
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: selectedDateBeg,
                          firstDate: DateTime.now()
                              .add(Duration(days: -pickerRangeDays)),
                          lastDate: DateTime.now()
                              .add(Duration(days: pickerRangeDays)),
                        ).then((value) {
                          if (value != null) {
                            setState(() {
                              selectedDateBeg = value;
                            });
                            // wait 1 second
                            Future.delayed(Duration(seconds: 1), () {
                              setState(() {});
                            });
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
                                  horizontal: 12, vertical: 15),
                              child: Text(
                                '${selectedDateBeg.year}-${selectedDateBeg.month.toString().padLeft(2, '0')}-${selectedDateBeg.day.toString().padLeft(2, '0')}',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ))
              ],
            ),
            SizedBox(height: 10),
            // 預定達成日期(迄)
            Row(
              children: [
                Expanded(
                    child: Column(
                  children: [
                    Text('預定達成日期(迄)'),
                    InkWell(
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: selectedDateEnd,
                          firstDate: DateTime.now()
                              .add(Duration(days: -pickerRangeDays)),
                          lastDate: DateTime.now()
                              .add(Duration(days: pickerRangeDays)),
                        ).then((value) {
                          if (value != null) {
                            setState(() {
                              selectedDateEnd = value;
                            });
                            // wait 1 second
                            Future.delayed(Duration(seconds: 1), () {
                              setState(() {});
                            });
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
                                '${selectedDateEnd.year}-${selectedDateEnd.month.toString().padLeft(2, '0')}-${selectedDateEnd.day.toString().padLeft(2, '0')}',
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
            // 目標金額
            Row(
              children: [
                TextFormFieldDouble(
                  textValue: tempTextValue.toString(),
                  focusNode: focusNodeTargetCost,
                  textEditingController: textEditingControllerTargetCost,
                  onChanged: (val) {
                    setState(() {
                      tempTextValue = val.toString();
                      //print('onChanged textValue: $tempTextValue');
                    });
                  },
                  onSaved: (val) {
                    setState(() {
                      tempTextValue = val.toString();
                      textEditingControllerTargetCost.value =
                          TextEditingValue(text: val);
                      //print('onSaved textValue: $tempTextValue');
                    });
                  },
                )
              ],
            )
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
              '加入/修改',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
