import '../../../imports.dart';

typedef OnChangeListener = Function(dynamic data);

class MyDropDown<T> extends StatefulWidget {
  List<T> data;
  T selectedValue;
  Widget underline;
  OnChangeListener onChangeListener;

  MyDropDown(this.data, this.selectedValue,
      {this.onChangeListener, this.underline})
      : assert(data != null && data.length > 0);

  @override
  _MyDropDownState createState() => _MyDropDownState<T>();
}

class _MyDropDownState<T> extends State<MyDropDown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      isExpanded: false,
      icon: Container(),
      underline: widget.underline ?? Container(),
      items: widget.data
          .map<DropdownMenuItem<T>>((e) => DropdownMenuItem(
                value: e,
                child: Container(
                  child: MyText(
                    e.data,
                    fontSize: 16,
                  ),
                  padding: EdgeInsets.only(right: 48),
                ),
              ))
          .toList(),
      value: widget.selectedValue,
      onChanged: (data) {
        widget.onChangeListener(data);
      },
    );
  }
}
