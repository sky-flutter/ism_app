import 'dart:collection';
import 'dart:convert';

import 'package:ism_app/imports.dart';
import 'package:ism_app/src/bloc/base_bloc.dart';
import 'package:ism_app/src/bloc/base_event.dart';
import 'package:ism_app/src/model/base_response.dart';
import 'package:ism_app/src/model/receipt_data.dart';

import 'operation_event.dart';

class OperationBloc extends BaseBloc<BaseEvent, BaseState> {
  OperationBloc() : super(UnInitiatedState());

  @override
  Stream<BaseState> mapEventToState(BaseEvent event) async* {
    if (event is ValidateReceiptDataEvent) {
      yield* validateReceiptData(event);
    }
  }

  Stream<BaseState> validateReceiptData(ValidateReceiptDataEvent event) async* {
    if (isConnectionAvailable()) {
      yield LoadingState();
      var data = createPickingData(event.receiptData);
      if (data != null) {
        Map<String, dynamic> params = HashMap();
        params[ApiConstant.PICKING_ID] = data;
        var response = await apiClient.call(
          url: ApiConstant.ENDPOINT_ACTION_VALIDATE,
          params: params,
        );
        if (response is BaseResponse) {
          clearAllStatus(event.receiptData);
          yield DataState<String>("Data saved successfully");
        } else {
          yield ErrorState(
              errorCode: (response as ErrorResponse).statusCode,
              errorMessage: (response as ErrorResponse).errorMessage);
        }
      } else {
        yield ErrorState(errorMessage: "Error in saving data");
      }
    } else {
      yield DataState("Data saved successfully");
    }
  }

  String createPickingData(ReceiptData receiptData) {
    List<Map<String, dynamic>> listData = [];
    if (!receiptData.isSynced) {
      if (receiptData.isEdited) {
        var moveLineIds = receiptData.moveLineIds
            .where((e) => e.isEdited != null && e.isEdited)
            .toList();
        if (moveLineIds != null && moveLineIds.isNotEmpty) {
          List<Map<String, dynamic>> listMoveData = moveLineIds.map((e) {
            if (e.isEdited != null && e.isEdited) {
              Map<String, dynamic> data = HashMap();
              data['product_qty'] = e.quantityDone.toInt();
              data['product_id'] = e.productId;
              data['lot'] = "${e.lot}";
              return data;
            }
          }).toList();
          listData.add(
              {"picking_id": receiptData.id, "move_line_ids": listMoveData});

          return json.encode(listData);
        }
      }
    }
    return null;
  }

  void clearAllStatus(ReceiptData receiptData) {
    receiptData.isSynced = true;
    receiptData.isEdited = false;
    receiptData.moveLineIds.forEach((element) {
      element.isEdited = false;
      element.isSynced = null;
    });
  }
}
