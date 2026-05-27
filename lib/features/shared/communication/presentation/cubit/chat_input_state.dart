import 'package:equatable/equatable.dart';

abstract class ChatInputState extends Equatable {
  final double inputHeight;
  const ChatInputState({required this.inputHeight});

  @override
  List<Object?> get props => [inputHeight];
}

class ChatInputInitial extends ChatInputState {
  const ChatInputInitial({required super.inputHeight});
}

class ChatInputHeightChanged extends ChatInputState {
  const ChatInputHeightChanged({required super.inputHeight});
}
