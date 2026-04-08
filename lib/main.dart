import 'package:flutter/material.dart';

import 'app/app.dart';
import 'app/di.dart';

void main() {
  final dependencies = AppDependencies();
  runApp(FoodCheckApp(dependencies: dependencies));
}
