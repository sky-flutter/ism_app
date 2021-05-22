import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:ism_app/imports.dart';
import 'package:ism_app/src/model/receipt_data.dart';
import 'package:ism_app/src/screens/receipts/item/key_item.dart';
import 'package:ism_app/src/screens/receipts/item/value_item.dart';
import 'package:ism_app/src/screens/receipts/operation/bloc/operation_bloc.dart';
import 'package:ism_app/src/screens/receipts/operation/bloc/operation_event.dart';
import 'package:ism_app/src/widgets/button/button_solid.dart';
import 'package:ism_app/src/widgets/container/container.dart';
import 'package:ism_app/src/widgets/container/item_container.dart';
import 'package:ism_app/src/widgets/loading/loader.dart';

class DetailOperations extends StatefulWidget {
  ReceiptData receiptData;

  DetailOperations(this.receiptData);

  @override
  _DetailOperationsState createState() => _DetailOperationsState();
}

class _DetailOperationsState extends State<DetailOperations> {
  double initialDemand = 0;
  double quantityDone = 0;
  OperationBloc _operationBloc;

  @override
  void initState() {
    super.initState();
    _operationBloc = OperationBloc();
    widget.receiptData.moveLineIds.forEach((element) {
      if (element.reservedQty != null) {
        initialDemand += element.reservedQty;
      }
      if (element.quantityDone != null) {
        quantityDone += element.quantityDone;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OperationBloc>(
      create: (context) => _operationBloc,
      child: BlocListener<OperationBloc, BaseState>(
        listener: (BuildContext context, state) {
          if (state is LoadingState) {
            Get.dialog(Loader(), barrierDismissible: false);
          }
          if (state is DataState) {
            if (Get.isDialogOpen) {
              Get.back();
            }
            showSnackBar("Success", state.data, color: Colors.green);
          }

          if (state is ErrorState) {
            if (Get.isDialogOpen) {
              Get.back();
            }
            showSnackBar(S.of(context).error, state.errorMessage);
          }
        },
        child: Scaffold(
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
                        TopItemView(
                            widget.receiptData, initialDemand, quantityDone),
                        ListView.builder(
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            var moveLine =
                                widget.receiptData.moveLineIds[index];
                            return ListItem(
                              index: index,
                              from: widget.receiptData.location,
                              to: moveLine.destination,
                              lot: moveLine.lot,
                              quantityDone: moveLine.quantityDone,
                              reservedQty: moveLine.reservedQty,
                            );
                          },
                          primary: false,
                          shrinkWrap: true,
                          itemCount: widget.receiptData.moveLineIds.length,
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
                            _operationBloc.add(
                                ValidateReceiptDataEvent(widget.receiptData));
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
                            top: 24, left: 10, right: 20, bottom: 24),
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
        ),
      ),
    );
  }
}

class TopItemView extends StatelessWidget {
  ReceiptData receiptData;
  double initialDemand, quantityDone;

  TopItemView(this.receiptData, this.initialDemand, this.quantityDone);

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
                receiptData.name,
                color: MyColors.color_6E7578,
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
                initialDemand.toStringAsFixed(0),
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
                  "${quantityDone.toStringAsFixed(0)}/${initialDemand.toStringAsFixed(0)} Unit(s)",
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
  String from, to, lot;
  double quantityDone, reservedQty;

  ListItem(
      {this.index,
      this.from,
      this.to,
      this.lot,
      this.quantityDone,
      this.reservedQty});

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
                    title: "Done Qty",
                  ),
                  KeyItem(
                    title: "Reserved Qty",
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
                      title: from,
                      topMargin: 0,
                      textColor: MyColors.color_F18719,
                    ),
                    ValueItem(title: to, textColor: MyColors.color_F18719),
                    ValueItem(
                        title: lot ?? "", textColor: MyColors.color_6E7578),
                    ValueItem(
                        title: quantityDone.toStringAsFixed(0),
                        textColor: MyColors.color_F18719),
                    ValueItem(
                        title: reservedQty.toStringAsFixed(0),
                        textColor: MyColors.color_F18719),
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
