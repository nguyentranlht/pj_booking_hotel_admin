import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hotel_repository/hotel_repository.dart';

part 'create_pizza_event.dart';
part 'create_pizza_state.dart';

class CreatePizzaBloc extends Bloc<CreatePizzaEvent, CreatePizzaState> {
  HotelRepo pizzaRepo;

  CreatePizzaBloc(this.pizzaRepo) : super(CreatePizzaInitial()) {
    on<CreatePizza>((event, emit) async {
      emit(CreatePizzaLoading());
      try {
        await pizzaRepo.createHotels(event.pizza);
        emit(CreatePizzaSuccess());
      } catch (e) {
        emit(CreatePizzaFailure());
      }
    });
  }
}
