import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String _name = '';
  String _email = '';
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void initState() {
    super.initState();

    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_validatePassword);
    _confirmPasswordController.addListener(_validateConfirmPassword);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    if(_emailController.text.isEmpty) {
      setState(() {
        _emailError = 'Please enter your email';
      });
    } else if(!EmailValidator.validate(_emailController.text)) {
      setState(() {
        _emailError = 'Please enter a valid email';
      });
    } else {
      setState(() {
        _emailError = null;
      });
    }
  }

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
      body: SingleChildScrollView( // Make the body scrollable
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 44),
              const Text(
                "Let's Get Started",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Enter Your Details',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF8A8A8A),
                ),
              ),
              const SizedBox(height: 30),
              _buildTextField(
                hintText: 'Name',
                isObscure: false,
                controller: _nameController,
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
              const SizedBox(height: 18),
              _buildTextField(
                hintText: 'E-mail',
                isObscure: false,
                controller: _emailController,
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
              const SizedBox(height: 18),
              _buildTextField(
                hintText: 'Password',
                isObscure: !_isPasswordVisible,
                toggleVisibility: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
                controller: _passwordController,
                onSaved: (value) => _passwordController.text = value ?? '',
                errorText: _passwordError,
                validator: (value) {
                  return null;
                },
                inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
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
                onSaved: (value) => _confirmPasswordController.text = value ?? '',
                errorText: _confirmPasswordError,
                validator: (value) {
                  return null;
                },
                inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
              ),
              const SizedBox(height: 30),
              _buildSignUpButton(),
              const SizedBox(height: 52),
              _buildOrDivider(),
              const SizedBox(height: 36),
              _buildSocialMediaBoxes(),
              const SizedBox(height: 66),
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
    required TextEditingController controller,
    required Function(String?)? onSaved,
    required String? errorText,
    required String? Function(String?)? validator,
    VoidCallback? toggleVisibility,
    List<TextInputFormatter>? inputFormatters,
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
          onSaved: onSaved,
          validator: validator,
          autocorrect: false,
          enableSuggestions: false,
          inputFormatters: inputFormatters,
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