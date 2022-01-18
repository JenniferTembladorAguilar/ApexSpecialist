public with sharing class MaintenanceRequestHelper {
    
    public static void updateWorkOrders(Map<Id, Case> triggerCases) {
        // TODO: Complete the method to update workorders
        List<Case> newMaintenanceList = new List<Case>();
        Map<Id, List<Equipment_Maintenance_Item__c>> EquipmentItems = new Map<Id, List<Equipment_Maintenance_Item__c>>();
        
        for(Equipment_Maintenance_Item__c Item : [SELECT Id, Maintenance_Request__c, Equipment__c, Maintenance_Request__r.Date_Due__c,
                                                  Equipment__r.Maintenance_Cycle__c, Quantity__c 
                                                  FROM Equipment_Maintenance_Item__c 
                                                  WHERE Maintenance_Request__c IN :triggerCases.keySet()]){
                                                      Id keyCase = Item.Maintenance_Request__c;
                                                      if(EquipmentItems.containsKey(keyCase)){
                                                          EquipmentItems.get(keyCase).add(Item);
                                                      } else{
                                                          List<Equipment_Maintenance_Item__c> newItem = new List<Equipment_Maintenance_Item__c>();
                                                          newItem.add(Item);
                                                          EquipmentItems.put(keyCase, newItem);
                                                      }
                                                      
                                                  }
        
        
        
        
        for(Case cs : triggerCases.values()){
            Decimal shortCycle;
             
            if(EquipmentItems.ContainsKey(cs.Id)){
                for(Equipment_Maintenance_Item__c e :EquipmentItems.get(cs.Id)){
                    
                    if(e.Equipment__r.Maintenance_Cycle__c != null){
                        if(shortCycle == null){
                            shortCycle = e.Equipment__r.Maintenance_Cycle__c;
                        }else if(shortCycle > e.Equipment__r.Maintenance_Cycle__c){
                            shortCycle = e.Equipment__r.Maintenance_Cycle__c;
                        }
                    }else{
                        shortCycle = 0; 
                    }
                    
                }
            }else{
               shortCycle = 0; 
            }
            Case newMaintenance = new Case();
            newMaintenance.Vehicle__c = cs.Vehicle__c;
            newMaintenance.Product__c = cs.Product__c;   
            newMaintenance.ProductId = cs.ProductId;
            newMaintenance.Type = 'Routine Maintenance';
            newMaintenance.Subject = String.isBlank(cs.Subject) ? 'Routine Maintenance Request' : cs.Subject + ' New';
            newMaintenance.Date_Reported__c = Date.Today();
            newMaintenance.Status = 'New';
            newMaintenance.Date_Due__c = date.today() + (Integer)shortCycle;
            newMaintenance.ParentId  = cs.id;
            newMaintenanceList.add(newMaintenance);
        }
        if(newMaintenanceList.size()>0){
            insert newMaintenanceList;
            List<Equipment_Maintenance_Item__c> listItem = new List<Equipment_Maintenance_Item__c>();
            for(Case cs : newMaintenanceList){
                if(EquipmentItems.ContainsKey(cs.ParentId)){
                    for(Equipment_Maintenance_Item__c e :EquipmentItems.get(cs.ParentId)){
                        Equipment_Maintenance_Item__c item = new Equipment_Maintenance_Item__c();
                        item.Maintenance_Request__c = cs.id;
                        item.Equipment__c = e.Equipment__c;
                        item.Quantity__c = e.Quantity__c;
                        listItem.add(item);
                    }
                }
                
            }
            insert listItem;
            
        }
        
        
        
    }        
    
}