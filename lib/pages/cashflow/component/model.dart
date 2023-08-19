class CashFlowModel {
  final String id;
  final String sub;
  final String cat;
  final String amount;
  final String month;
  final String year;
  final String? type;
  final String date;

  CashFlowModel({
    required this.id,
    required this.sub,
    required this.cat,
    required this.amount,
    required this.date,
    required this.month,
    this.type,
    required this.year,
  });

  factory CashFlowModel.fromMap(Map<String, dynamic> map) {
    return CashFlowModel(
        id: map['id'],
        sub: map['sub'],
        amount: map['amount'],
        cat: map['cat'],
        type: map['type'],
        date: map['date'],
        month: map['month'],
        year: map['year']);
  }
}

class PrintCashTotalModel {
  final dynamic jan;
  final dynamic feb;
  final dynamic mar;
  final dynamic apirl;
  final dynamic may;
  final dynamic june;
  final dynamic july;
  final dynamic aug;
  final dynamic sep;
  final dynamic oct;
  final dynamic nov;
  final dynamic dec;

  PrintCashTotalModel({
    required this.jan,
    required this.feb,
    required this.mar,
    required this.apirl,
    required this.may,
    required this.june,
    required this.july,
    required this.aug,
    required this.sep,
    required this.oct,
    required this.nov,
    required this.dec,
  });

  factory PrintCashTotalModel.fromJson(Map<String, dynamic> map) {
    return PrintCashTotalModel(
        jan: map['jan'],
        feb: map['feb'],
        mar: map['mar'],
        apirl: map['april'],
        may: map['may'],
        june: map['june'],
        july: map['july'],
        aug: map['aug'],
        sep: map['sep'],
        oct: map['oct'],
        nov:map['nov'],
        dec: map['decem']);
  }
}

// class CashModels {
//   final List<PrintCashModel> cashFlowModel;
//   final List<PrintCashTotalModel> cashFlowTotal;

//   CashModels({required this.cashFlowModel, required this.cashFlowTotal});
// }

class MonthCashModel {
  final String id;
  final String name;
  final List<SubMonthCashModel> subList;
  final List<SubCashModel> subTotal;

  MonthCashModel(
      {required this.subTotal,
      required this.id,
      required this.subList,
      required this.name});
}

class SubMonthCashModel {
  final String name;
  final dynamic firstWeek;
  final dynamic secWeek;
  final dynamic thirdWeek;
  final dynamic fouthWeek;
  final dynamic fiveWeek;

  SubMonthCashModel(
      {required this.name,
      required this.firstWeek,
      required this.secWeek,
      required this.thirdWeek,
      required this.fouthWeek,
      required this.fiveWeek});

  factory SubMonthCashModel.fromJson(Map<String, dynamic> map) {
    return SubMonthCashModel(
        name: map['name'],
        firstWeek: map['first_week'],
        secWeek: map['sec_week'],
        thirdWeek: map['third_week'],
        fouthWeek: map['fourth_week'],
        fiveWeek: map['fifth_week']);
  }
}

class SubCashModel {
  final dynamic firstWeek;
  final dynamic secWeek;
  final dynamic thirdWeek;
  final dynamic fouthWeek;
  final dynamic fiveWeek;

  SubCashModel(
      {required this.firstWeek,
      required this.secWeek,
      required this.thirdWeek,
      required this.fouthWeek,
      required this.fiveWeek});

  factory SubCashModel.fromJson(Map<String, dynamic> map) {
    return SubCashModel(
        firstWeek: map['first_week'],
        secWeek: map['sec_week'],
        thirdWeek: map['third_week'],
        fouthWeek: map['fourth_week'],
        fiveWeek: map['fifth_week']);
  }
}

///---------------------year model-----------------------------------

class YearCashModel {
  final String id;
  final String name;
  final List<SubYearCashModel> subList;
  final List<SubCashYearModel> subTotal;

  YearCashModel(
      {required this.subTotal,
      required this.id,
      required this.subList,
      required this.name});
}

class SubYearCashModel {
  final String name;
  final dynamic jan;
  final dynamic feb;
  final dynamic mar;
  final dynamic apirl;
  final dynamic may;
  final dynamic june;
  final dynamic july;
  final dynamic aug;
  final dynamic sep;
  final dynamic oct;
  final dynamic nov;
  final dynamic dec;

  SubYearCashModel({
    required this.name,
    required this.jan,
    required this.feb,
    required this.mar,
    required this.apirl,
    required this.may,
    required this.june,
    required this.july,
    required this.aug,
    required this.sep,
    required this.oct,
    required this.nov,
    required this.dec,
  });

  factory SubYearCashModel.fromJson(Map<String, dynamic> map) {
    return SubYearCashModel(
        name: map['name'],
        jan:map['jan'],
        feb: map['feb'],
        mar:map['mar'],
        apirl: map['april'],
        may: map['may'],
        june: map['june'],
        july: map['july'],
        aug: map['aug'],
        sep: map['sep'],
        oct: map['oct'],
        nov: map['nov'],
        dec: map['decem']);
  }
}

class SubCashYearModel {
  final dynamic jan;
  final dynamic feb;
  final dynamic mar;
  final dynamic apirl;
  final dynamic may;
  final dynamic june;
  final dynamic july;
  final dynamic aug;
  final dynamic sep;
  final dynamic oct;
  final dynamic nov;
  final dynamic dec;

  SubCashYearModel({
    required this.jan,
    required this.feb,
    required this.mar,
    required this.apirl,
    required this.may,
    required this.june,
    required this.july,
    required this.aug,
    required this.sep,
    required this.oct,
    required this.nov,
    required this.dec,
  });

  factory SubCashYearModel.fromJson(Map<String, dynamic> map) {
    return SubCashYearModel(
        jan: map['jan'],
        feb: map['feb'],
        mar: map['mar'],
        apirl: map['april'],
        may: map['may'],
        june: map['june'],
        july: map['july'],
        aug: map['aug'],
        sep: map['sep'],
        oct: map['oct'],
        nov: map['nov'],
        dec: map['decem']);
  }
}
