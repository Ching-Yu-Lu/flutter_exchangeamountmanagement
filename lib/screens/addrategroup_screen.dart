import 'package:flutter/material.dart';
import 'package:flutter_exchangeamountmanagement/data/currencyTarget.dart';
import 'package:flutter_exchangeamountmanagement/data/exchangerate.dart';
import 'package:flutter_exchangeamountmanagement/formfields/InputTextFormField.dart';
import 'package:flutter_exchangeamountmanagement/formfields/messageAlert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:date_format/date_format.dart';

class AddrategroupScreen extends ConsumerStatefulWidget {
  /// 群組編號
  final int groupID;

  /// 幣別匯率列表
  final List<FetchAndExtract> currencyRateList;

  /// 目標資料列表
  final List<Currencytarget> currencyTargetList;

  const AddrategroupScreen(
      {super.key,
      this.groupID = -1,
      required this.currencyRateList,
      required this.currencyTargetList});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      AddrategroupScreenState();
}

class AddrategroupScreenState extends ConsumerState<AddrategroupScreen> {
  // 日期選擇範圍(天數)
  int pickerRangeDays = 720;

  // 輸入資料變數
  String inputGroupName = '';
  String inputCurrency = 'PleaseSelect';
  DateTime selectedDateBeg = DateTime.now().add(const Duration(days: -30));
  DateTime selectedDateEnd = DateTime.now().add(const Duration(days: 30));
  num inputTargetTotalCost = 0;

  // 目標金額(焦點/Value編輯)
  FocusNode focusNodeTargetCost = FocusNode();
  TextEditingController textEditingControllerTargetCost =
      TextEditingController(text: '0');

  @override
  void initState() {
    super.initState();

    // 群組ID不等於-1，表示修改資料
    if (widget.groupID >= 0) {
      for (var element in widget.currencyTargetList) {
        if (element.groupID == widget.groupID) {
          inputGroupName = element.groupName ?? '';
          inputCurrency = element.currency ?? 'PleaseSelect';

          String dateBeg = element.dateBeg ??
              formatDate(selectedDateBeg, [yyyy, '-', mm, '-', dd]);
          selectedDateBeg = DateTime.parse(dateBeg);

          String dateEnd = element.dateEnd ??
              formatDate(selectedDateEnd, [yyyy, '-', mm, '-', dd]);
          selectedDateEnd = DateTime.parse(dateEnd);

          inputTargetTotalCost = element.targetTotalCost;
        }
      }
    }

    // 初始化 TextEditingController 的值
    textEditingControllerTargetCost.text =
        Currencytarget.currentNumber(inputTargetTotalCost.toString());
  }

  @override
  Widget build(BuildContext context) {
    /// 幣別下拉選單資料
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

    /// 加入幣別匯率列表
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
                    Text('名稱',
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey)),
                    TextFormField(
                      initialValue: inputGroupName,
                      // border
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          inputGroupName = value;
                          //print('groupName: $groupName');
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
                    Text('幣別',
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey)),
                    SizedBox(
                      height: 51,
                      child: widget.groupID < 0
                          ? DropdownButtonFormField(
                              value: inputCurrency,
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
                                  inputCurrency = v as String;

                                  // 根據幣別調整小數後的位數
                                  inputTargetTotalCost = currentDecimalLength(
                                      inputTargetTotalCost.toString(),
                                      decimalLength:
                                          FetchAndExtract.currencyDecimalPlaces(
                                              inputCurrency));
                                  textEditingControllerTargetCost.value =
                                      TextEditingValue(
                                          text:
                                              inputTargetTotalCost.toString());
                                });
                                // wait 1 second
                                /*Future.delayed(Duration(seconds: 1), () {
                            setState(() {});
                          });*/
                              },
                            )
                          : TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(255, 186, 185, 185),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                hintStyle: TextStyle(
                                    color: Colors.white, fontSize: 18),
                                hintText:
                                    FetchAndExtract.currencyCodeToNameStatic(
                                        inputCurrency),
                              ),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('預定達成日期(起)',
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey)),
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
                              Duration difference =
                                  selectedDateBeg.difference(selectedDateEnd);
                              if (difference.inSeconds > 0) {
                                selectedDateEnd = selectedDateBeg;
                              }
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('預定達成日期(迄)',
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey)),
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
                              Duration difference =
                                  selectedDateBeg.difference(selectedDateEnd);
                              if (difference.inSeconds > 0) {
                                selectedDateEnd = selectedDateBeg;
                              }
                              /*addItem.dateBeg = formatDate(
                                  selectedDateEnd, [yyyy, '-', mm, '-', dd]);*/
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
                  title: '目標金額',
                  textValue: inputTargetTotalCost.toString(),
                  decimalLength:
                      FetchAndExtract.currencyDecimalPlaces(inputCurrency),
                  focusNode: focusNodeTargetCost,
                  textEditingController: textEditingControllerTargetCost,
                  onChanged: (val) {
                    setState(() {
                      inputTargetTotalCost =
                          val.isEmpty ? 0 : double.parse(val);
                      //print('onChanged textValue: $inputTargetTotalCost');
                    });
                  },
                  onSaved: (val) {
                    setState(() {
                      inputTargetTotalCost =
                          val.isEmpty ? 0 : double.parse(val);
                      textEditingControllerTargetCost.value =
                          TextEditingValue(text: val);
                      //print('onSaved textValue: $inputTargetTotalCost');
                    });
                  },
                )
              ],
            )
          ],
        ),
      ),
      /* 固定在底部按鈕(加入/修改) */
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
            onPressed: () {
              setState(() {
                String strMsg = '';

                if (strMsg.isEmpty) {
                  if (inputGroupName.isEmpty) {
                    strMsg = '請輸入群組名稱';
                  }
                }

                if (strMsg.isEmpty) {
                  if (inputCurrency == 'PleaseSelect') {
                    strMsg = '請選擇幣別';
                  }
                }

                if (strMsg.isEmpty) {
                  if (inputTargetTotalCost == 0) {
                    strMsg = '請輸入目標金額';
                  }
                }

                if (strMsg.isNotEmpty) {
                  showAlert(context, '提示訊息', strMsg);
                } else {
                  int gid = 1;

                  //print(widget.groupID);
                  if (widget.groupID >= 0) {
                    gid = widget.groupID;
                  } else {
                    int listLength = 0;
                    if (widget.currencyTargetList.isNotEmpty) {
                      listLength = widget.currencyTargetList.length;
                    }

                    if (listLength > 0) {
                      gid = listLength + 1;
                    }
                  }

                  Currencytarget addItem = Currencytarget(
                    groupID: gid,
                    groupName: inputGroupName,
                    currency: inputCurrency,
                    dateBeg:
                        formatDate(selectedDateBeg, [yyyy, '-', mm, '-', dd]),
                    dateEnd:
                        formatDate(selectedDateEnd, [yyyy, '-', mm, '-', dd]),
                    targetTotalCost: inputTargetTotalCost,
                  );
                  //print('addItem => groupName:${addItem.groupName}, currency:${addItem.currency}, dateBeg:${addItem.dateBeg}, dateEnd:${addItem.dateEnd}, targetTotalCost:${addItem.targetTotalCost}');

                  if (widget.groupID >= 0) {
                    ref.read(currencyTargetProvider.notifier).change(addItem);
                  } else {
                    ref.read(currencyTargetProvider.notifier).add(addItem);
                  }

                  // 返回上一頁
                  //Navigator.of(context).pop(true);
                  Navigator.pop(context);
                }
              });
            },
          ),
        ),
      ),
    );
  }
}
