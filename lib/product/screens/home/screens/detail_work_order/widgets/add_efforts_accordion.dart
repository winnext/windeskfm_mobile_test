// ignore_for_file: deprecated_member_use

import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:vm_fm_4/feature/components/model_bottom_sheet/add_efforts_modal_bottom_sheet.dart';
import 'package:vm_fm_4/feature/components/show_modal_bottom_folder/show_modal_bottom_sheet.dart';
import 'package:vm_fm_4/feature/constants/other/app_strings.dart';
import 'package:vm_fm_4/product/screens/home/screens/detail_work_order/provider/work_order_detail_provider.dart';
import 'package:vm_fm_4/product/screens/home/screens/detail_work_order/widgets/tables/data_table_accordion_efforts.dart';

import '../../../../../../feature/constants/other/app_icons.dart';
import '../../../../../../feature/constants/other/colors.dart';
import '../provider/work_order_detail_service_provider.dart';

class AddEffortsAccordion extends StatelessWidget {
  const AddEffortsAccordion({super.key, required this.provider});

  final WorkOrderDetailProvider provider;

  @override
  Widget build(BuildContext context) {
    return Accordion(
      headerBackgroundColorOpened: APPColors.Main.black,
      maxOpenSections: 1,
      children: [
        AccordionSection(
          isOpen: false,
          headerBackgroundColor: APPColors.Accent.black,
          contentBackgroundColor: APPColors.Accent.black,
          contentBorderWidth: 0,
          contentHorizontalPadding: 0,
          contentVerticalPadding: 0,
          contentBorderColor: APPColors.Main.white,
          rightIcon: const Icon(AppIcons.arrowDown, size: 0),
          flipRightIconIfOpen: false,
          leftIcon: Icon(AppIcons.add, color: APPColors.Main.white),
          header: Text(AppStrings.addEffort, style: TextStyle(color: APPColors.Main.white)),
          sectionOpeningHapticFeedback: SectionHapticFeedback.none,
          scrollIntoViewOfItems: ScrollIntoViewOfItems.slow,
          sectionClosingHapticFeedback: SectionHapticFeedback.none,
          onOpenSection: () {
            ShowModalBottomSheet().show(
              context,
              AddEffortsModalBottomSheet(
                selectedStartDate: provider.setStartEffortDate,
                selectedEndtDate: provider.setEndEffortDate,
                selectedEffortDuration: provider.setEffortDuration,
                selectedEffortType: provider.setEffortType,
                selectedDescription: provider.setEffortDescription,
                addEffortFunction: provider.addEffort,
              ),
            );
          },
          onCloseSection: () {},
          content: const SizedBox(height: 0),
        ),
        AccordionSection(
          headerBackgroundColor: APPColors.Accent.black,
          leftIcon: Icon(AppIcons.compareRounded, color: APPColors.Main.white),
          header: Text(AppStrings.addedEfforts, style: TextStyle(color: APPColors.Main.white)),
          onOpenSection: () {
            Provider.of<WorkOrderDetailServiceProvider>(context, listen: false).update();
            provider.userClickedEffortsFunction();
          },
          content: Consumer<WorkOrderDetailServiceProvider>(
            builder: (context, value, child) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                provider.userClickedEfforts
                    ? value.isEffortListFetched
                        ? null
                        : value.fetchEfforts(
                            provider.detail.task?.id.toString() ?? '',
                            provider.detail.state?.nextStates?.first.id.toString() ?? '',
                          )
                    : null;
              });

              return value.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : DataTableAccordionEfforts(
                      delete: () {},
                      data: value.woEffortList ?? [],
                    );
            },
          ),
        )
      ],
    );
  }
}
