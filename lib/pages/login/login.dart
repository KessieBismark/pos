import 'package:url_launcher/url_launcher.dart';

import '../../services/constants/server.dart';
import '../../services/widgets/extension.dart';
import '../../services/widgets/keyboard_listener.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../services/constants/color.dart';
import '../../services/widgets/button.dart';
import '../../services/widgets/waiting.dart';
import 'controllers/login_controller.dart';

class Login extends GetView<LoginController> {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KeyBoardTap(
        focusNode: FocusNode(),
        onKey: (event) {
          final key = event.logicalKey;
          if (event is RawKeyDownEvent) {
            if (controller.keys.contains(key)) return;
            if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
              controller.login();
            }

            controller.keys.add(key);
          } else {
            controller.keys.remove(key);
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: SizedBox(
              width: context.widthh * 0.3 < 350 ? 350 : context.widthh * 0.3,
              child: Form(
                key: controller.loginFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Image.asset(
                        "assets/icons/logo.png",
                        height: 80,
                      ).animate().fade(duration: 500.ms).scale(delay: 500.ms),
                    ).vMargin3,
                    "LOGIN"
                        .toLabel(bold: true, color: Colors.grey, fontsize: 22)
                        .animate()
                        .fade(duration: 520.ms)
                        .scale(delay: 520.ms)
                        .vMargin3,
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: "Email",
                        prefixIcon: const Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.text,
                      controller: controller.emailController,
                      validator: controller.validator,
                    )
                        .animate()
                        .fade(duration: 540.ms)
                        .scale(delay: 540.ms)
                        .margin9,
                    Obx(
                      () => TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelText: "Password",
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            onPressed: () {
                              controller.showPassword.value =
                                  !controller.showPassword.value;
                            },
                            icon: controller.showPassword.value == true
                                ? const Icon(
                                    FontAwesomeIcons.solidEyeSlash,
                                    size: 20,
                                  )
                                : const Icon(Icons.remove_red_eye),
                          ),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: !controller.showPassword.value,
                        controller: controller.passwordController,
                        validator: controller.validator,
                      ).margin9,
                    ).animate().fade(duration: 560.ms).scale(delay: 560.ms),
                    Row(
                      children: [
                        Obx(
                          () => controller.loading.value
                              ? const CupertinoActivityIndicator().margin9
                              : MButton(
                                  icon: const Icon(
                                    Icons.vpn_key,
                                    size: 15,
                                  ),
                                  color: secondary,
                                  title: "Login",
                                  onTap: controller.login,
                                  //   onTap: () => Get.toNamed('/dash'),
                                )
                                  .animate()
                                  .fadeIn(delay: 580.ms, duration: 580.ms)
                                  .then() // sets own delay to 800ms (300+500)
                                  .slide(
                                      duration:
                                          400.ms) // inherits the 800ms delay
                                  .then(
                                      delay: 200
                                          .ms) // sets delay to 1400ms (800+400+200)
                                  // inherits the 1400ms delay
                                  // Explicitly setting delay overrides the inherited value.
                                  // This move effect will run BEFORE the initial fade:
                                  .move(delay: 0.ms)
                                  .margin9,
                        ),
                        const Spacer(),
                        Obx(() => !controller.isForgot.value
                            ? InkWell(
                                child: "Forgot password?".toAutoLabel(
                                    color: const Color.fromARGB(
                                        182, 75, 184, 187)),
                                onTap: () => controller.forgotPassword(),
                              )
                                .animate()
                                .fadeIn(delay: 580.ms, duration: 580.ms)
                                .then() // sets own delay to 800ms (300+500)
                                .slide(
                                    duration:
                                        400.ms) // inherits the 800ms delay
                                .then(
                                    delay: 200
                                        .ms) // sets delay to 1400ms (800+400+200)
                                // inherits the 1400ms delay
                                // Explicitly setting delay overrides the inherited value.
                                // This move effect will run BEFORE the initial fade:
                                .move(delay: 0.ms)
                            : const MWaiting()),
                      ],
                    ),
                    InkWell(
                      child: "Download setup for windows".toAutoLabel(
                          color: const Color.fromARGB(182, 75, 184, 187)),
                      onTap: () => _launchURL(),
                    )
                        .vMargin9
                        .animate()
                        .fadeIn(delay: 580.ms, duration: 580.ms)
                        .then() // sets own delay to 800ms (300+500)
                        .slide(duration: 400.ms) // inherits the 800ms delay
                        .then(
                            delay: 200.ms) // sets delay to 1400ms (800+400+200)
                        // inherits the 1400ms delay
                        // Explicitly setting delay overrides the inherited value.
                        // This move effect will run BEFORE the initial fade:
                        .move(delay: 0.ms)
                  ],
                ),
              ),
            ).padding9.card.center,
          ),
        ));
  }

  _launchURL() async {
    const url = Api.exeUrl;
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch download link';
    }
  }
}
