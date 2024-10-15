import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String _name = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView( // Make the body scrollable
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 44),
              Text(
                "Let's Get Started",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Enter Your Details',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF8A8A8A),
                ),
              ),
              SizedBox(height: 30),
              _buildTextField(
                hintText: 'Name',
                isObscure: false,
                onSaved: (value) => _name = value ?? '',
                errorText: _nameError,
                validator: (value) {
                  if (value!.isEmpty) {
                    setState(() {
                      _nameError = 'Please enter your name';
                    });
                    return '';
                  } else {
                    setState(() {
                      _nameError = null;
                    });
                  }
                  return null;
                },
              ),
              SizedBox(height: 18),
              _buildTextField(
                hintText: 'E-mail',
                isObscure: false,
                onSaved: (value) => _email = value ?? '',
                errorText: _emailError,
                validator: (value) {
                  if (value!.isEmpty) {
                    setState(() {
                      _emailError = 'Please enter your email';
                    });
                    return '';
                  } else if (!EmailValidator.validate(value)) {
                    setState(() {
                      _emailError = 'Please enter a valid email';
                    });
                    return '';
                  } else {
                    setState(() {
                      _emailError = null;
                    });
                  }
                  return null;
                },
              ),
              SizedBox(height: 18),
              _buildTextField(
                hintText: 'Password',
                isObscure: !_isPasswordVisible,
                toggleVisibility: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
                onSaved: (value) => _password = value ?? '',
                errorText: _passwordError,
                validator: (value) {
                  if (value!.isEmpty) {
                    setState(() {
                      _passwordError = 'Please enter your password';
                    });
                    return '';
                  } else if (value.length < 6) {
                    setState(() {
                      _passwordError = 'Password must be at least 6 characters';
                    });
                    return '';
                  } else {
                    setState(() {
                      _passwordError = null;
                    });
                  }
                  return null;
                },
              ),
              SizedBox(height: 18),
              _buildTextField(
                hintText: 'Confirm Password',
                isObscure: !_isConfirmPasswordVisible,
                toggleVisibility: () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                },
                onSaved: (value) => _confirmPassword = value ?? '',
                errorText: _confirmPasswordError,
                validator: (value) {
                  if (value!.isEmpty) {
                    setState(() {
                      _confirmPasswordError = 'Please confirm your password';
                    });
                    return '';
                  } else if (value != _password) {
                    setState(() {
                      _confirmPasswordError = 'Password does not match';
                    });
                    return '';
                  } else {
                    setState(() {
                      _confirmPasswordError = null;
                    });
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              _buildSignUpButton(),
              SizedBox(height: 52),
              _buildOrDivider(),
              SizedBox(height: 36),
              _buildSocialMediaBoxes(),
              SizedBox(height: 66),
              _buildAccountSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hintText,
    required bool isObscure,
    required Function(String?)? onSaved,
    required String? errorText,
    required String? Function(String?)? validator,
    VoidCallback? toggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (errorText != null) // Show error message if present
          Text(
            errorText,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        const SizedBox(height: 4), // Space between error text and text field
        Container(
          width: 366,
          height: 60,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFC03B7C)), // Border color
            borderRadius: BorderRadius.circular(17), // Border radius
          ),
          child: TextFormField(
            obscureText: isObscure,
            onSaved: onSaved,
            validator: validator,
            style: const TextStyle(color: Colors.black), // Text color
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText, // Placeholder text
              hintStyle: const TextStyle(color: Color(0xFF8A8A8A)), // Hint text color
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20), // Center hint text vertically
              suffixIcon: toggleVisibility != null
                  ? IconButton(
                icon: Icon(
                  isObscure ? Icons.visibility_off : Icons.visibility,
                  color: const Color(0xFFC03B7C), // Eye icon color
                ),
                onPressed: toggleVisibility,
              )
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpButton() {
    return Container(
      width: 366,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFFC03B7C),
        borderRadius: BorderRadius.circular(17),
      ),
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
        ),
        child: const Text(
          'Sign Up',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildOrDivider() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Divider(
            color: Color(0xFF8A8A8A),
            thickness: 1,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'or',
            style: TextStyle(
              color: Color(0xFF8A8A8A),
              fontSize: 18,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Color(0xFF8A8A8A),
            thickness: 1,
          ),
        )
      ],
    );
  }

  Widget _buildSocialMediaBoxes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialMediaBox('assets/google_logo.png'),
        const SizedBox(width: 15),
        _buildSocialMediaBox('assets/facebook_logo.png'),
        const SizedBox(width: 15),
        _buildSocialMediaBox('assets/x_logo.png'),
        const SizedBox(width: 15),
      ],
    );
  }

  Widget _buildSocialMediaBox(String assetPath) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFC03B7C)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Center(
            child: Image.asset(assetPath, width: 30, height: 30, fit: BoxFit.cover)),
      ),
    );
  }

  Widget _buildAccountSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Already have an account? ",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500,fontSize: 14),
        ),
        GestureDetector(
          onTap: () {
            // Navigate to the Login Page
          },
          child: const Text(
            "Login",
            style: TextStyle(
              color: Color(0xFFC03B7C),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}