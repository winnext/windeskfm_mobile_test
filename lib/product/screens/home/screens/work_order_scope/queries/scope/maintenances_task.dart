const String maintenancesTask = r'''
query MaintenancesTask($where: MaintenanceWhere)  {
    maintenances(where: $where) {
      id
      MaintenancePlan {
        Components {
          willBeAppliedToComponents {
            componentOriginal
          }
        }
        FacilityStructures {
          willBeAppliedToFacilityStructures {
            facilityStructureOriginal
          }
        }
        Systems {
          willBeAppliedToSystem {
            SystemOriginal
          }
        }
      }
      ScheduledBy {
        parentSchedule {
          CheckList {
            name
            id
            hasRegulations {
              name
              id
              description
            }
            includesOfCheckItems {
              id
              name
              inputType
              labels
              photoRequired
              description
              isRequired
              documentRequired
            }
          }
        }
      }
    }
  }
  ''';

const String createCheckItemValue = r'''
mutation CreateCheckItemValue($createCheckItemValueInput: CreateCheckItemValueInput!) {
  createCheckItemValue(createCheckItemValueInput: $createCheckItemValueInput) {
    id
    key
  }
}
''';


const String startCheckListValueInput = r'''
mutation StartCheckListValue($startCheckListValueInput: StartCheckListValueInput!) {
  startCheckListValue(startCheckListValueInput: $startCheckListValueInput) {
    id
    labels
  }
}
''';

const String acceptRegulationMessage = r'''
mutation AcceptRegulationMessage($acceptRegulationMessageInput: AcceptRegulationMessageInput!) {
  acceptRegulationMessage(acceptRegulationMessageInput: $acceptRegulationMessageInput) {
    id   
  }
}
''';