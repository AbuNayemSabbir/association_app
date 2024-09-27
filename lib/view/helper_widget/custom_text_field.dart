
import 'package:association_app/utills/app_utills.dart';
import 'package:association_app/utills/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/platform/platform.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String prefixText;
  final String selectedCountryFlag;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool isSuffixIcon;
  final bool readOnly;
  final bool isPassword;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? openCountryPicker;
  final void Function()? onTap;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false,
    this.isSuffixIcon = false,
    this.readOnly = false,
    this.validator,
    this.onChanged,
    this.prefixText = '',
    this.selectedCountryFlag = '',
    this.keyboardType,
    this.openCountryPicker,
    this.onTap,
  });

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  bool _isPasswordVisible = false;
  String? _errorText;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _onChanged(String value) {
    if (widget.validator != null) {
      setState(() {
        _errorText = widget.validator!(value);
      });
    }
    if (widget.onChanged != null) {
      widget.onChanged!(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    ColorScheme colorScheme= theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(

          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: widget.controller,
          obscureText: widget.isPassword && !_isPasswordVisible,
          onChanged: _onChanged,
          readOnly: widget.readOnly,
          onTap: widget.onTap,

          keyboardType: widget.keyboardType,
          decoration: InputDecoration(
            // filled: true,
            // fillColor: CustomColors.grey200,
            prefixIcon: widget.prefixText == ''
                ? widget.prefixIcon != null
                ? Icon(widget.prefixIcon)
                : null
                : Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: widget.openCountryPicker,
                  child: Container(
                    decoration: BoxDecoration(
                      border: const Border(
                        right: BorderSide(color: CustomColors.grey500),
                      ),
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0,right: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(widget.selectedCountryFlag),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.only(left: 8, right: 6, top: GetPlatform.isIOS? 0:2),
                  child: Center(
                    child: Text(
                      widget.prefixText,
                      style: const TextStyle(fontSize: 16),
                      maxLines: 1,
                    ),
                  ),
                ),
              ],
            ),
            suffixIcon: widget.isSuffixIcon
                ? const Icon(Icons.arrow_drop_down_sharp)
                :widget.isPassword
                ? Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                icon: Icon(
                  _isPasswordVisible?Icons.visibility:Icons.visibility_off
                ),onPressed: _togglePasswordVisibility,
              ),
            ):
            (_errorText != null
                ?  Icon(Icons.warning, color: colorScheme.error)
                : widget.suffixIcon != null
                ? Icon(widget.suffixIcon)
                : null) ,
            labelText: widget.label,
            hintText:  widget.label,
            errorText: _errorText,
            //filled: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            prefixIconColor: CustomColors.grey800,
            suffixIconColor: CustomColors.grey900,
            //fillColor: CustomColors.grey100.withOpacity(0.5),
            labelStyle: const TextStyle(color: CustomColors.grey700),
            hintStyle: const TextStyle(color: CustomColors.grey500),
            border: const OutlineInputBorder(),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide:  BorderSide(width: 1, color: colorScheme.error),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide:  const BorderSide(width: 1, color: CustomColors.primaryColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(
                // color: CustomColors.tFBC,
                color: CustomColors.grey300,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide:  BorderSide(width: 1, color: colorScheme.error),
            ),
            errorStyle:  TextStyle(fontWeight: FontWeight.bold, color: colorScheme.error),
          ),
          validator: widget.validator ??
                  (value) {
                if(widget.label=='Sponsor'){
                  return null;
                }
                else if (value == null || value.isEmpty ) {
                  return '${widget.label} ${AppUtils.fieldWarning})';
                }  else if (widget.label == 'Password' &&
                    !isPasswordValid(value)) {
                  return AppUtils.passwordWarning;
                }
                return null;
              },
          /*       style: TextStyle(
            color: colorScheme.onSecondary,
          ),*/
        ),
        //const SizedBox(height: 6),
      ],
    );
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email.trim());
  }

  bool isPasswordValid(String password) {
    return password.isNotEmpty && password.length >= 8;
  }
}
