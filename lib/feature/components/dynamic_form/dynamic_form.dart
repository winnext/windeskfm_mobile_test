// ignore_for_file: constant_identifier_names

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:vm_fm_4/feature/components/input_fields/text_field_date_picker.dart';
import 'package:vm_fm_4/generated/locale_keys.g.dart';

class FormTypes {
  static const BOOLYES = 'BOOLYES';
  static const DATE = 'DATE';
  static const TEXT = 'TEXT';
  static const NUMBER = 'NUMBER';
}

class DynamicForm {
  Widget formType(
    String inputType,
    bool selectedValue,
    Function setSelectedValue,
    Function selectDate,
    Function setInitialController,
    TextEditingController textEditingController,
    TextEditingController numberEditingController,
  ) {
    switch (inputType) {
      case FormTypes.BOOLYES:
        return _YesNoWidget(selectedValue, setSelectedValue);
      case FormTypes.DATE:
        return _DateWidget(setInitialController, selectDate);
      case FormTypes.TEXT:
        return _TextWidget(textEditingController);
      case FormTypes.NUMBER:
        return _NumberWidget(numberEditingController);
      default:
        return const Text('');
    }
  }
}

class _NumberWidget extends StatelessWidget {
  const _NumberWidget(this.numberEditingController);

  final TextEditingController numberEditingController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: numberEditingController,
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          labelText: LocaleKeys.EnterNumber.tr(),
          labelStyle: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}

class _TextWidget extends StatelessWidget {
  const _TextWidget(this.textEditingController);

  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: textEditingController,
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          labelText: LocaleKeys.EnterDescription.tr(),
          labelStyle: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}

class _DateWidget extends StatelessWidget {
  const _DateWidget(this.setInitialController, this.selectDate);

  final Function setInitialController;
  final Function selectDate;

  @override
  Widget build(BuildContext context) {
    return TextFieldDatePicker(
      label: LocaleKeys.Date.tr(),
      onTap: (value) => selectDate(value),
      initialDate: DateTime(2015),
      initialControllerFunction: setInitialController,
    );
  }
}

class _YesNoWidget extends StatelessWidget {
  const _YesNoWidget(this.selectedValue, this.setSelectedValue);

  final bool selectedValue;
  final Function setSelectedValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(LocaleKeys.Yes.tr(), style: const TextStyle(color: Colors.black)),
          leading: Radio<bool>(
            value: true,
            groupValue: selectedValue,
            onChanged: (bool? value) => setSelectedValue(),
          ),
        ),
        ListTile(
          title: Text(LocaleKeys.No.tr(), style: const TextStyle(color: Colors.black)),
          leading: Radio<bool>(
            value: false,
            groupValue: selectedValue,
            onChanged: (bool? value) => setSelectedValue(),
          ),
        ),
      ],
    );
  }
}
