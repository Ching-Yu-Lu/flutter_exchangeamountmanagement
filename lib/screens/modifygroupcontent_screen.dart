import 'package:flutter/material.dart';
import 'package:flutter_exchangeamountmanagement/screens/addrategroup_screen.dart';
import 'package:flutter_exchangeamountmanagement/screens/modifygroupcontentdtl_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ModifygroupcontentScreen extends ConsumerStatefulWidget {
  final int groupID;
  const ModifygroupcontentScreen({super.key, required this.groupID});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      ModifygroupcontentScreenState();
}

class ModifygroupcontentScreenState
    extends ConsumerState<ModifygroupcontentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Row(
              children: [
                Text('Item ${widget.groupID}'),
                IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AddrategroupScreen(),
                        ),
                      );
                    },
                    icon: Icon(Icons.edit))
              ],
            )),
            IconButton(onPressed: () {}, icon: Icon(Icons.delete_forever))
            /*ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  '設定變更',
                  style: TextStyle(color: Colors.white),
                )),*/
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: [
            /* 兌換總資訊 */
            Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                      child: Text("預定日期: 2025-01-01 ~ 2025-06-01"),
                    ),
                    SizedBox(
                      height: 20,
                      child: Text("目標金額: 10000/100000(10%) JPY"),
                    ),
                    SizedBox(
                      height: 20,
                      child: Text("已兌換金額: 2500 TWD"),
                    ),
                  ],
                )),
              ],
            ),
            /* 灰色格線 */
            Row(
              children: [
                Expanded(
                  child: Divider(),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ModifygroupcontentdtlScreen(
                              groupID: widget.groupID),
                        ),
                      );
                    },
                    icon: Icon(Icons.playlist_add))
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ListTile(
                      title: Text(
                        "兌換日期 2025-01-02",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("當日匯率: 0.20"),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("兌換金額: 100 TWD"),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("外幣金額: 500 JPY"),
                            ],
                          ),
                        ],
                      ),
                      trailing: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.delete,
                            size: 20,
                          )));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
