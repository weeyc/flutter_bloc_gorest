import "dart:async";
import "package:flutter/material.dart";
import "package:go_rest_bloc/utils/log_utils.dart";

class ErrorHandler {
  const ErrorHandler._();

  static void catchAll(VoidCallback callback) {
    runZonedGuarded(() async {
      FlutterError.onError = (FlutterErrorDetails details) {
        final bool notImportantErrors = details.silent;

        if (notImportantErrors) {
          LogUtil.warning(
            "Not important error  \nERROR DETAILS:\n - ${details.exception}",
            //exception: details.exception,
            stackTrace: StackTrace.fromString(details.toString()),
          );
        } else {
          LogUtil.error(
            "Flutter error - ${details.toStringShort()} \nERROR DETAILS:\n - ${details.exception}",
            // exception: ,
            stackTrace: StackTrace.fromString(details.toString()),
          );
        }
      };

      callback();
    }, (exception, stackTrace) async {
      LogUtil.error(
        "Async error \nERROR DETAILS:\n - $exception",
        //exception: exception,
        stackTrace: stackTrace,
      );
    });
  }
}
