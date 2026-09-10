import 'package:blog_app/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class Usecase<SuccessType, Param> {
  Future<Either<Failures, SuccessType>> call(Param param);
}

class NoParam {}
