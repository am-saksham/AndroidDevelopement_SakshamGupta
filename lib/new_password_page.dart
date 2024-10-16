import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_round/verify_code_page.dart';

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({super.key});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Real-time password validation
  void _validatePassword() {
    if (_passwordController.text.isEmpty) {
      setState(() {
        _passwordError = 'Please enter your password';
      });
    } else if (_passwordController.text.length < 6) {
      setState(() {
        _passwordError = 'Password must be at least 6 characters';
      });
    } else {
      setState(() {
        _passwordError = null;
      });
    }
  }

  // Real-time confirm password validation
  void _validateConfirmPassword() {
    if (_confirmPasswordController.text.isEmpty) {
      setState(() {
        _confirmPasswordError = 'Please confirm your password';
      });
    } else if (_confirmPasswordController.text != _passwordController.text) {
      setState(() {
        _confirmPasswordError = 'Passwords do not match';
      });
    } else {
      setState(() {
        _confirmPasswordError = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const VerifyCodePage()));
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView( // Make the body scrollable
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Create New Password",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Text(
                'Your new password must be different \nfrom previously used password',
                style: TextStyle(
                  color: Color(0xFF8A8A8A),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              _buildTextField(
                hintText: 'Password',
                isObscure: !_isPasswordVisible,
                toggleVisibility: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
                controller: _passwordController,
                errorText: _passwordError,
              ),
              const SizedBox(height: 18),
              _buildTextField(
                hintText: 'Confirm Password',
                isObscure: !_isConfirmPasswordVisible,
                toggleVisibility: () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                },
                controller: _confirmPasswordController,
                errorText: _confirmPasswordError,
              ),
              const SizedBox(height: 30),
              _buildCreatePasswordButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hintText,
    required bool isObscure,
    required TextEditingController controller,
    String? errorText,
    VoidCallback? toggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (errorText != null) // Show error message if present
          Padding(
            padding: const EdgeInsets.only(bottom: 4), // Add space below the error message
            child: Text(
              errorText,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        TextFormField(
          obscureText: isObscure,
          controller: controller,
          onChanged: (value) {
            // Validate in real time
            if (hintText == 'Password') {
              _validatePassword();
            } else {
              _validateConfirmPassword();
            }
          },
          autocorrect: false,
          enableSuggestions: false,
          inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
          style: const TextStyle(color: Colors.black), // Text color
          decoration: InputDecoration(
            hintText: hintText, // Placeholder text
            hintStyle: const TextStyle(color: Color(0xFF8A8A8A)), // Hint text color
            contentPadding: const EdgeInsets.symmetric(
              vertical: 20.0, // Keeps the hint text vertically centered
              horizontal: 16.0,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: const BorderSide(color: Color(0xFFC03B7C)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: const BorderSide(color: Color(0xFFC03B7C)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: const BorderSide(color: Color(0xFFC03B7C)),
            ),
            suffixIcon: toggleVisibility != null
                ? IconButton(
              icon: Icon(
                isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: const Color(0xFF8a8a8a), // Eye icon color
              ),
              onPressed: toggleVisibility,
            )
                : null, // Only show the icon for password fields
          ),
        ),
      ],
    );
  }

  Widget _buildCreatePasswordButton() {
    return SizedBox(
      width: double.infinity, // Make the button full width
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Save and submit form data
          } else {
            _validatePassword();
            _validateConfirmPassword();
          }
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
          backgroundColor: const Color(0xFFC03B7C),
          padding: const EdgeInsets.symmetric(vertical: 18),
        ),
        child: const Text(
          'Create New Password',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}