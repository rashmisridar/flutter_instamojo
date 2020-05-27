import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instamojo/bloc/bloc.dart';
import 'package:flutter_instamojo/models/models.dart';
import 'package:flutter_instamojo/repositories/respositories.dart';
import 'package:meta/meta.dart';

class InstamojoBloc extends Bloc<InstamojoEvent, InstamojoState> {
  final InstamojoRepository repository;

  InstamojoBloc({@required this.repository}) : assert(repository != null);

  @override
  InstamojoState get initialState => InstamojoEmpty();

  @override
  Stream<InstamojoState> mapEventToState(InstamojoEvent event) async* {
    // CreateOrder Event check
    if (event is CreateOrder) {
      yield InstamojoLoading();
      try {
        final PaymentOptionModel paymentOptionModel =
            await repository.createOrder(event.createOrderBody,
                orderCreationUrl: event.orderCreationUrl);
        yield InstamojoLoaded(
            paymentOptionModel: paymentOptionModel,
            loadType: LoadType.PaymentModel);
      } catch (_) {
        yield InstamojoError();
      }
    }
    // InitPayment Event check
    else if (event is InitPayment) {
      yield InstamojoLoading();
      try {
        final PaymentOptionModel paymentOptionModel =
            await repository.initPayment(event.orderId);
        yield InstamojoLoaded(
            paymentOptionModel: paymentOptionModel,
            loadType: LoadType.PaymentModel);
      } catch (_) {
        yield InstamojoError();
      }
    }
    // CollectCardPayment Event check
    else if (event is CollectCardPayment) {
      yield InstamojoLoading();
      try {
        final String data = await repository.collectCardpayment(
            event.url, event.cardPaymentRequest);
        yield InstamojoLoaded(
            loadType: LoadType.CollectCardPayment, collectCardRequest: data);
      } catch (_) {
        yield InstamojoError();
      }
    }
    // SearchBank Event check
    else if (event is SearchBankEvent) {
      yield InstamojoLoading();
      try {
        final List<NetbankingOptionsChoice> data =
            await repository.searchBank(event.banks, event.query);
        yield InstamojoLoaded(loadType: LoadType.SearchBank, banks: data);
      } catch (_) {
        yield InstamojoError();
      }
    }
    // CollectUPIPayment Event check
    else if (event is CollectUPIPaymentEvent) {
      yield InstamojoLoading();
      try {
        final String data =
            await repository.collectUPIPayment(event.url, event.vpa);
        yield InstamojoLoaded(
            loadType: LoadType.CollectUPIPayment, collectUPIRequest: data);
      } catch (_) {
        yield InstamojoError();
      }
    }
    // GetUPIStatus Event check
    else if (event is GetUPIStatusEvent) {
      yield InstamojoLoading();
      try {
        final String data = await repository.getUPIStatus(event.url);
        yield InstamojoLoaded(
            loadType: LoadType.GetUPIStatus, getUPIStatus: data);
      } catch (_) {
        yield InstamojoError();
      }
    }
  }
}
