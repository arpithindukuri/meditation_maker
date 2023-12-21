import 'package:meditation_maker/model/app_state.dart';
import 'package:meditation_maker/redux/app_state_redux.dart';
import 'package:redux/redux.dart';

final store = Store<AppState>(appReducer, initialState: AppState(), middleware: appMiddleware);
