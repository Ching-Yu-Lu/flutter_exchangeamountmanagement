import 'package:flutter/material.dart';
import 'package:flutter_exchangeamountmanagement/data/currency_target.dart';
import 'package:flutter_exchangeamountmanagement/data/exchange_rate.dart';
import 'package:flutter_exchangeamountmanagement/formFields/input_textformfield.dart';
import 'package:flutter_exchangeamountmanagement/formfields/message_alert';
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
  List<CurrencytargetDtl> dtlList = <CurrencytargetDtl>[];

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

          selectedDateBeg = DateTime.parse(element.dateBeg);
          selectedDateEnd = DateTime.parse(element.dateEnd);

          //String dateEnd = formatDate(selectedDateEnd, [yyyy, '-', mm, '-', dd]);

          inputTargetTotalCost = element.targetTotalCost;

          if (element.currencytargetDtlList != null) {
            dtlList = element.currencytargetDtlList!;
          }
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
        title: const Text('設定目標'),
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
                      height: 53,
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
            onPressed: () async {
              String strMsg = '';
              String strEditCheckMsg = '';

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

              if (strEditCheckMsg.isEmpty) {
                // 編輯才會檢查
                if (widget.groupID >= 0) {
                  //檢查日期是否有已經新增的明細超過日期區間
                  List<CurrencytargetDtl> chcekList = dtlList.where((element) {
                    bool rt = false;
                    DateTime dtlDate = DateTime.parse(element.exchangeDate);
                    Duration differenceBeg =
                        dtlDate.difference(selectedDateBeg);
                    Duration differenceEnd =
                        dtlDate.difference(selectedDateEnd);
                    //print('dtlDate: $dtlDate');
                    //print('selectedDateBeg: $selectedDateBeg, differenceBeg: ${differenceBeg.inDays}');
                    //print('selectedDateEnd: $selectedDateEnd, differenceEnd: ${differenceEnd.inDays}');
                    if (differenceBeg.inDays < 0 || differenceEnd.inDays > 0) {
                      //print('Not in Range is true...');
                      rt = true;
                    }

                    return rt;
                  }).toList();

                  if (chcekList.isNotEmpty) {
                    strEditCheckMsg = '有兌換日期不再預定日期起訖時間內，請問是否繼續存入資料?';
                  }
                }
              }

              if (strMsg.isNotEmpty) {
                showAlert(context, '提示訊息', strMsg);
              } else {
                bool isPass = false;
                if (strEditCheckMsg.isNotEmpty) {
                  var active = await showCheckAlert(
                      context, '提示訊息', strEditCheckMsg, '儲存', '取消');

                  if (active != null) {
                    if (active) {
                      isPass = true;
                      //print('active: ${active.toString()}');
                    } else {
                      //print('active => ${active.toString()}');
                    }
                  }
                } else {
                  isPass = true;
                }

                if (isPass) {
                  int gid = 1;

                  // 編輯(取得目標編號)
                  if (widget.groupID >= 0) {
                    gid = widget.groupID;
                  }
                  // 新增(設定目標編號)
                  else {
                    int listLength = 0;
                    if (widget.currencyTargetList.isNotEmpty) {
                      Currencytarget lastItem = widget.currencyTargetList
                          .reduce((item1, item2) =>
                              item1.groupID > item2.groupID ? item1 : item2);
                      listLength = lastItem.groupID;
                    }

                    if (listLength > 0) {
                      gid = listLength + 1;
                    }
                  }

                  // 組合資料
                  Currencytarget addItem = Currencytarget(
                      groupID: gid,
                      groupName: inputGroupName,
                      currency: inputCurrency,
                      dateBeg:
                          formatDate(selectedDateBeg, [yyyy, '-', mm, '-', dd]),
                      dateEnd:
                          formatDate(selectedDateEnd, [yyyy, '-', mm, '-', dd]),
                      targetTotalCost: inputTargetTotalCost,
                      currencytargetDtlList: dtlList);
                  //print('addItem => groupName:${addItem.groupName}, currency:${addItem.currency}, dateBeg:${addItem.dateBeg}, dateEnd:${addItem.dateEnd}, targetTotalCost:${addItem.targetTotalCost}');

                  setState(() {
                    if (widget.groupID >= 0) {
                      ref.read(currencyTargetProvider.notifier).change(addItem);
                    } else {
                      ref.read(currencyTargetProvider.notifier).add(addItem);
                    }

                    // 返回上一頁
                    //Navigator.of(context).pop(true);
                    Navigator.pop(context);
                  });
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
