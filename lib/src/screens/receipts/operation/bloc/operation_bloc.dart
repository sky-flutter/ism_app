import 'dart:collection';
import 'dart:convert';

import 'package:ism_app/imports.dart';
import 'package:ism_app/src/bloc/base_bloc.dart';
import 'package:ism_app/src/bloc/base_event.dart';
import 'package:ism_app/src/model/base_response.dart';
import 'package:ism_app/src/model/receipt_data.dart';
import 'package:ism_app/src/screens/receipts/receipts/bloc/receipts_bloc.dart';

import 'operation_event.dart';

class OperationBloc extends BaseBloc<BaseEvent, BaseState> {
  List<ReceiptData> listReceiptData;

  OperationBloc() : super(UnInitiatedState());

  @override
  Stream<BaseState> mapEventToState(BaseEvent event) async* {
    if (event is ValidateReceiptDataEvent) {
      yield* validateReceiptData(event);
    }
    if (event is ValidateOfflineReceiptDataEvent) {
      yield* validateOfflineReceiptData(event);
    }
  }

  getReceiptData() async {
    listReceiptData = await HiveService.instance.getBoxes<ReceiptData>(ReceiptsBloc.boxNameReceiptData);
  }

  Stream<BaseState> validateReceiptData(ValidateReceiptDataEvent event) async* {
    if (await isConnectionAvailable()) {
      yield LoadingState();
      var data = createPickingData(event.receiptData);
      yield* uploadData(data, event);
    } else {
      yield DataState("Data saved successfully");
    }
  }

  Stream<BaseState> validateOfflineReceiptData(ValidateOfflineReceiptDataEvent event) async* {
    if (await isConnectionAvailable()) {
      yield LoadingState();
      if (listReceiptData == null) {
        await getReceiptData();
      }
      if (listReceiptData != null) {
        var data = offlineData(listReceiptData);
        if (data != null) {
          yield* uploadData(data, event);
        } else {
          yield DataState(null);
        }
      } else {
        yield DataState(null);
      }
    } else {
      yield DataState(null);
    }
  }

  Stream<BaseState> uploadData(String data, BaseEvent event) async* {
    if (data != null) {
      Map<String, dynamic> params = HashMap();
      params[ApiConstant.PICKING_ID] = data;
      var response =
          await apiClient.call(url: ApiConstant.ENDPOINT_ACTION_VALIDATE, params: params, method: ApiMethod.POST);
      if (response is BaseResponse) {
        if (event is ValidateReceiptDataEvent) {
          clearAllStatus(event.receiptData);
        } else {
          listReceiptData.forEach((element) {
            clearAllStatus(element);
          });
        }
        yield DataState<String>("Data saved successfully");
      } else {
        yield ErrorState(
            errorCode: (response as ErrorResponse).statusCode, errorMessage: (response as ErrorResponse).errorMessage);
      }
    } else {
      yield ErrorState(errorMessage: "Lot not found");
    }
  }

  String offlineData(List<ReceiptData> receiptData) {
    receiptData = receiptData.where((element) {
      if (element.isSynced != null && !element.isSynced) {
        if (element.isEdited != null && element.isEdited) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    }).toList();

    if (receiptData != null && receiptData.isNotEmpty) {
      var jsonData = receiptData.map((e) => createPickingData(e)).first;
      return jsonData;
    } else {
      return null;
    }
  }

  String createPickingData(ReceiptData receiptData) {
    List<Map<String, dynamic>> listData = [];
    if (receiptData.isSynced != null && !receiptData.isSynced) {
      if (receiptData.isEdited != null && receiptData.isEdited) {
        var moveLineIds = receiptData.moveLineIds.where((e) => e.isEdited != null && e.isEdited).toList();
        if (moveLineIds != null && moveLineIds.isNotEmpty) {
          List<Map<String, dynamic>> listMoveData = moveLineIds.map((e) {
            if (e.isEdited != null && e.isEdited) {
              Map<String, dynamic> data = HashMap();
              data['quantity_done'] = e.quantityDone.toInt();
              data['product_id'] = e.productUomId;
              data['lot_number'] = int.parse(e.lot);
              data['location_dest_id'] = e.toLocation?.id ?? "";
              return data;
            }
          }).toList();
          listData.add({"picking_id": receiptData.id, "move_line_ids": listMoveData});

          return json.encode(listData);
        }
      }
    }
    return null;
  }

  void clearAllStatus(ReceiptData receiptData) async {
    receiptData.isSynced = true;
    receiptData.isEdited = false;
    receiptData.moveLineIds.forEach((element) {
      element.isEdited = false;
      element.isSynced = null;
    });

    var receiptIndexOf = listReceiptData.indexOf(receiptData);
    await HiveService.instance.updateValue(receiptData, receiptIndexOf, ReceiptsBloc.boxNameReceiptData);
  }
}
