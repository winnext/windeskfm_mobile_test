// ignore_for_file: prefer_final_fields, avoid_init_to_null, empty_catches

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:vm_fm_4/feature/components/snackBar/snackbar.dart';
import 'package:vm_fm_4/feature/models/work_space/work_space_current_state.dart';
import 'package:vm_fm_4/generated/locale_keys.g.dart';

import '../../../../../../core/constants/paths/service_tools.dart';
import '../../../../../../core/database/shared_manager.dart';
import '../../../../../../core/enums/shared_enums.dart';
import '../../../../../../core/enums/task_response_enums.dart';
import '../../../../../../feature/injection.dart';
import '../../../../../../feature/models/home_page_models/asset_list_model.dart';
import '../../../../../../feature/models/work_space/work_space_detail.dart';
import '../../../../../../feature/models/work_space/work_space_efforts.dart';
import '../../../../../../feature/models/work_space/work_space_requested_materials_inventory.dart';
import '../../../../../../feature/models/work_space/work_space_user_inventory.dart';
import '../../../../../../feature/service/global_services.dart/work_space_service/work_space_service_repository_impl.dart';

class WorkOrderDetailProvider extends ChangeNotifier {
  WorkOrderDetailProvider({required this.detail}) {
    _setUserTaskLabels();
  }

  WorkSpaceDetail detail;

  final WorkSpaceServiceRepositoryImpl workSpaceService = Injection.getIt.get<WorkSpaceServiceRepositoryImpl>();

  DateModel dateModel = DateModel();

  // for page
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _initLoading = false;
  bool get initLoading => _initLoading;

  bool _initState = true;
  bool get initState => _initState;

  bool _isGroupExist = false;
  bool get isGroupExist => _isGroupExist;

  bool _userClickedEfforts = false;
  bool get userClickedEfforts => _userClickedEfforts;

  bool _userClickedMaterial = false;
  bool get userClickedMaterial => _userClickedMaterial;

  bool _userClickedRequestedMaterial = false;
  bool get userClickedRequestedMaterial => _userClickedRequestedMaterial;

  bool _userClickedRequestedApprovedMaterial = false;
  bool get userClickedRequestedApprovedMaterial => _userClickedRequestedApprovedMaterial;

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

  String? _groupId = '';
  String? get groupId => _groupId;

  List? _taskHistoryData = [];
  List? get taskHistoryData => _taskHistoryData;
  bool _isTaskHistoryLoading = false;
  bool get isTaskHistoryLoading => _isTaskHistoryLoading;

  void setGroupIdDefault() {
    _groupId = '';
  }

  void setStateToBeginning() {
    _userClickedEfforts = false;
    _userClickedMaterial = false;
    _userClickedRequestedMaterial = false;
    _userClickedRequestedApprovedMaterial = false;
    _userClickedDocumants = false;
  }

  void userClickedEffortsFunction() => _userClickedEfforts = true;
  void userClickedMaterialFunction() => _userClickedMaterial = true;
  void userClickedRequestedMaterialFunction() => _userClickedRequestedMaterial = true;
  void userClickedDocumantsFunction() => _userClickedDocumants = true;
  void userClickedApprovedRequestedMaterialFunction() => _userClickedRequestedApprovedMaterial = true;

  List<String> _workSpaceUserTaskLabels = [];
  List<String> get workSpaceUserTaskLabels => _workSpaceUserTaskLabels;

  List<String> _stateGroupList = [];
  List<String> get stateGroupList => _stateGroupList;

  CurrentState? _workSpaceStateGroups = const CurrentState();
  CurrentState? get workSpaceStateGroups => _workSpaceStateGroups;

  Future<void> init(String taskId) async {
    if (initState) {
      _initState = false;
      _initLoading = true;
      notifyListeners();

      await getTaskHistory(taskId);

      _initLoading = false;
      notifyListeners();
    }
  }

  void setDropdown() {
    _dropdownValue = _workSpaceUserTaskLabels[0];
    notifyListeners();

    Future.delayed(const Duration(seconds: 2), () {
      _dropdownValue = null;
    });
  }

  void _getTaskById() async {
    String token = await SharedManager().getString(SharedEnum.userToken);

    final result = await workSpaceService.getWorkSpaceWithSearch(detail.task?.id.toString() ?? '', token);

    result.fold(
      (l) => {
        detail = l,
      },
      (r) => {},
    );

    _setUserTaskLabels();
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

    final response = await workSpaceService.takeItOnMe(detail.task?.id.toString() ?? '', detail.state?.id.toString() ?? '', userToken);

    response.fold(
      (l) => {
        _takeItOnMeSuccess = true,
        _getTaskById(),
      },
      (r) => {
        _errorAccurWhileTakingOnMe = true,
      },
    );

    _isLoading = false;
  }

  void getStateUserGroups() async {
    _isLoading = true;
    notifyListeners();

    String userToken = await SharedManager().getString(SharedEnum.userToken);

    final response =
        await workSpaceService.getWorkSpaceStateGroups(detail.task?.id.toString() ?? '', detail.workspace?.id.toString() ?? '', userToken);

    response.fold(
      (l) => {_workSpaceStateGroups = l},
      (r) => {
        _errorAccurWhileTakingOnMe = true,
      },
    );
    notifyListeners();

    _isLoading = false;
  }

  void _setUserTaskLabels() async {
    _isLoading = true;
    notifyListeners();
    _workSpaceUserTaskLabels.clear();

    String userToken = await SharedManager().getString(SharedEnum.userToken);

    final response =
        await workSpaceService.getWorkSpaceStateGroups(detail.task?.id.toString() ?? '', detail.workspace?.id.toString() ?? '', userToken);

    response.fold(
      (l) => {
        _workSpaceStateGroups = l,
        for (var i = 0; i < (_workSpaceStateGroups?.nextStates?.length ?? 0); i++)
          {_workSpaceUserTaskLabels.add(_workSpaceStateGroups?.nextStates?[i].name ?? '')}
      },
      (r) => {
        _errorAccurWhileTakingOnMe = true,
      },
    );
    _isLoading = false;
    notifyListeners();
  }

  void stateGroupExist(String value) {
    _isGroupExist = false;
    _stateGroupList.clear();
    for (var i = 0; i < (_workSpaceStateGroups?.nextStates?.length ?? 0); i++) {
      if (_workSpaceStateGroups?.nextStates?[i].name == value) {
        _isGroupExist = _workSpaceStateGroups?.nextStates?[i].userGroups?.isNotEmpty ?? false;
        if (_isGroupExist) {
          for (var b = 0; b < (_workSpaceStateGroups?.nextStates?[i].userGroups?.length ?? 0); b++) {
            _stateGroupList.add(_workSpaceStateGroups?.nextStates?[i].userGroups?[b].name ?? '');
          }
        }
      }
    }
    notifyListeners();
  }

  void setGroupId(String value) {
    for (var i = 0; i < (_workSpaceStateGroups?.nextStates?.length ?? 0); i++) {
      if (_workSpaceStateGroups?.nextStates?[i].userGroups?.isNotEmpty ?? false) {
        for (var b = 0; b < (_workSpaceStateGroups?.nextStates?[i].userGroups?.length ?? 0); b++) {
          if (_workSpaceStateGroups?.nextStates?[i].userGroups?[b].name == value) {
            _groupId = _workSpaceStateGroups?.nextStates?[i].userGroups?[b].id.toString() ?? '';
          }
        }
      }
    }
    notifyListeners();
  }

  void changeState(String value) async {
    _isLoading = true;
    late String? id;
    notifyListeners();

    for (var i = 0; i < (_workSpaceStateGroups?.nextStates?.length ?? 0); i++) {
      if (_workSpaceStateGroups?.nextStates?[i].name == value) {
        id = _workSpaceStateGroups?.nextStates?[i].id.toString();
      }
    }

    String userToken = await SharedManager().getString(SharedEnum.userToken);

    final response = await workSpaceService.changeWorkSpaceState(detail.task?.id.toString() ?? '', id ?? '', userToken, groupId);

    response.fold(
      (l) => {
        if (l == TaskResponseEnums.my)
          {
            _isTaskStateChange = true,
            _selectedTaskState = LocaleKeys.StateGoToMe.tr(),
          }
        else if (l == TaskResponseEnums.our)
          {
            _isTaskStateChange = true,
            _selectedTaskState = LocaleKeys.StateGoToGroup.tr(),
          }
        else if (l == TaskResponseEnums.pending)
          {
            _isTaskStateChange = true,
            _selectedTaskState = LocaleKeys.StateGoToPending.tr(),
          }
        else if (l == TaskResponseEnums.finished)
          {
            _isTaskStateChange = true,
            _finishTask = true,
            _selectedTaskState = LocaleKeys.StateFinished.tr(),
          }
        else if (l == TaskResponseEnums.end)
          {
            _isTaskStateChange = true,
            _finishTask = true,
            _selectedTaskState = LocaleKeys.StateFinished.tr(),
          }
        else if (l == TaskResponseEnums.error)
          {
            _isTaskStateChange = false,
            _selectedTaskState = LocaleKeys.StateError.tr(),
          }
        else
          {
            _isTaskStateChange = false,
            _selectedTaskState = LocaleKeys.StateError.tr(),
          },
      },
      (r) => {
        _isTaskStateChange = false,
        _selectedTaskState = LocaleKeys.StateError.tr(),
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

  bool _isMaterialAdded = false;
  bool get isMaterialAdded => _isMaterialAdded;

  bool _isMaterialRequested = false;
  bool get isMaterialRequested => _isMaterialRequested;

  bool _isDocumantAdded = false;
  bool get isDocumantAdded => _isDocumantAdded;

  bool _isImageAdded = false;
  bool get isImageAdded => _isImageAdded;

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

  void setEffortDescription(String value) => _effortDescription = value;
  void setEffortType(String value) => _effortType = value;
  void setEffortDuration(String value) => _effortDuration = value;

  void setStartEffortDate(String value) {
    _startEffortDate = value;
  }

  void setEndEffortDate(String value) => _endEffortDate = value;

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
            workSpaceUserInventoryLabelList.add(_userInventoryList.materials?[i].properties?.name ?? ''),
          },
      },
      (r) => {},
    );

    _isLoading = false;
    notifyListeners();
  }

  // [TODO SERVIS KODU SERVIS KATMANINA TASICANAK -- OZKAN AYDIN TARAFINDAN YAPILACAK]
  void scanBarcodeAndQr() async {
    String barcodeScanRes;
    AssetListModel assetListModel;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'İptal', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (barcodeScanRes != '-1') {
      // final startIndex = barcodeScanRes.indexOf(':');
      // final endIndex = barcodeScanRes.indexOf(',');
      // final finalBarcode = barcodeScanRes.substring(startIndex + 1, endIndex);
      // print('id : ' + finalBarcode);
      String taskId = detail.task!.id.toString();
      int? qrId;
      final String token = await SharedManager().getString(SharedEnum.userToken);

      String url =
          '${ServiceTools.url.asset_url}/component/searchByColumn/?page=1&limit=10&orderBy=ASC&orderByColumn=&searchColumn=tagNumber&searchString=$barcodeScanRes&searchType=CONTAINS';
      try {
        BaseOptions options = BaseOptions(
            baseUrl: url,
            receiveDataWhenStatusError: true,
            connectTimeout: const Duration(seconds: 10), // 60 seconds
            receiveTimeout: const Duration(seconds: 10) // 60 seconds
            );
        Dio dio = Dio(options);
        final response = await dio.get(
          url,
          options: Options(
            headers: {'authorization': 'Bearer $token'},
          ),
        );

        final data = response.data['children'][0];
        assetListModel = AssetListModel.fromJson(data);

        qrId = assetListModel.id;
      } catch (e) {}

      const String url2 = 'https://workorder-server.ifm.gov.tr/task';
      BaseOptions options2 = BaseOptions(
          baseUrl: url2,
          receiveDataWhenStatusError: true,
          connectTimeout: const Duration(seconds: 10), // 60 seconds
          receiveTimeout: const Duration(seconds: 10) // 60 seconds
          );
      Dio dio = Dio(options2);
      final response = await dio.patch(
        url2,
        data: [
          {
            "label": ["Task"],
            "identifier": taskId,
            "variableName": "requestedComponents",
            "value": [qrId]
          }
        ],
        options: Options(
          headers: {'authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
      } else {}
    }
  }

  void getDetail() async {
    final String token = await SharedManager().getString(SharedEnum.userToken);
    if (token.isNotEmpty) {
      final result = await workSpaceService.getWorkSpaceByTaskId(detail.task!.id.toString(), token);

      result.fold((l) {
        detail = l;
        notifyListeners();
      }, (r) {});
    }
    _isLoading = false;

    notifyListeners();
  }

  // TODO model olarak yazilmasi lazim
  Future<void> getTaskHistory(taskId) async {
    _isTaskHistoryLoading = false;
    final String token = await SharedManager().getString(SharedEnum.userToken);
    if (token.isNotEmpty) {
      final result = await workSpaceService.getTaskHistoryApi(detail.task!.id.toString(), token);

      result.fold((l) {
        var dataList = [];
        for (var i = 0; i < l.length; i++) {
          if (i == 0) {
            dateModel = DateModel(
              startDate: l[i]['state']['userStartDate'],
              endDate: l[i]['task']['dueDate'],
              updateDate: l[i]['task']['updatedAt'],
            );
          }
          dataList.add([l[i]['state']['name'], l[i]['state']['stateDate'], l[i]['state']['stateUser']]);
        }
        _isTaskHistoryLoading = true;
        _taskHistoryData = dataList;
        notifyListeners();
      }, (r) {});
    }
    _isLoading = false;

    notifyListeners();
  }

  // ADD FONKSIYONLARINI BURAYA EKLE

  void addEffort(BuildContext context) async {
    // service add effort
    if (_startEffortDate.isEmpty || _endEffortDate.isEmpty || _effortDuration.isEmpty || _effortType.isEmpty) {
      snackBar(context, LocaleKeys.EmptyEffortFields.tr(), 'error');
      return;
    }
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

  // notes
  bool userClickedNotes = false;
  void userClickedNotesFunction() => userClickedNotes = true;
  bool isNotesFetched = false;

  // void addSparepart(BuildContext context, String wantedMaterialAmount, String choosenMaterial, String taskId) async {
  //   if (wantedMaterialAmount == '0' || wantedMaterialAmount.isEmpty || choosenMaterial.isEmpty) {
  //     snackBar(context, LocaleKeys.EmptyMaterialWantedAmount, 'error');
  //     return;
  //   }

  //   _isLoading = true;
  //   notifyListeners();

  //   String userToken = await SharedManager().getString(SharedEnum.userToken);
  //   print('AAAAAAAAAAAAAAAAAAA');
  //   print(choosenMaterial);
  //   print(_userInventoryList.materials);
  //   print(workSpaceUserInventoryLabelList);
  //   print('BBBBBBBBBBBBBBBBBBBBBBBBBBBB');
  //   String sparePartId = '';
  //   for (var i = 0; i < (_userInventoryList.materials?.length ?? 0); i++) {
  //     if (_userInventoryList.materials?[i].properties?.name == choosenMaterial) {
  //       sparePartId = _userInventoryList.materials?[i].properties?.referenceId.toString() ?? '';
  //       break;
  //     }
  //   }

  //   print(sparePartId);

  //   final result = await workSpaceService.addWorkSpaceSpareparts(taskId, userToken, sparePartId, wantedMaterialAmount);

  //   result.fold(
  //     (l) => {
  //       _isMaterialAdded = true,
  //     },
  //     (r) => {
  //       _isMaterialAdded = false,
  //     },
  //   );

  //   _isLoading = false;
  //   notifyListeners();

  //   Future.delayed(const Duration(milliseconds: 2000), () {
  //     _isMaterialAdded = false;
  //     notifyListeners();
  //   });
  // }

  void addRequestedMaterial(
    BuildContext context,
    List<WorkSpaceRequestedMaterialsInventory> workSpaceRequestedMaterialsInventory,
    String wantedMaterialAmount,
    String subject,
    String hintAmount,
    String workSpaceId,
    String choosenMaterial,
    String description,
    String taskId,
  ) async {
    if (wantedMaterialAmount == '0' || wantedMaterialAmount.isEmpty || subject.isEmpty || hintAmount.isEmpty || hintAmount == '0') {
      snackBar(context, LocaleKeys.EmptyRequestMaterialFields.tr(), 'error');
      return;
    }

    if ((int.tryParse(wantedMaterialAmount) ?? 0) > (int.tryParse(hintAmount) ?? 0)) {
      snackBar(context, LocaleKeys.WantedMaterialAmountBiggerThanHintAmount.tr(), 'error');
      return;
    }

    _isLoading = true;
    notifyListeners();

    String userToken = await SharedManager().getString(SharedEnum.userToken);

    String materialId = '';

    for (var i = 0; i < workSpaceRequestedMaterialsInventory.length; i++) {
      if (workSpaceRequestedMaterialsInventory[i].name == choosenMaterial) {
        materialId = workSpaceRequestedMaterialsInventory[i].id.toString();
        break;
      }
    }

    if (materialId.isEmpty) return;

    await workSpaceService
        .requestWorkSpaceMaterial(
          workSpaceId,
          taskId,
          userToken,
          subject,
          description,
          wantedMaterialAmount,
          materialId,
        )
        .then(
          (value) => value.fold(
            (l) => {
              _isMaterialRequested = true,
            },
            (r) => {
              _isMaterialRequested = false,
            },
          ),
        );

    _isLoading = false;
    notifyListeners();

    Future.delayed(const Duration(seconds: 2), () {
      _isMaterialRequested = false;
    });
  }

  void savePdf(BuildContext context, String pdfPath, String pdfName, String desc, String taskId, String taskKey) async {
    if (pdfPath.isEmpty) {
      snackBar(context, LocaleKeys.EmptyPdfPath.tr(), 'error');
      return;
    }
    _isLoading = true;
    notifyListeners();

    final String token = await SharedManager().getString(SharedEnum.userToken);

    final response = await workSpaceService.saveDocumant(pdfPath, pdfName, desc, token, taskId, taskKey, 'pdf');

    response.fold(
      (l) => {
        l
            ? {
                _isDocumantAdded = true,
              }
            : {
                _isDocumantAdded = false,
              }
      },
      (r) => {},
    );

    _isLoading = false;
    notifyListeners();

    Future.delayed(const Duration(seconds: 2), () {
      _isDocumantAdded = false;
    });
  }

  void saveImage(BuildContext context, String imagePath, String desc, String taskId, String taskKey) async {
    if (imagePath.isEmpty) {
      snackBar(context, LocaleKeys.EmptyImagePath.tr(), 'error');
      return;
    }
    _isLoading = true;
    notifyListeners();

    final String token = await SharedManager().getString(SharedEnum.userToken);

    final response = await workSpaceService.saveDocumant(imagePath, '', desc, token, taskId, taskKey, 'image');
    response.fold(
      (l) => {
        l
            ? {
                _isImageAdded = true,
              }
            : {
                _isImageAdded = false,
              }
      },
      (r) => {},
    );

    _isLoading = false;
    notifyListeners();

    Future.delayed(const Duration(seconds: 2), () {
      _isImageAdded = false;
    });
  }
}

class DateModel {
  final String? startDate;
  final String? endDate;
  final String? updateDate;

  DateModel({
    this.startDate,
    this.endDate,
    this.updateDate,
  });
}
