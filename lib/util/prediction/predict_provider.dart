import 'predict_fake.dart' if (dart.library.html) 'predict_real.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut3/util/prediction/predict.dart';

final predictProvider = Provider((ref) {
  // ignore: unnecessary_cast
  return PredictImpl() as Predict;
});
