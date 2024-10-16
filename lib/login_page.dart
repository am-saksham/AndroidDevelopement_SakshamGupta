import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_round/forgot_password_page.dart';
import 'package:task_round/sign_up_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _emailError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    if (_emailController.text.isEmpty) {
      setState(() {
        _emailError = 'Please enter your email';
      });
    } else if (!EmailValidator.validate(_emailController.text)) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height, // Full screen height
          ),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Center(
                  child: Text(
                    'Enter Your Credentials',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF8A8A8A),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextField(
                        hintText: 'E-mail',
                        isObscure: false,
                        controller: _emailController,
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
                        errorText: _passwordError,
                        validator: (value) {
                          return null;
                        },
                        inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
                      ),
                      const SizedBox(height: 14),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordPage()));
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Color(0xFFC03B7C),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                              decorationColor: Color(0xFFC03B7C),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                _buildLoginButton(),
                const SizedBox(height: 52),
                _buildOrDivider(),
                const SizedBox(height: 36),
                _buildSocialMediaBoxes(),
                const SizedBox(height: 36),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildAccountSection(),
                        const SizedBox(height: 40), // Padding from bottom
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hintText,
    required bool isObscure,
    required TextEditingController controller,
    required String? errorText,
    required String? Function(String?)? validator,
    VoidCallback? toggleVisibility,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              errorText,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        TextFormField(
          obscureText: isObscure,
          controller: controller,
          validator: validator,
          inputFormatters: inputFormatters,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Color(0xFF8A8A8A)),
            contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
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
                color: const Color(0xFF8A8A8A),
              ),
              onPressed: toggleVisibility,
            )
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: 366,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Save and submit login form data
          } else {
            _validateEmail();
            _validatePassword();
          }
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
          backgroundColor: const Color(0xFFC03B7C),
        ),
        child: const Text(
          'Login',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.white,
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
          "Don't have an account? ",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            "Sign Up",
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