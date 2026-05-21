import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:serviko_app/core/errors/failures.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/shared/support/domain/entities/faq_item.dart';
import 'package:serviko_app/features/shared/support/domain/repositories/support_repository.dart';

// Use case to retrieve FAQ items
class GetFAQsUseCase implements UseCase<List<FaqItem>, GetFAQsParams> {
  final SupportRepository repository;

  const GetFAQsUseCase(this.repository);

  @override
  Future<Either<Failure, List<FaqItem>>> call(GetFAQsParams params) {
    return repository.getFAQs(category: params.category, search: params.search);
  }
}

class GetFAQsParams extends Equatable {
  final String? category;
  final String? search;

  const GetFAQsParams({this.category, this.search});

  @override
  List<Object?> get props => [category, search];
}
