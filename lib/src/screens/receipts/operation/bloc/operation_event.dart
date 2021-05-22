import 'package:ism_app/src/bloc/base_event.dart';
import 'package:ism_app/src/model/receipt_data.dart';

class ValidateReceiptDataEvent extends BaseEvent{
  final ReceiptData receiptData;

  ValidateReceiptDataEvent(this.receiptData);


  @override
  List<Object> get props => [this.receiptData];
}