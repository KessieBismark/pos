import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../services/constants/color.dart';
import '../../services/widgets/button.dart';
import '../../services/widgets/extension.dart';
import 'controllers/login_controller.dart';

class SignIn extends Intent {}

class Reset extends StatelessWidget {
  const Reset({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginController controller = Get.put(LoginController());

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: context.widthh * 0.3 < 350 ? 350 : context.widthh * 0.3,
          child: Form(
            key: controller.verifyFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: "Change Password"
                      .toLabel(bold: true, color: Colors.grey, fontsize: 22)
                      .vMargin9,
                ).vMargin3,
                "A reset code has been sent to your email and the phone number you used to register. Please enter the code to change your password."
                    .toAutoLabel(color: dark)
                    .margin9,
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: "Reset Code",
                    prefixIcon: const Icon(Icons.person),
                  ),
                  keyboardType: TextInputType.text,
                  controller: controller.reset,
                  validator: controller.validator,
                ).margin9,
                Obx(
                  () => Shortcuts(
                    shortcuts: {
                      LogicalKeySet(LogicalKeyboardKey.enter): SignIn()
                    },
                    child: Actions(
                      actions: {
                        SignIn: CallbackAction<SignIn>(
                            onInvoke: (intent) => controller.login())
                      },
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelText: "New Password",
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
                    ),
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: "Confirm Password",
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
                  controller: controller.cpassword,
                  validator: controller.validator,
                ).margin9,
                Row(
                  children: [
                    Obx(() => controller.loading.value
                        ? const CupertinoActivityIndicator().margin9
                        : Shortcuts(
                            shortcuts: {
                              LogicalKeySet(LogicalKeyboardKey.enter): SignIn()
                            },
                            child: Actions(
                              actions: {
                                SignIn: CallbackAction<SignIn>(
                                    onInvoke: (intent) =>
                                        controller.changePassword())
                              },
                              child: MButton(
                                icon: const Icon(
                                  Icons.vpn_key,
                                  size: 15,
                                ),
                                color: secondary,
                                title: "Save",
                                onTap: controller.changePassword,
                              ).margin9,
                            ),
                          ))
                  ],
                )
              ],
            ),
          ),
        ).padding9.card.center,
      ),
    );
  }
}
