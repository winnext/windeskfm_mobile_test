import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:vm_fm_4/feature/components/buttons/custom_half_buttons.dart';
import 'package:vm_fm_4/feature/components/input_fields/text_fields_input.dart';
import 'package:vm_fm_4/feature/constants/other/colors.dart';
import 'package:vm_fm_4/feature/extensions/context_extension.dart';
import 'package:vm_fm_4/product/screens/home/screens/detail_work_order/provider/work_order_add_documant_sheet_provider.dart';

import '../../../product/screens/home/screens/work_order_list/widgets/custom_loading_indicator.dart';
import '../../constants/other/app_strings.dart';
import '../../constants/other/snackbar_strings.dart';
import '../snackBar/snackbar.dart';

class AddImageModalBottomSheet extends StatelessWidget {
  const AddImageModalBottomSheet({super.key, required this.taskId, required this.taskKey});
  final String taskId;
  final String taskKey;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height * 0.7,
      width: context.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        child: ChangeNotifierProvider(
          create: (context) => WorkOrderAddDocumantSheetProvider(),
          child: Consumer<WorkOrderAddDocumantSheetProvider>(
            builder: (context, value, child) {
              SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                if (value.isImageAdded) {
                  snackBar(context, SnackbarStrings.imageAdded, 'success');
                }
              });
              return value.isLoading
                  ? const Center(child: CustomLoadingIndicator())
                  : Column(
                      children: [
                        Expanded(flex: 60, child: _Image(value)),
                        const SizedBox(height: 10),
                        Expanded(flex: 20, child: _Description(value)),
                        const SizedBox(height: 10),
                        Expanded(flex: 20, child: _ApproveButton(value, taskId, taskKey)),
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }
}

class _ApproveButton extends StatelessWidget {
  const _ApproveButton(this.provider, this.taskId, this.taskKey);

  final WorkOrderAddDocumantSheetProvider provider;
  final String taskId;
  final String taskKey;

  @override
  Widget build(BuildContext context) {
    return CustomHalfButtons(
      leftTitle: const Text(AppStrings.cancel),
      rightTitle: const Text(AppStrings.approve),
      leftOnPressed: () => Navigator.pop(context),
      rightOnPressed: () {
        provider.saveImage(taskId, taskKey);
      },
    );
  }
}

class _Description extends StatelessWidget {
  const _Description(this.provider);

  final WorkOrderAddDocumantSheetProvider provider;
  final String _descriptionHint = 'Açıklama giriniz.';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: TextFieldsInput(
        onChangedFunction: (val) => provider.setDesc,
        labelText: _descriptionHint,
      ),
    );
  }
}

class _Image extends StatelessWidget {
  const _Image(this.provider);

  final WorkOrderAddDocumantSheetProvider provider;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        provider.fileImage != null
            ? Container(
                width: context.width,
                decoration: BoxDecoration(
                  color: APPColors.Main.grey,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: APPColors.Main.grey),
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Image.file(provider.fileImage!, fit: BoxFit.fitWidth),
                ),
              )
            : Container(
                width: context.width,
                decoration: BoxDecoration(
                  color: APPColors.Main.grey,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: APPColors.Main.grey),
                ),
              ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    provider.getImageFromCamera();
                    provider.update();
                  },
                  child: Icon(Icons.camera, color: APPColors.Main.white, size: 26),
                ),
                const SizedBox(width: 10),
                FloatingActionButton(
                  onPressed: () {
                    provider.getImageFromGallery();
                    provider.update();
                  },
                  child: Icon(Icons.image, color: APPColors.Main.white, size: 26),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}