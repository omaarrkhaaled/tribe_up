import 'package:flutter/material.dart';
import 'package:tribe_up/core/constants/ui_constants.dart';

class PasswordFieldWidget extends StatefulWidget {
  final TextEditingController password;
  final void Function(String) onChanged;

  const PasswordFieldWidget({
    super.key,
    required this.password,
    required this.onChanged,
  });

  @override
  State<PasswordFieldWidget> createState() => _PasswordFieldWidgetState();
}

class _PasswordFieldWidgetState extends State<PasswordFieldWidget> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: widget.password,
          obscureText: _obscure,
          decoration: InputDecoration(
            labelText: UiConstants.password,
            hintText: UiConstants.enterPassword,
            helperText: '',
            suffixIcon: IconButton(
              icon: Icon(
                _obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
          ),
          onChanged: widget.onChanged,
        ),
      ],
    );
  }
}
