class PickerBean {
  final String _id;
  final String _name;
  final Object? _tag;

  PickerBean(this._id, this._name, [this._tag]);

  get id => _id;
  get name => _name;
  get tag => _tag;
}