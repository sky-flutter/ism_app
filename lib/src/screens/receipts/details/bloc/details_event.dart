import 'package:ism_app/src/bloc/base_event.dart';
import 'package:ism_app/src/model/receipt_data.dart';

class ReceiptDetailsEvent extends BaseEvent {
  final String productId;
  final ReceiptData receiptData;

  ReceiptDetailsEvent(this.productId, this.receiptData);

  @override
  List<Object> get props => [this.productId, this.receiptData];
}
