// ignore_for_file: prefer_final_fields, avoid_init_to_null

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../../../../../../feature/constants/paths/service_tools.dart';
import '../../../../../../feature/database/shared_manager.dart';
import '../../../../../../feature/enums/shared_enums.dart';
import '../../../../../../feature/enums/task_response_enums.dart';
import '../../../../../../feature/injection.dart';
import '../../../../../../feature/models/work_space/work_space_detail.dart';
import '../../../../../../feature/models/work_space/work_space_efforts.dart';
import '../../../../../../feature/models/work_space/work_space_user_inventory.dart';
import '../../../../../../feature/service/global_services.dart/work_space_service/work_space_service_repository_impl.dart';

class WorkOrderDetailProvider extends ChangeNotifier {
  WorkOrderDetailProvider({required this.detail}) {
    _setUserTaskLabels();
  }

  WorkSpaceDetail detail;

  final WorkSpaceServiceRepositoryImpl workSpaceService =
      Injection.getIt.get<WorkSpaceServiceRepositoryImpl>();

  // for page
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _userClickedEfforts = false;
  bool get userClickedEfforts => _userClickedEfforts;

  bool _userClickedMaterial = false;
  bool get userClickedMaterial => _userClickedMaterial;

  bool _userClickedRequestedMaterial = false;
  bool get userClickedRequestedMaterial => _userClickedRequestedMaterial;

  bool _userClickedRequestedApprovedMaterial = false;
  bool get userClickedRequestedApprovedMaterial =>
      _userClickedRequestedApprovedMaterial;

  bool _userClickedDocumants = false;
  bool get userClickedDocumants => _userClickedDocumants;

  bool _isTaskStateChange = false;
  bool get isTaskStateChange => _isTaskStateChange;

  String _selectedTaskState = '';
  String get selectedTaskState => _selectedTaskState;

  bool _finishTask = false;
  bool get finishTask => _finishTask;

  bool _errorAccurWhileTakingOnMe = false;
  bool get errorAccurWhileTakingOnMe => _errorAccurWhileTakingOnMe;

  bool _takeItOnMeSuccess = false;
  bool get takeItOnMeSuccess => _takeItOnMeSuccess;

  String? _dropdownValue = null;
  String? get dropdownValue => _dropdownValue;

  void setStateToBeginning() {
    _userClickedEfforts = false;
    _userClickedMaterial = false;
    _userClickedRequestedMaterial = false;
    _userClickedRequestedApprovedMaterial = false;
    _userClickedDocumants = false;
  }

  void userClickedEffortsFunction() {
    _userClickedEfforts = true;
  }

  void userClickedMaterialFunction() {
    _userClickedMaterial = true;
  }

  void userClickedRequestedMaterialFunction() {
    _userClickedRequestedMaterial = true;
  }

  void userClickedDocumantsFunction() {
    _userClickedDocumants = true;
  }

  void userClickedApprovedRequestedMaterialFunction() {
    _userClickedRequestedApprovedMaterial = true;
  }

  List<String> _workSpaceUserTaskLabels = [];
  List<String> get workSpaceUserTaskLabels => _workSpaceUserTaskLabels;

  void setDropdown() {
    _dropdownValue = _workSpaceUserTaskLabels[0];
    notifyListeners();

    Future.delayed(const Duration(seconds: 2), () {
      _dropdownValue = null;
    });
  }

  void _getTaskById() async {
    String token = await SharedManager().getString(SharedEnum.userToken);

    final result = await workSpaceService.getWorkSpaceWithSearch(
        detail.task?.id.toString() ?? '', token);

    result.fold(
      (l) => {
        detail = l,
      },
      (r) => {},
    );

    notifyListeners();

    Future.delayed(const Duration(seconds: 2), () {
      _takeItOnMeSuccess = false;
      _errorAccurWhileTakingOnMe = false;
    });
  }

  void takeItOnMe() async {
    _isLoading = true;
    notifyListeners();

    String userToken = await SharedManager().getString(SharedEnum.userToken);

    final response = await workSpaceService.takeItOnMe(
        detail.task?.id.toString() ?? '',
        detail.state?.id.toString() ?? '',
        userToken);

    response.fold(
      (l) => {
        _takeItOnMeSuccess = true,
      },
      (r) => {
        _errorAccurWhileTakingOnMe = true,
      },
    );

    _isLoading = false;
    _getTaskById();
  }

  void _setUserTaskLabels() {
    _workSpaceUserTaskLabels.add(detail.state?.name.toString() ?? '');

    for (var i = 0; i < (detail.state?.nextStates?.length ?? 0); i++) {
      _workSpaceUserTaskLabels.add(detail.state?.nextStates?[i].name ?? '');
    }
  }

  void changeState(String value) async {
    _isLoading = true;
    notifyListeners();

    String userToken = await SharedManager().getString(SharedEnum.userToken);

    final response = await workSpaceService.changeWorkSpaceState(
      detail.task?.id.toString() ?? '',
      detail.state?.nextStates?[0].id.toString() ?? '',
      userToken,
    );

    response.fold(
      (l) => {
        if (l == TaskResponseEnums.my)
          {
            _isTaskStateChange = true,
            _selectedTaskState = 'kendi grubuma gönderilmiştir',
          }
        else if (l == TaskResponseEnums.our)
          {
            _isTaskStateChange = true,
            _selectedTaskState = 'grubumdakilere gönderilmiştir',
          }
        else if (l == TaskResponseEnums.pendiks)
          {
            _isTaskStateChange = true,
            _selectedTaskState = 'onay bekleyenlere gönderilmiştir'
          }
        else if (l == TaskResponseEnums.end)
          {
            _isTaskStateChange = true,
            _finishTask = true,
            _selectedTaskState = 'işlem tamamlanmıştır',
          }
        else if (l == TaskResponseEnums.error)
          {
            _isTaskStateChange = false,
            _selectedTaskState = 'hata oluştu',
          }
        else
          {
            _isTaskStateChange = false,
            _selectedTaskState = 'hata oluştu',
          },
      },
      (r) => {
        _isTaskStateChange = false,
      },
    );

    _isLoading = false;
    notifyListeners();

    Future.delayed(const Duration(seconds: 3), () {
      _isTaskStateChange = false;
    });
  }

  // for efforts
  // work space effort list
  List<WorkSpaceEfforts>? _woEffortList;
  List<WorkSpaceEfforts>? get woEffortList => _woEffortList;

  bool _effortAdded = false;
  bool get effortAdded => _effortAdded;

  String _startEffortDate = '';
  String get startEffortDate => _startEffortDate;

  String _endEffortDate = '';
  String get endEffortDate => _endEffortDate;

  String _effortDuration = '';
  String get effortDuration => _effortDuration;

  String _effortType = '';
  String get effortType => _effortType;

  String _effortDescription = '';
  String get effortDescription => _effortDescription;

  void setEffortDescription(String value) {
    _effortDescription = value;
  }

  void setEffortType(String value) {
    _effortType = value;
  }

  void setEffortDuration(String value) {
    _effortDuration = value;
  }

  void setStartEffortDate(String value) {
    _startEffortDate = value;
  }

  void setEndEffortDate(String value) {
    _endEffortDate = value;
  }

  void addEffort() async {
    // service add effort
    String userToken = await SharedManager().getString(SharedEnum.userToken);

    _isLoading = true;
    notifyListeners();

    final result = await workSpaceService.addWorkOrderEffort(
      detail.task?.id.toString() ?? '',
      userToken,
      _effortDescription,
      _effortDuration,
      _startEffortDate,
      _endEffortDate,
      _effortType,
    );

    result.fold(
      (l) => {
        _effortAdded = true,
      },
      (r) => {
        _effortAdded = false,
      },
    );

    _isLoading = false;
    notifyListeners();

    Future.delayed(const Duration(seconds: 2), () {
      _effortAdded = false;
    });
  }

  // for spareparts
  WorkSpaceUserInventory _userInventoryList = const WorkSpaceUserInventory();
  WorkSpaceUserInventory get userInventoryList => _userInventoryList;

  List<String> workSpaceUserInventoryLabelList = [];

  void getUserInventory() async {
    _isLoading = true;
    notifyListeners();

    String userToken = await SharedManager().getString(SharedEnum.userToken);

    final result = await workSpaceService.getWorkSpaceUserInventory(userToken);

    result.fold(
      (l) => {
        _userInventoryList = l,
        for (var i = 0; i < (_userInventoryList.materials?.length ?? 0); i++)
          {
            workSpaceUserInventoryLabelList
                .add(_userInventoryList.materials?[i].properties?.name ?? ''),
          },
      },
      (r) => {},
    );

    _isLoading = false;
    notifyListeners();
  }

  void scanBarcodeAndQr() async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'İptal', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (barcodeScanRes != '-1') {
      print('BARCODE SCANE RES : ' + barcodeScanRes);
      final String token =
          await SharedManager().getString(SharedEnum.userToken);
      print(token);
      String url = '${ServiceTools.url.workorder_url}/task';
      BaseOptions options = BaseOptions(
          baseUrl: url,
          receiveDataWhenStatusError: true,
          connectTimeout: const Duration(seconds: 5), // 60 seconds
          receiveTimeout: const Duration(seconds: 5) // 60 seconds
          );
      Dio dio = Dio(options);

      final response = await dio.patch(
        url,
        data: [
          {
            "label": ["Task"],
            "identifier": '1087',
            "variableName": "requestedComponents",
            "value": [7574]
          }
        ],
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {'authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('ok');
      } else {
        print('hata');
      }
    }
  }
}
