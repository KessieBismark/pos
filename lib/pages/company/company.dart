import 'component/controller/controller.dart';
import '../../services/utils/helpers.dart';
import '../../services/widgets/textbox.dart';

import '../../services/widgets/extension.dart';
import '../../services/widgets/keyboard_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../services/constants/color.dart';
import '../../services/widgets/button.dart';

class Company extends GetView<CompanyCon> {
  const Company({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KeyBoardTap(
        focusNode: FocusNode(),
        onKey: (event) {
          final key = event.logicalKey;
          if (event is RawKeyDownEvent) {
            if (controller.keys.contains(key)) return;
            if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
              controller.insert();
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
                key: controller.cformKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                            child: "Register Company"
                                .toLabel(bold: true, fontsize: 20))
                        .vMargin3,
                    const SizedBox(
                      height: 10,
                    ),
                    MEdit(
                      hint: "Company name",
                      controller: controller.cname,
                      validate: Utils.validator,
                    ).padding9,
                    MEdit(
                      hint: "Contact",
                      controller: controller.contact,
                      inputType: TextInputType.number,
                      validate: Utils.validator,
                    ).padding9,
                    MEdit(
                      hint: "Address",
                      controller: controller.address,
                      maxLines: 2,
                      validate: Utils.validator,
                    ).padding9,
                    MEdit(
                      hint: "Gps",
                      controller: controller.gps,
                      validate: Utils.validator,
                    ).padding9,
                    MEdit(
                      hint: "Slogan",
                      controller: controller.slogan,
                      validate: Utils.validator,
                    ).padding9,
                    MEdit(
                      hint: "Website",
                      controller: controller.website,
                      validate: Utils.validator,
                    ).padding9,
                    MEdit(
                      hint: "Email",
                      controller: controller.email,
                      inputType: TextInputType.emailAddress,
                      validate: Utils.validator,
                    ).padding9,
                    MButton(onTap: ()=>null, type: ButtonType.add,),
                    Row(
                      children: [
                        Obx(
                          () => MButton(
                            icon: const Icon(
                              Icons.vpn_key,
                              size: 15,
                            ),
                            color: secondary,
                            isLoading: controller.isSave.value,
                            type: ButtonType.save,
                            onTap: () => controller.insert(),
                          )
                              .animate()
                              .fadeIn(delay: 580.ms, duration: 580.ms)
                              .then() // sets own delay to 800ms (300+500)
                              .slide(
                                  duration: 400.ms) // inherits the 800ms delay
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
                      ],
                    )
                  ],
                ),
              ),
            ).padding9.card.center,
          ),
        ));
  }
}
