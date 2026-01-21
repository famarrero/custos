import 'package:custos/presentation/pages/otp/components/otp_code/cubit/otp_code_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpCodeWidget extends StatelessWidget {
  final String secret;
  final int interval;
  final int digits;
  final Function(String)? tempCode;

  const OtpCodeWidget({super.key, required this.secret, this.interval = 30, this.digits = 6, this.tempCode});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OtpCodeCubit(secret: secret, interval: interval, digits: digits),
      child: BlocConsumer<OtpCodeCubit, OtpCodeState>(
        listenWhen: (previous, current) => previous.code != current.code,
        listener: (context, state) {
          if (tempCode != null) {
            tempCode!(state.code);
          }
        },
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(state.code, style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, letterSpacing: 4)),
              const SizedBox(height: 12),
              SizedBox(
                width: 180,
                child: LinearProgressIndicator(
                  value: state.progress,
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(height: 6),
              Text('Next in ${state.remainingSeconds} s', style: Theme.of(context).textTheme.bodySmall),
            ],
          );
        },
      ),
    );
  }
}
