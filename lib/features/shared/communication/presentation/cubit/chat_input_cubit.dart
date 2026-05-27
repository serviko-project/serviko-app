import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_input_state.dart';

class ChatInputCubit extends Cubit<ChatInputState> {
  ChatInputCubit() : super(const ChatInputInitial(inputHeight: 70.0));

  void updateHeight(double height) {
    if (state.inputHeight != height) {
      emit(ChatInputHeightChanged(inputHeight: height));
    }
  }
}
