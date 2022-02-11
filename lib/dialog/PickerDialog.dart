import 'package:flutter/material.dart';
import 'package:mariana_flutter/dialog/picker/PickerBean.dart';
import 'package:mariana_flutter/dialog/picker/PickerSender.dart';

class PickerView extends StatefulWidget {
  static show(BuildContext context, int count, Function provider, Function callback) {
    showDialog(context: context, builder: (context) {
      return PickerView(provider: provider, callback: (List<PickerBean> data) {
        if (data.length >= count) {
          callback.call(data.sublist(0, count));
          return true;
        } else {
          return false;
        }
      },);
    });
  }

  final List<PickerBean> selected = [];
  final Map<String, List<PickerBean>> data = Map();
  final List<PickerBean> pickerData = [];
  final Function provider;
  final Function callback;

  PickerView({Key? key, required this.provider, required this.callback}) :super(key: key);

  @override
  State<StatefulWidget> createState() => PickerState();
}

class PickerState extends State<PickerView> with SingleTickerProviderStateMixin {
  List<Widget> _tabs = [];
  late Sender sender;

  Widget _createTab(String label, String id, bool isCurrent) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 12),
        child: Text(label, style: TextStyle(
            fontSize: 15,
            color: isCurrent ? Colors.pink : Colors.black
        ),),
      ),
      onTap: () {
        for (int i = 0; i < widget.selected.length; i++) {
          if (widget.selected[i].id == id) {
            setState(() {
              widget.selected.removeRange(i, widget.selected.length);
              loadData();
            });
            break;
          }
        }
      },
    );
  }

  @override
  void initState() {
    sender = SenderHandler(this);
    super.initState();
    loadData();
  }

  void loadData() {
    _tabs.clear();
    widget.pickerData.clear();
    List<PickerBean>? beanItem;
    if (widget.selected.isNotEmpty) {
      widget.selected.forEach((item) {
        _tabs.add(_createTab(item.name, item.id, false));
      });
      beanItem = widget.data[widget.selected.last.id];
    } else {
      beanItem = widget.data[""];
    }
    _tabs.add(_createTab("请选择", "", true));
    if (beanItem != null) {
      widget.pickerData.addAll(beanItem);
    } else {
      widget.provider.call(widget.selected.isEmpty ? PickerBean("", "", null) : widget.selected[widget.selected.length - 1], sender);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Column(
        children: <Widget>[
          InkWell(
            child: Container(height: MediaQuery.of(context).size.height / 3 * 2,),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  SingleChildScrollView(
                    child: Container(
                      constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width,
                      ),
                      child: Row(
                        children: _tabs,
                      ),
                    ),
                    scrollDirection: Axis.horizontal,
                  ),
                  Container(
                    color: Colors.grey[200],
                    height: 1,
                  ),
                  Expanded(
                    child: ListView.builder(itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(width: 1, color: Colors.grey.shade100))
                          ),
                          alignment: Alignment.centerLeft,
                          child: Text(widget.pickerData[index].name),),
                        onTap: () {
                          setState(() {
                            widget.selected.add(widget.pickerData[index]);
                            if (widget.callback.call(widget.selected)) {
                              Navigator.pop(context);
                            } else {
                              loadData();
                            }
                          });
                        },
                      );
                    },
                      itemCount: widget.pickerData.length,),
                  )
                ],
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ),
          )
        ],
      ),
    );
  }

  void setData(PickerBean bean, List<PickerBean> list) {
    setState(() {
      widget.data[bean.id] = list;
      loadData();
    });
  }
}