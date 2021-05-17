import 'package:flutter_svg/flutter_svg.dart';
import 'package:ism_app/imports.dart';
import 'package:ism_app/src/screens/receipts/item/key_item.dart';
import 'package:ism_app/src/screens/receipts/item/value_item.dart';
import 'package:ism_app/src/widgets/container/container.dart';
import 'package:ism_app/src/widgets/container/item_container.dart';

class ReceiptDetails extends StatefulWidget {
  @override
  _ReceiptDetailsState createState() => _ReceiptDetailsState();
}

class _ReceiptDetailsState extends State<ReceiptDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back,
            color: MyColors.color_FFFFFF,
          ),
          onTap: () {
            MyNavigator.navState.pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.qr_code_scanner,
              color: MyColors.color_FFFFFF,
            ),
            onPressed: () {
              MyNavigator.pushNamed(Routes.strDetailOperationRoute);
            },
          )
        ],
        title: MyText(
          "WH/IN/00004",
          color: MyColors.color_FFFFFF,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      body: MyContainer(
        bgColor: MyColors.color_F8FAFB,
        children: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Row(
                children: [
                  MyText(
                    "Warehouse Afrobio: Receipts |",
                    fontWeight: FontWeight.w500,
                    color: MyColors.color_F18719,
                  ),
                  MyText(
                    " WH/IN/00004",
                    fontWeight: FontWeight.w500,
                    color: MyColors.color_3F4446,
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ListItem(index: index);
                      },
                      primary: false,
                      shrinkWrap: true,
                      itemCount: 2,
                    ),
                    SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final int index;

  ListItem({this.index});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: MyBorder.commonBorderRadius(),
      onTap: () {},
      child: MyItemContainer(
        margin: EdgeInsets.only(
          top: index == 0 ? 27 : 0,
          bottom: 27,
          left: 20,
          right: 20,
        ),
        outlineColor: MyColors.color_E2E9EF,
        shadowColor: MyColors.color_0A0F3712,
        children: Row(
          children: [
            Container(
              padding: const EdgeInsets.only(
                  left: 20, top: 20, bottom: 26, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  KeyItem(
                    title: "Partner",
                    topMargin: 0,
                  ),
                  KeyItem(
                    title: "Owner",
                  ),
                  KeyItem(
                    title: "[Access-Bur-00001] Modem",
                  ),
                  KeyItem(
                    title: "Scheduled Date",
                  ),
                  KeyItem(
                    title: "Document Source",
                  ),
                  KeyItem(
                    title: "Operation Branch",
                  ),
                ],
              ),
              decoration: BoxDecoration(
                  color: MyColors.color_E4E8EB,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(9),
                      bottomLeft: Radius.circular(9))),
            ),
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ValueItem(
                      title: "Orange",
                      topMargin: 0,
                      textColor: MyColors.color_F18719,
                    ),
                    ValueItem(
                      title: "",
                    ),
                    ValueItem(
                        title: "MAG_ODJA/Stock",
                        textColor: MyColors.color_F18719),
                    ValueItem(
                        title: "01/05/2021 | 20:21:14",
                        textColor: MyColors.color_6E7578),
                    ValueItem(
                        title: "PO00002", textColor: MyColors.color_6E7578),
                    ValueItem(
                        title: "Surgelee", textColor: MyColors.color_F18719),
                  ],
                ),
                padding: const EdgeInsets.only(
                    left: 20, top: 20, bottom: 26, right: 16),
                decoration: BoxDecoration(
                    color: MyColors.color_FFFFFF,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(10))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
