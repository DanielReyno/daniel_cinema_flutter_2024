

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviedb_app/presentation/providers/providers.dart';

final initialLoadingProvider = Provider<bool>((ref) {
  final step1 = ref.watch(nowPlayingMoviesProvider).isEmpty;
  final step2 = ref.watch(movieSlideshowProvider).isEmpty;
  final step3 = ref.watch(getUpcomingMoviesProvider).isEmpty;
  final step4 = ref.watch(getTopRatedMoviesProvider).isEmpty;

  if(step1 || step2 || step3 || step4) return true;

  return false;
});