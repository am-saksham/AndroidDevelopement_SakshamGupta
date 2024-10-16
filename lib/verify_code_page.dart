import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_round/forgot_password_page.dart';

class VerifyCodePage extends StatefulWidget {
  const VerifyCodePage({Key? key}) : super(key: key);

  @override
  State<VerifyCodePage> createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  final TextEditingController _firstDigitController = TextEditingController();
  final TextEditingController _secondDigitController = TextEditingController();
  final TextEditingController _thirdDigitController = TextEditingController();
  final TextEditingController _fourthDigitController = TextEditingController();

  @override
  void dispose() {
    _firstDigitController.dispose();
    _secondDigitController.dispose();
    _thirdDigitController.dispose();
    _fourthDigitController.dispose();
    super.dispose();
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordPage()));
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Verify Code',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const Center(
              child: Text(
                'Enter the verification code we just sent\non your email address',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF8A8A8A),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 48),
            _buildVerificationCodeInput(),
            const SizedBox(height: 14),
            _buildVerifyButton(),
            const SizedBox(height: 10),
            _buildResendCodeText(),
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationCodeInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCodeTextField(controller: _firstDigitController, nextFocusNode: _secondDigitController),
        _buildCodeTextField(controller: _secondDigitController, nextFocusNode: _thirdDigitController, previousController: _firstDigitController),
        _buildCodeTextField(controller: _thirdDigitController, nextFocusNode: _fourthDigitController, previousController: _secondDigitController),
        _buildCodeTextField(controller: _fourthDigitController, previousController: _thirdDigitController),
      ],
    );
  }

  Widget _buildCodeTextField({
    required TextEditingController controller,
    TextEditingController? nextFocusNode,
    TextEditingController? previousController,
  }) {
    return SizedBox(
      width: 80,
      height: 60,
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 24, color: Colors.black),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: const BorderSide(color: Color(0xFFC03B7C)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: const BorderSide(color: Color(0xFFC03B7C)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: const BorderSide(color: Color(0xFFC03B7C)),
          ),
        ),
        onChanged: (value) {
          if (value.length == 1 && nextFocusNode != null) {
            // Move focus to the next field if a digit is entered
            FocusScope.of(context).nextFocus();
          } else if (value.isEmpty && previousController != null) {
            // Move focus to the previous field if current field is empty
            previousController.clear(); // Clear the previous field
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    );
  }

  Widget _buildVerifyButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          // Handle verification logic here
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
          backgroundColor: const Color(0xFFC03B7C),
        ),
        child: const Text(
          'Verify',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
  Widget _buildResendCodeText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Didn't receive code? ",
          style: TextStyle(
            color: Color(0xFF8A8A8A),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        GestureDetector(
          onTap: () {
            // Handle resend code logic here
          },
          child: const Text(
            "Resend",
            style: TextStyle(
              color: Color(0xFFC03B7C),
              fontSize: 16,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              decorationColor: Color(0xFFC03B7C),
            ),
          ),
        ),
      ],
    );
  }
}