import 'package:flutter/material.dart';
import 'package:flutter_exchangeamountmanagement/data/currencyTarget.dart';
import 'package:flutter_exchangeamountmanagement/data/exchangerate.dart';
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
  DateTime addDate = DateTime.now().add(const Duration(days: -30));

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
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('台幣金額(Input)'),
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
            SizedBox(height: 15),
            Row(
              children: [
                Text(
                  '兌換幣別: JPY',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('匯率(Input:Default)'),
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
            Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('外幣金額(Input:Default)'),
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
