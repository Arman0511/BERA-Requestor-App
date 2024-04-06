// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'no_acc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NoAcc _$NoAccFromJson(Map<String, dynamic> json) {
  return _NoAcc.fromJson(json);
}

/// @nodoc
mixin _$NoAcc {
  String get uid => throw _privateConstructorUsedError;
  String? get phonenumber => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NoAccCopyWith<NoAcc> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NoAccCopyWith<$Res> {
  factory $NoAccCopyWith(NoAcc value, $Res Function(NoAcc) then) =
      _$NoAccCopyWithImpl<$Res, NoAcc>;
  @useResult
  $Res call({String uid, String? phonenumber});
}

/// @nodoc
class _$NoAccCopyWithImpl<$Res, $Val extends NoAcc>
    implements $NoAccCopyWith<$Res> {
  _$NoAccCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? phonenumber = freezed,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      phonenumber: freezed == phonenumber
          ? _value.phonenumber
          : phonenumber // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NoAccImplCopyWith<$Res> implements $NoAccCopyWith<$Res> {
  factory _$$NoAccImplCopyWith(
          _$NoAccImpl value, $Res Function(_$NoAccImpl) then) =
      __$$NoAccImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String uid, String? phonenumber});
}

/// @nodoc
class __$$NoAccImplCopyWithImpl<$Res>
    extends _$NoAccCopyWithImpl<$Res, _$NoAccImpl>
    implements _$$NoAccImplCopyWith<$Res> {
  __$$NoAccImplCopyWithImpl(
      _$NoAccImpl _value, $Res Function(_$NoAccImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? phonenumber = freezed,
  }) {
    return _then(_$NoAccImpl(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      phonenumber: freezed == phonenumber
          ? _value.phonenumber
          : phonenumber // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NoAccImpl implements _NoAcc {
  const _$NoAccImpl({required this.uid, required this.phonenumber});

  factory _$NoAccImpl.fromJson(Map<String, dynamic> json) =>
      _$$NoAccImplFromJson(json);

  @override
  final String uid;
  @override
  final String? phonenumber;

  @override
  String toString() {
    return 'NoAcc(uid: $uid, phonenumber: $phonenumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NoAccImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.phonenumber, phonenumber) ||
                other.phonenumber == phonenumber));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, uid, phonenumber);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NoAccImplCopyWith<_$NoAccImpl> get copyWith =>
      __$$NoAccImplCopyWithImpl<_$NoAccImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NoAccImplToJson(
      this,
    );
  }
}

abstract class _NoAcc implements NoAcc {
  const factory _NoAcc(
      {required final String uid,
      required final String? phonenumber}) = _$NoAccImpl;

  factory _NoAcc.fromJson(Map<String, dynamic> json) = _$NoAccImpl.fromJson;

  @override
  String get uid;
  @override
  String? get phonenumber;
  @override
  @JsonKey(ignore: true)
  _$$NoAccImplCopyWith<_$NoAccImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
