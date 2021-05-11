import 'package:ism_app/src/widgets/container/container.dart';
import 'package:ism_app/src/widgets/container/container_shadow.dart';
import 'package:ism_app/src/widgets/container/item_container.dart';
import 'package:ism_app/src/widgets/input/text_field_icon.dart';

import '../../../imports.dart';

class Receipts extends StatefulWidget {
  @override
  _ReceiptsState createState() => _ReceiptsState();
}

class _ReceiptsState extends State<Receipts> {
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
        title: MyText(
          Strings.receipts,
          color: MyColors.color_FFFFFF,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      body: MyContainer(
        bgColor: MyColors.color_F8FAFB,
        children: Column(
          children: [
            MyTextFieldPrefixSuffix(
              hint: Strings.search,
              margin: const EdgeInsets.only(left: 20, right: 20, top: 26),
              outlineColor: MyColors.color_E2E9EF,
              keyboardType: TextInputType.text,
              suffix: Container(
                margin: const EdgeInsets.only(right: 19),
                child: GestureDetector(
                  onTap: () {},
                  child: Icon(Icons.filter_alt_outlined),
                ),
              ),
              focusedColor: MyColors.color_F18719,
              prefix: Container(
                child: Icon(
                  Icons.search,
                  color: MyColors.color_3F4446,
                ),
                margin: EdgeInsets.only(left: 19),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return ListItem(index: index);
                },
                itemCount: 8,
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
      onTap: () {
        MyNavigator.pushNamed(Routes.strReceiptDetailsRoute);
      },
      child: MyItemContainer(
        margin: EdgeInsets.only(
          top: index == 0 ? 14 : 0,
          bottom: 14,
          left: 20,
          right: 20,
        ),
        outlineColor: MyColors.color_E2E9EF,
        padding: EdgeInsets.only(left: 14, top: 13, bottom: 12),
        shadowColor: MyColors.color_0A0F3712,
        children: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    "WH/IN/00004",
                    fontWeight: FontWeight.bold,
                    color: MyColors.color_3F4446,
                    fontSize: 16,
                  ),
                  MyText(
                    "Orange",
                    fontSize: 14,
                    color: MyColors.color_F18719,
                    fontWeight: FontWeight.normal,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  MyText(
                    "01/05/2021",
                    fontSize: 12,
                    color: MyColors.color_6E7578,
                    fontWeight: FontWeight.normal,
                  ),
                ],
              ),
            ),
            Container(
              child: MyShadowContainer(
                shadowColor: MyColors.color_2FA1DB.withOpacity(.2),
                bgColor: MyColors.color_2FA1DB,
                margin: const EdgeInsets.only(right: 14),
                padding: const EdgeInsets.only(
                    left: 21, top: 6, bottom: 5, right: 21),
                borderRadius: BorderRadius.circular(50),
                child: Center(
                  child: MyText(
                    "Ready",
                    color: MyColors.color_FFFFFF,
                    fontSize: 10,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
