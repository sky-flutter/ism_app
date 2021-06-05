import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:ism_app/imports.dart';
import 'package:ism_app/src/model/receipt_data.dart';
import 'package:ism_app/src/screens/receipts/item/key_item.dart';
import 'package:ism_app/src/screens/receipts/item/value_item.dart';
import 'package:ism_app/src/screens/receipts/operation/bloc/operation_bloc.dart';
import 'package:ism_app/src/screens/receipts/operation/bloc/operation_event.dart';
import 'package:ism_app/src/utils/error_handler.dart';
import 'package:ism_app/src/widgets/button/button_solid.dart';
import 'package:ism_app/src/widgets/container/container.dart';
import 'package:ism_app/src/widgets/container/container_shadow.dart';
import 'package:ism_app/src/widgets/container/item_container.dart';
import 'package:ism_app/src/widgets/dialog/dialog.dart';
import 'package:ism_app/src/widgets/dropdown/dropdown.dart';
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
  Future<List<Location>> futureLocationData;

  @override
  void initState() {
    super.initState();
    _operationBloc = OperationBloc();
    futureLocationData = _operationBloc.getCachedLocationData();
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
            showProgressDialog();
          }
          if (state is DataState) {
            if (Get.isDialogOpen) {
              Get.back();
            }
            Get.back();
            showSnackBar("Success", state.data, color: Colors.green);
          }

          if (state is ErrorState) {
            if (Get.isDialogOpen) {
              Get.back();
            }
            Get.back();
            showSnackBar(
                S.of(context).error, state.errorMessage ?? ErrorHandler.getErrorMessage(state.errorCode) ?? "");
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
                        TopItemView(widget.receiptData, initialDemand, quantityDone),
                        ListView.builder(
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            var moveLine = widget.receiptData.moveLineIds[index];
                            return FutureBuilder(
                              builder: (context, AsyncSnapshot<List<Location>> snapshot) {
                                if (snapshot.hasData) {
                                  if (moveLine.fromLocation == null) {
                                    if (moveLine.locationFrom != null) {
                                      var selectedLocation = _operationBloc.getSelectedLocation(moveLine.locationFrom);
                                      if (selectedLocation == null) {
                                        selectedLocation = snapshot.data[0];
                                      }
                                      moveLine.fromLocation = selectedLocation;
                                    } else {
                                      moveLine.fromLocation = snapshot.data[0];
                                    }
                                  }
                                  if (moveLine.toLocation == null) {
                                    if (moveLine.destination != null) {
                                      var selectedLocation = _operationBloc.getSelectedLocation(moveLine.destination);
                                      if (selectedLocation == null) {
                                        selectedLocation = snapshot.data[0];
                                      }
                                      moveLine.toLocation = selectedLocation;
                                    } else {
                                      moveLine.toLocation = snapshot.data[0];
                                    }
                                  }
                                  return ListItem(
                                    index: index,
                                    from: widget.receiptData.destocationName,
                                    moveLine: moveLine,
                                    location: snapshot.data,
                                    onFromLocationChange: (data) {
                                      setState(() {});
                                    },
                                    onTap: () {
                                      moveLine.isEditMode = !moveLine.isEditMode;
                                      setState(() {});
                                    },
                                  );
                                }
                                return Container(
                                  child: Loader(),
                                );
                              },
                              future: futureLocationData,
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
                        margin: const EdgeInsets.only(top: 24, left: 20, right: 10, bottom: 24),
                        width: double.infinity,
                        child: MyButton(
                          Strings.confirm,
                          () {
                            _operationBloc.add(ValidateReceiptDataEvent(widget.receiptData));
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
                        margin: const EdgeInsets.only(top: 24, left: 10, right: 20, bottom: 24),
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
  String from;
  Function onTap;
  Function(dynamic data) onFromLocationChange;
  MoveLineIds moveLine;
  List<Location> location;

  ListItem({this.index, this.location, this.onTap, this.from, this.moveLine, this.onFromLocationChange});

  @override
  Widget build(BuildContext context) {
    return MyItemContainer(
      margin: EdgeInsets.only(
        top: index == 0 ? 27 : 0,
        bottom: index == -1 ? 0 : 27,
        left: 20,
        right: 20,
      ),
      outlineColor: MyColors.color_E2E9EF,
      shadowColor: MyColors.color_0A0F3712,
      children: Stack(
        children: [
          Positioned.fill(
            child: Row(
              children: [
                Expanded(
                  flex: 45,
                  child: Container(
                    decoration: BoxDecoration(
                      color: MyColors.color_E2E9EF,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 55,
                  child: SizedBox(),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, top: 20, bottom: 26, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 45,
                      child: KeyItem(
                        title: "From",
                        topMargin: 0,
                      ),
                    ),
                    Expanded(
                      child: Container(),
                      flex: 05,
                    ),
                    if (location != null)
                      Expanded(
                        flex: 50,
                        child: AbsorbPointer(
                          absorbing: !moveLine.isEditMode,
                          child: MyShadowContainer(
                              alignment: Alignment.centerLeft,
                              child: MyDropDown<Location>(
                                location,
                                moveLine.fromLocation,
                                icon: moveLine.isEditMode ? Icon(Icons.arrow_drop_down_outlined) : Container(),
                                onChangeListener: (data) {
                                  moveLine.fromLocation = data;
                                  onFromLocationChange.call(data);
                                },
                              )),
                        ),
                      ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 45,
                      child: KeyItem(
                        title: "To",
                      ),
                    ),
                    Expanded(
                      child: Container(),
                      flex: 05,
                    ),
                    if (location != null)
                      Expanded(
                        flex: 50,
                        child: AbsorbPointer(
                          absorbing: !moveLine.isEditMode,
                          child: MyShadowContainer(
                              alignment: Alignment.centerLeft,
                              child: MyDropDown<Location>(
                                location,
                                moveLine.toLocation,
                                icon: moveLine.isEditMode ? Icon(Icons.arrow_drop_down_outlined) : Container(),
                                onChangeListener: (data) {
                                  moveLine.toLocation = data;
                                  onFromLocationChange.call(data);
                                },
                              )),
                        ),
                      ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 45,
                      child: KeyItem(title: "Lot"),
                    ),
                    Expanded(
                      child: Container(),
                      flex: 05,
                    ),
                    Expanded(
                      flex: 50,
                      child: ValueItem(title: moveLine?.lotId?.toString() ?? "", textColor: MyColors.color_F18719),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 45,
                      child: KeyItem(
                        title: "Done Qty",
                      ),
                    ),
                    Expanded(
                      child: Container(),
                      flex: 05,
                    ),
                    Expanded(
                      flex: 50,
                      child: ValueItem(
                          title: moveLine?.quantityDone?.toStringAsFixed(0) ?? "", textColor: MyColors.color_F18719),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 45,
                      child: KeyItem(
                        title: "Reserved Qty",
                      ),
                    ),
                    Expanded(
                      child: Container(),
                      flex: 05,
                    ),
                    Expanded(
                      flex: 50,
                      child: ValueItem(
                          title: moveLine?.reservedQty?.toStringAsFixed(0) ?? "", textColor: MyColors.color_F18719),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 45,
                      child: KeyItem(title: "Units of measure"),
                    ),
                    Expanded(
                      child: Container(),
                      flex: 05,
                    ),
                    Expanded(
                      flex: 50,
                      child: ValueItem(title: "Unit(s)", textColor: MyColors.color_F18719),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                      onTap: () {
                        onTap.call();
                      },
                      radius: 100,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: MyColors.color_2FA1DB, shape: BoxShape.circle),
                        child: Icon(
                          moveLine.isEditMode ? Icons.check : Icons.edit_outlined,
                          color: MyColors.color_FFFFFF,
                          size: 20,
                        ),
                      )),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
