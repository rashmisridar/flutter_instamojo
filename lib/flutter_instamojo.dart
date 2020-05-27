library flutter_instamojo;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instamojo/bloc/instamojo_bloc.dart';
import 'package:flutter_instamojo/bloc/instamojo_event.dart';
import 'package:flutter_instamojo/bloc/instamojo_state.dart';
import 'package:flutter_instamojo/controllers/instamojo_controller.dart';
import 'package:flutter_instamojo/models/models.dart';
import 'package:flutter_instamojo/repositories/respositories.dart';
import 'package:flutter_instamojo/widgets/loader.dart';
import 'package:flutter_instamojo/widgets/payment_modes.dart';

export './controllers/instamojo_controller.dart';
export './models/create_order_body.dart';

class Instamojo extends StatefulWidget {
  final Environment environment;
  final ApiCallType apiCallType;
  final InstamojoPaymentStatusListener listener;
  final bool isConvenienceFeesApplied;

  const Instamojo(
      {Key key,
      @required this.isConvenienceFeesApplied,
      @required this.environment,
      @required this.apiCallType,
      @required this.listener})
      : super(key: key);
  @override
  _InstamojoState createState() => _InstamojoState();
}

class _InstamojoState extends State<Instamojo> {
  InstamojoRepository repository;
  @override
  void initState() {
    super.initState();
    BlocSupervisor.delegate = SimpleBlocDelegate();
    repository = InstamojoRepository(
        instamojoApiClient:
            InstamojoApiClient(environment: widget.environment));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          widget.listener.paymentStatus(status: {
            "statusCode": "201",
            "response": "Payment Cancelled By User"
          });
          return Future.value(false);
        },
        child: Scaffold(
          body: BlocProvider(
            create: (context) => InstamojoBloc(repository: repository),
            child: BlocBuilder<InstamojoBloc, InstamojoState>(
              builder: (context, state) {
                if (state is InstamojoEmpty) {
                  if (widget.apiCallType.callType == Type.CREATE_ORDER) {
                    BlocProvider.of<InstamojoBloc>(context).add(CreateOrder(
                        createOrderBody: widget.apiCallType.createOrderBody,
                        orderCreationUrl: widget.apiCallType.orderCreationUrl));
                  } else if (widget.apiCallType.callType ==
                      Type.START_PAYMENT) {
                    BlocProvider.of<InstamojoBloc>(context)
                        .add(InitPayment(orderId: widget.apiCallType.orderId));
                  }
                }
                if (state is InstamojoError) {
                  return Center(
                    child: Text('failed to satrt payment'),
                  );
                }
                if (state is InstamojoLoaded) {
                  switch (state.loadType) {
                    case LoadType.PaymentModel:
                      return PaymentModes(
                        isConvenienceFeesApplied:
                            widget.isConvenienceFeesApplied,
                        listener: widget.listener,
                        paymentOptions: state.paymentOptionModel.paymentOptions,
                        order: state.paymentOptionModel.order,
                        repository: repository,
                      );
                      break;

                    default:
                      return Text(state.paymentOptionModel.toString());
                  }
                }
                return Center(
                  child: Loader(),
                );
              },
            ),
          ),
        ));
  }
}

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}

class ApiCallType {
  final String orderId;
  final CreateOrderBody createOrderBody;
  final String orderCreationUrl;
  Type callType;

  ApiCallType.createOrder(
      {@required this.createOrderBody, this.orderCreationUrl})
      : orderId = null,
        callType = Type.CREATE_ORDER;

  ApiCallType.startPayment({@required this.orderId})
      : createOrderBody = null,
        orderCreationUrl = null,
        callType = Type.START_PAYMENT;
}

enum Type { CREATE_ORDER, START_PAYMENT }
enum Environment { TEST, PRODUCTION }
