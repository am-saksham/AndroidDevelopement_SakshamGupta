import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:task_round/get_started_page.dart';
import 'package:task_round/home_page.dart';

import 'package:task_round/login_page.dart';

import 'auth_service.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();
final AuthService _authService = AuthService();
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

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
    
    _nameController.addListener(_validateName);
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

  void _validateName() {
    if (_nameController.text.isEmpty) {
      setState(() {
        _nameError = 'Please enter your name';
      });
    } else if (_nameController.text.length < 2) {
      setState(() {
        _nameError = 'Name must be at least 2 characters';
      });
    } else {
      setState(() {
        _nameError = null;
      });
    }
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const GetStartedScreen()));
          },
          icon: Icon(Icons.arrow_back, color: isDarkMode ? Colors.white : Colors.black),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView( // Make the body scrollable
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Let's Get Started",
                  style: GoogleFonts.inter(
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                      color: isDarkMode ? Colors.white : Colors.black
                  ),
                ),
                Text(
                  'Enter Your Details',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                      color: isDarkMode ? Colors.white54 : Colors.black54,
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
                _buildSignUpButton(isDarkMode),
                const SizedBox(height: 52),
                _buildOrDivider(isDarkMode),
                const SizedBox(height: 36),
                _buildSocialMediaBoxes(isDarkMode),
                const SizedBox(height: 66),
                _buildAccountSection(isDarkMode),
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
    required Function(String?)? onSaved,
    required String? errorText,
    required String? Function(String?)? validator,
    VoidCallback? toggleVisibility,
    List<TextInputFormatter>? inputFormatters,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
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
          style: GoogleFonts.inter(color: isDarkMode ? Colors.white : Colors.black), // Text color
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

  Widget _buildSignUpButton(bool isDarkMode) {
    return SizedBox(
      width: 366,
      height: 60,
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            try {
              UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: _emailController.text.trim(), password: _passwordController.text.trim());
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
            } on FirebaseAuthException catch(e) {
              setState(() {
                if(e.code == 'weak-password') {
                  _passwordError = 'The password provided is too weak.';
                } else if(e.code == 'email-already-in-use') {
                  _emailError = 'The account already exists for that email.';
                } else {
                  _emailError = 'An error occurred. Please try again.';
                }
              });
            }
          } else {
            _validateName();
            _validateEmail();
            _validatePassword();
            _validateConfirmPassword();
          }
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
          backgroundColor: const Color(0xFFC03B7C),
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 128),
        ),
        child: Text(
          'Sign Up',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildOrDivider(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Divider(
            color: isDarkMode ? Colors.white54 : Colors.black54,
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'or',
            style: GoogleFonts.inter(
              color: isDarkMode ? Colors.white54 : Colors.black54,
              fontSize: 18,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: isDarkMode ? Colors.white54 : Colors.black54,
            thickness: 1,
          ),
        )
      ],
    );
  }

  Widget _buildSocialMediaBoxes(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
            onTap: () async {
              UserCredential? userCredential = await _authService.loginWithGoogle();

              if (userCredential != null) {
                // Navigate to HomePage if login is successful
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HomePage()),
                );
              } else {
                // Show error message if login fails or is canceled
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                    Text('Google sign-in failed or was canceled'),
                  ),
                );
              }
            },
            child: _buildSocialMediaBox('assets/google_logo.png')
        ),
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

  Widget _buildAccountSection(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: GoogleFonts.inter(color: isDarkMode ? Colors.white : Colors.black, fontWeight: FontWeight.w500,fontSize: 14),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
          },
          child: Text(
            "Login",
            style: GoogleFonts.inter(
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