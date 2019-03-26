class RankCoinItem {
  String buyName;
  String id;
  var last;
  String logo;
  var low;
  var range;
  String sellId;
  String sellName;
  String symbol;
  var up;
  var volume;
  String webLogo;

  RankCoinItem(
      {this.buyName,
        this.id,
        this.last,
        this.logo,
        this.low,
        this.range,
        this.sellId,
        this.sellName,
        this.symbol,
        this.up,
        this.volume,
        this.webLogo});

  RankCoinItem.fromJson(Map<String, dynamic> json) {
    buyName = json['buyName'];
    id = json['id'];
    last = json['last'];
    logo = json['logo'];
    low = json['low'];
    range = json['range'];
    sellId = json['sellId'];
    sellName = json['sellName'];
    symbol = json['symbol'];
    up = json['up'];
    volume = json['volume'];
    webLogo = json['webLogo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['buyName'] = this.buyName;
    data['id'] = this.id;
    data['last'] = this.last;
    data['logo'] = this.logo;
    data['low'] = this.low;
    data['range'] = this.range;
    data['sellId'] = this.sellId;
    data['sellName'] = this.sellName;
    data['symbol'] = this.symbol;
    data['up'] = this.up;
    data['volume'] = this.volume;
    data['webLogo'] = this.webLogo;
    return data;
  }
}