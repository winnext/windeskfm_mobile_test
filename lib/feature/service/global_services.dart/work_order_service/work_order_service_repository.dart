import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:vm_fm_4/feature/injection.dart';
import 'package:vm_fm_4/feature/log/log_manager.dart';
import 'package:vm_fm_4/feature/models/work_order_models/work_order_attachments_model.dart';
import 'package:vm_fm_4/feature/models/work_order_models/work_order_date_action_model.dart';
import 'package:vm_fm_4/feature/models/work_order_models/work_order_details_model.dart';
import 'package:vm_fm_4/feature/models/work_order_models/work_order_loads_model.dart';
import 'package:vm_fm_4/feature/models/work_order_models/work_order_resources_model.dart';
import 'package:vm_fm_4/feature/models/work_order_models/work_order_shiftings_model.dart';
import 'package:vm_fm_4/feature/models/work_order_models/work_order_spareparts_model.dart';
import 'package:vm_fm_4/feature/service/service_manager.dart';

import '../../../exceptions/custom_service_exceptions.dart';

abstract class WorkOrderServiceRepository {
  final Dio dio = Injection.getIt.get<ServiceManager>().dio;
  final logger = Injection.getIt.get<LogManager>().logger;

  // GET WORK ORDER METHODS
  Future<Either<List<WorkOrderLoadsModel>, CustomServiceException>> getWorkOrderLoads(String workOrderCode);

  Future<Either<List<WorkOrderAttachmentsModel>, CustomServiceException>> getWorkOrderAttachments(String workOrderCode);

  Future<Either<List<WorkOrderResourcesModel>, CustomServiceException>> getWorkOrderResources(String workOrderCode);

  Future<Either<List<WorkOrderShiftingsModel>, CustomServiceException>> getWorkOrderShiftings();

  Future<Either<WorkOrderDetailsModel, CustomServiceException>> getWorkOrderDetails(String workOrderCode);

  Future<Either<List<WorkOrderSparepartsModel>, CustomServiceException>> getWorkOrderSpareparts(String workOrderCode);

  Future<Either<WorkOrderDateActionModel, CustomServiceException>> getWorkOrderDateAction(String workOrderCode, String actionType);

  // ADD WORK ORDER METHODS

  // DELETE WORK ORDER METHODS
}
