import 'package:freezed_annotation/freezed_annotation.dart';

part 'no_acc.g.dart';
part 'no_acc.freezed.dart';

@Freezed()
class NoAcc with _$NoAcc {
  const factory NoAcc({
    required String uid,
    required String? phonenumber,
  }) = _NoAcc;

  factory NoAcc.fromJson(Map<String, dynamic> json) => _$NoAccFromJson(json);
}
