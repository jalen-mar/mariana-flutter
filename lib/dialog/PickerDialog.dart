import 'package:flutter/material.dart';
import 'package:mariana_flutter/dialog/picker/PickerBean.dart';
import 'package:mariana_flutter/dialog/picker/PickerSender.dart';

class PickerView extends StatefulWidget {
  static show(BuildContext context, Function provider, Function callback) {
    showDialog(context: context, builder: (context) {
      return PickerView(provider: provider, callback: callback,);
    });
  }

  static showMultiple(BuildContext context, Function provider, Function callback, bool isMultiple) {
    showDialog(context: context, builder: (context) {
      return PickerView(provider: provider, callback: callback, isMultiple: isMultiple);
    });
  }

  final List<PickerBean> parentNodes = [];
  final List<PickerBean> selectedNodes = [];
  final Map<String, List<PickerBean>> data = Map();
  final List<PickerBean> pickerData = [];
  final Function provider;
  final Function callback;
  final bool? isMultiple;

  PickerView({Key? key, required this.provider, required this.callback, this.isMultiple}) :super(key: key);

  @override
  State<StatefulWidget> createState() => PickerState();
}

class PickerState extends State<PickerView> with SingleTickerProviderStateMixin {
  List<Widget> _tabs = [];
  late Sender sender;
  final ScrollController controller = ScrollController();

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
        for (int i = 0; i < widget.parentNodes.length; i++) {
          if (widget.parentNodes[i].id == id) {
            setState(() {
              widget.parentNodes.removeRange(i, widget.parentNodes.length);
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
    if (widget.parentNodes.isNotEmpty) {
      widget.parentNodes.forEach((item) {
        _tabs.add(_createTab(item.name, item.id, false));
      });
      beanItem = widget.data[widget.parentNodes.last.id];
    } else {
      beanItem = widget.data[""];
    }
    _tabs.add(_createTab("请选择", "", true));
    if (controller.hasClients) {
      controller.jumpTo(controller.position.maxScrollExtent);
    }
    if (beanItem != null) {
      widget.pickerData.addAll(beanItem);
    } else {
      widget.provider.call(widget.parentNodes.isEmpty ? PickerBean("", "", null) : widget.parentNodes[widget.parentNodes.length - 1], sender);
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
                  Row(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          controller: controller,
                          child: Container(
                            constraints: BoxConstraints(
                              minWidth: MediaQuery.of(context).size.width - 40,
                            ),
                            child: Row(
                              children: _tabs,
                            ),
                          ),
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                      InkWell(
                        child: Container(
                          padding: EdgeInsets.only(left: 12, right: 12),
                          child: Text("确定", style: TextStyle(fontSize: 14, color: Theme.of(context).primaryColor,),),
                        ),
                        onTap: () {
                          if (widget.callback.call(widget.selectedNodes)) {
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ],
                  ),
                  Container(
                    color: Colors.grey[200],
                    height: 1,
                  ),
                  Expanded(
                    child: ListView.builder(itemBuilder: (BuildContext context, int index) {
                      return Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(width: 1, color: Colors.grey.shade100))
                                ),
                                alignment: Alignment.centerLeft,
                                child: Text(widget.pickerData[index].name),),
                              onTap: () {
                                setState(() {
                                  widget.parentNodes.add(widget.pickerData[index]);
                                  if (null == widget.isMultiple) {
                                    if (widget.callback.call(widget.parentNodes)) {
                                      Navigator.pop(context);
                                    } else {
                                      if (widget.pickerData[index].isExpand) {
                                        loadData();
                                      }
                                    }
                                  } else {
                                    if (widget.pickerData[index].isExpand) {
                                      loadData();
                                    }
                                  }
                                });
                              },
                            ),
                          ),
                          Offstage(
                            offstage: widget.isMultiple == null,
                            child: Checkbox( value: widget.selectedNodes.contains(widget.pickerData[index]), onChanged: (data) {
                              setState(() {
                                if (data == true) {
                                  if (widget.isMultiple != true) {
                                    widget.selectedNodes.clear();
                                  }
                                  widget.selectedNodes.add(widget.pickerData[index]);
                                } else {
                                  widget.selectedNodes.remove(widget.pickerData[index]);
                                }
                              });
                            },),
                          ),
                        ],
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