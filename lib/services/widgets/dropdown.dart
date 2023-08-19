import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'extension.dart';
import 'waiting.dart';

class DropDownText extends StatelessWidget {
  final String hint;
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validate;
  final List<String> list;
  final Function(String?)? onChange;

  const DropDownText(
      {Key? key,
      required this.hint,
      required this.label,
      required this.controller,
      this.validate,
      this.onChange,
      required this.list})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      // dropdownDecoratorProps: DropDownDecoratorProps(
      //     dropdownSearchDecoration: InputDecoration(
      //   hintText: hint,
      //   labelText: hint,
      // )),
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          hintText: hint,
          labelText: hint,
          border: OutlineInputBorder(
            gapPadding: 20,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      popupProps: PopupProps.menu(
        title: hint.toLabel(),
        showSearchBox: true,
        searchFieldProps: const TextFieldProps(
          autofocus: true,
        ),
      ),
      onChanged: onChange,
      validator: validate,
      selectedItem: controller.text,
      items: list,
    );
  }
}

class DropDownText2 extends StatelessWidget {
  final String hint;
  final String label;
  final bool isLoading;
  final DropDownModel? controller;
  final bool validate;
  final List<DropDownModel> list;
  final Function(DropDownModel?)? onChange;

  const DropDownText2(
      {Key? key,
      required this.hint,
      required this.label,
      this.controller,
      this.isLoading = false,
      this.validate = false,
      this.onChange,
      required this.list})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const MWaiting()
        : validate
            ? DropdownSearch<DropDownModel>(
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    hintText: hint,
                    labelText: hint,
                    border: OutlineInputBorder(
                      gapPadding: 20,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                popupProps: PopupProps.menu(
                  title: hint.toLabel(),
                  showSearchBox: true,
                  searchFieldProps: const TextFieldProps(
                    autofocus: true,
                  ),
                ),
                selectedItem: controller,
                validator: (DropDownModel? value) =>
                    value == null ? 'Please this field is required' : null,
                onChanged: onChange,
                items: list,
                itemAsString: (DropDownModel u) => u.name,
              )
            : DropdownSearch<DropDownModel>(
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    hintText: hint,
                    labelText: hint,
                    border: OutlineInputBorder(
                      gapPadding: 20,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                popupProps: PopupProps.menu(
                  title: hint.toLabel(),
                  showSearchBox: true,
                  searchFieldProps: const TextFieldProps(
                    autofocus: true,
                  ),
                ),
                selectedItem: controller,
                onChanged: onChange,
                items: list,
                itemAsString: (DropDownModel u) => u.name,
              );
  }
}

class DropDownModel {
  final String id;
  final String name;

  DropDownModel({required this.id, required this.name});
}

class CusModel {
  final String id;
  final String name;
  final int? discount;
  final String? contact;

  CusModel({
    required this.id,
    required this.name,
    this.discount = 1,
    this.contact,
  });
}

class CusDropDown extends StatelessWidget {
  final String hint;
  final String label;
  final bool isLoading;
  final CusModel? controller;
  final String? Function(CusModel?)? validate;
  final List<CusModel> list;
  final Function(CusModel?)? onChange;

  const CusDropDown(
      {Key? key,
      required this.hint,
      required this.label,
      this.controller,
      this.isLoading = false,
      this.validate,
      this.onChange,
      required this.list})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const MWaiting()
        : DropdownSearch<CusModel>(
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                hintText: hint,
                labelText: hint,
                border: OutlineInputBorder(
                  gapPadding: 20,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            popupProps: PopupProps.menu(
              title: hint.toLabel(),
              showSearchBox: true,
              searchFieldProps: const TextFieldProps(
                autofocus: true,
              ),
            ),
            selectedItem: controller,
            validator: validate,
            onChanged: onChange,
            items: list,
            itemAsString: (CusModel u) => u.name,
          );
  }
}
