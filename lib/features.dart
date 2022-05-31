import 'package:feature_source_firebase/feature_source_firebase.dart';

class UseWeekDaysToggle extends FeatureToggle {
  UseWeekDaysToggle() : super(value: true);
  @override
  Feature<bool> creator() => UseWeekDaysToggle();
}
