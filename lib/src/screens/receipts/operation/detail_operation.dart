import 'package:ism_app/imports.dart';
import 'package:ism_app/src/screens/receipts/item/key_item.dart';
import 'package:ism_app/src/screens/receipts/item/value_item.dart';
import 'package:ism_app/src/widgets/button/button_solid.dart';
import 'package:ism_app/src/widgets/container/container.dart';
import 'package:ism_app/src/widgets/container/item_container.dart';

class DetailOperations extends StatefulWidget {
  @override
  _DetailOperationsState createState() => _DetailOperationsState();
}

class _DetailOperationsState extends State<DetailOperations> {
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
          Strings.detailedOperation,
          color: MyColors.color_FFFFFF,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      body: MyContainer(
        bgColor: MyColors.color_F8FAFB,
        children: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TopItemView(),
                    ListView.builder(
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ListItem(index: index);
                      },
                      primary: false,
                      shrinkWrap: true,
                      itemCount: 2,
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                        top: 24, left: 20, right: 10, bottom: 24),
                    width: double.infinity,
                    child: MyButton(
                      Strings.confirm,
                      () {
                        MyNavigator.pushReplacedNamed(Routes.strHomeRoute);
                      },
                      outlineColor: MyColors.color_F18719,
                      textColor: MyColors.color_FFFFFF,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      buttonBgColor: MyColors.color_F18719,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                        top: 24, left: 10, right: 20, bottom: 48),
                    width: double.infinity,
                    child: MyButton(
                      Strings.discard,
                      () {
                        MyNavigator.pushReplacedNamed(Routes.strHomeRoute);
                      },
                      outlineColor: MyColors.color_F18719,
                      textColor: MyColors.color_F18719,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TopItemView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyItemContainer(
      margin: const EdgeInsets.only(
        top: 33,
        left: 20,
        right: 20,
      ),
      padding: EdgeInsets.only(
        bottom: 28,
        left: 20,
        top: 19,
        right: 20,
      ),
      outlineColor: MyColors.color_E2E9EF,
      shadowColor: MyColors.color_0A0F3712,
      children: Column(
        children: [
          Row(
            children: [
              MyText(
                "Product : ",
                color: MyColors.color_3F4446,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              SizedBox(
                width: 11,
              ),
              MyText(
                "19.000",
                color: MyColors.color_6E7578,
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
              MyText(
                " Unit(s)",
                color: MyColors.color_F18719,
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              MyText(
                "Initial Demand : ",
                color: MyColors.color_3F4446,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              SizedBox(
                width: 11,
              ),
              MyText(
                "19.000 / 19.000",
                color: MyColors.color_6E7578,
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
              Expanded(
                child: MyText(
                  " Unit(s)",
                  color: MyColors.color_F18719,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              MyText(
                "Quantity Done : ",
                color: MyColors.color_3F4446,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              SizedBox(
                width: 11,
              ),
              Expanded(
                child: MyText(
                  "[Access-Bur-00001] Modem",
                  color: MyColors.color_F18719,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          )
        ],
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
                    title: "From",
                    topMargin: 0,
                  ),
                  KeyItem(
                    title: "To",
                  ),
                  KeyItem(
                    title: "Lot",
                  ),
                  KeyItem(
                    title: "Done",
                  ),
                  KeyItem(
                    title: "Unit of Measure",
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
                      title: "Partner Locations/Vendors",
                      topMargin: 0,
                      textColor: MyColors.color_F18719,
                    ),
                    ValueItem(
                        title: "MAG_ODJA/Stock",
                        textColor: MyColors.color_F18719),
                    ValueItem(title: "0000", textColor: MyColors.color_6E7578),
                    ValueItem(
                        title: "19.000", textColor: MyColors.color_F18719),
                    ValueItem(
                        title: "Unit(s)", textColor: MyColors.color_F18719),
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
