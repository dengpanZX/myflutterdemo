class MarketTitleItem {
  String code;
  String fid;
  String id;
  String name;
  int sort;
  String state;
  String value;

  MarketTitleItem({this.code,
    this.fid,
    this.id,
    this.name,
    this.sort,
    this.state,
    this.value});

  MarketTitleItem.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    fid = json['fid'];
    id = json['id'];
    name = json['name'];
    sort = json['sort'];
    state = json['state'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['fid'] = this.fid;
    data['id'] = this.id;
    data['name'] = this.name;
    data['sort'] = this.sort;
    data['state'] = this.state;
    data['value'] = this.value;
    return data;
  }
}