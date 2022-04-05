class FeedbackModel {
  //String? a;
  String a;
  String b;
  String c;
  String d;

  FeedbackModel(
      { required this.a, required this.b, required this.c, required this.d});

  factory FeedbackModel.fromJson(dynamic json) {
    return FeedbackModel(
      a: "${json['a']}",
      b: "${json['b']}",
      c: "${json['c']}",
      d: "${json['d']}",
    );
  }

  Map toJson() => {
    "a": a,
    "b": b,
    "c": c,
    "d": d,
  };
}
