@isTest 
private with sharing class MaintenanceRequestHelperTest {
    // implement scheduled code here
    //Maintenance requests with an Item with an equipment without Maintenance_Cycle, this fires the trigger 
    @isTest  
    static void maintenanceRequestWithoutMaintenanceCycle(){
        Vehicle__c vehicle = new Vehicle__c(Name='Test Vehicle');
        insert vehicle;
        Product2 equipment = new Product2(Name = 'Test Equipment',Lifespan_Months__c = 5, Replacement_Part__c = true);
        insert equipment;
        
        Case maintenanceRequest = new Case(type = 'Routine Maintenance',Status = 'New',Subject = 'Maintenance Request Test',Origin = 'Web',
                                           ProductId = equipment.Id,Product__c = equipment.Id,Vehicle__c = vehicle.id);
        insert maintenanceRequest;
        
        Equipment_Maintenance_Item__c item = new Equipment_Maintenance_Item__c(Equipment__c = equipment.Id, Maintenance_Request__c = maintenanceRequest.Id);
        insert item;
        
        Test.startTest();
        maintenanceRequest.Status = 'Closed';
        update maintenanceRequest;
        Test.stopTest();
        
        List<Case> maintenanceRequestCreated = [SELECT id FROM Case WHERE ParentId = :maintenanceRequest.Id];
        system.assert(maintenanceRequestCreated.size() == 1);  
    }
    
    
    //this fires the trigger with a maintenance request with an equipment without maintenance request items  
    @isTest  
    static void noItemsMaintenanceRequest(){
        Vehicle__c vehicle = new Vehicle__c(Name='Test Vehicle');
        insert vehicle;
        Product2 equipment = new Product2(Name = 'Test Equipment',Lifespan_Months__c = 5, Replacement_Part__c = true);
        insert equipment;
        
        Case maintenanceRequest = new Case(type = 'Routine Maintenance',Status = 'New',Subject = 'Maintenance Request Test',Origin = 'Web',
                                           ProductId = equipment.Id,Product__c = equipment.Id,Vehicle__c = vehicle.id);
        insert maintenanceRequest;
        
        Test.startTest();
        maintenanceRequest.Status = 'Closed';
        update maintenanceRequest;
        Test.stopTest();
        
        List<Case> maintenanceRequestCreated = [SELECT id FROM Case WHERE ParentId = :maintenanceRequest.Id];
        system.assert(maintenanceRequestCreated.size() == 1);  
    }
     
    //this is not firing the trigger is no the correct criteria for the trigger
    @isTest 
    static void notFireTriggerCases(){
        Vehicle__c vehicle = new Vehicle__c(Name='Test Vehicle');
        insert vehicle;
        Id vehicleId = vehicle.Id;
        Product2 equipment = new Product2(Name = 'Test Equipment',Lifespan_Months__c = 5,Maintenance_Cycle__c = 30,
                                          Replacement_Part__c = true);
        insert equipment;
        Case maintenanceRequest = new Case(type = 'Other',Status = 'New',Subject = 'Maintenance Request Test',Origin = 'Web',
                                           ProductId = equipment.Id,Product__c = equipment.Id,Vehicle__c = vehicle.id);
        insert maintenanceRequest;
        Equipment_Maintenance_Item__c maintenanceItem = new Equipment_Maintenance_Item__c(Equipment__c = equipment.Id,
                                                                                          Maintenance_Request__c = maintenanceRequest.Id);
        insert maintenanceItem;
        Test.startTest();
        maintenanceRequest.Status = 'Closed';
        update maintenanceRequest;
        Test.stopTest();
        
        List<Case> maintenanceRequestCreated = [SELECT id FROM Case WHERE ParentId = :maintenanceRequest.Id];
        system.assert(maintenanceRequestCreated.size() == 0);
        
        
    }
    //bulkify cases with items, cycle, equipments and correct criteria for trigger to fire 
    @isTest 
    static void bulkTriggerCases(){
        
        Vehicle__c vehicle = new Vehicle__c(Name='Test Vehicle ');
        insert vehicle;
        
        Product2 equipment = new Product2(Name = 'Test Equipment',Lifespan_Months__c = 5,Maintenance_Cycle__c = 30,
                                          Replacement_Part__c = true);
        Product2 equipment2 = new Product2(Name = 'Test Equipment',Lifespan_Months__c = 3,Maintenance_Cycle__c = 15,
                                           Replacement_Part__c = true);
        Product2 equipment3 = new Product2(Name = 'Test Equipment',Lifespan_Months__c = 2,Maintenance_Cycle__c = 20,
                                           Replacement_Part__c = true);
        insert equipment;
        insert equipment2;
        insert equipment3;
        List<Case> maintenanceRequestList =  new List<Case>();
        
        for(Integer i=0; i<300; i++){
            Case maintenanceRequest = new Case(Type = 'Repair',Status = 'New',Subject = 'Maintenance Request Test'+i,Origin = 'Web',
                                               ProductId = equipment.Id,Product__c = equipment.Id,Vehicle__c = vehicle.id);
            maintenanceRequestList.add(maintenanceRequest);
        }
        
        insert maintenanceRequestList;
        
        List<Equipment_Maintenance_Item__c> itemList = new List<Equipment_Maintenance_Item__c>();
        
        for(Case c : maintenanceRequestList){
            Equipment_Maintenance_Item__c maintenanceItem = new Equipment_Maintenance_Item__c(Equipment__c = equipment.Id,
                                                                                              Maintenance_Request__c = c.Id);
            Equipment_Maintenance_Item__c maintenanceItem2 = new Equipment_Maintenance_Item__c(Equipment__c = equipment2.Id,
                                                                                               Maintenance_Request__c = c.Id);
            Equipment_Maintenance_Item__c maintenanceItem3 = new Equipment_Maintenance_Item__c(Equipment__c = equipment3.Id,
                                                                                               Maintenance_Request__c = c.Id);
            itemList.add(maintenanceItem);
            itemList.add(maintenanceItem2);
            itemList.add(maintenanceItem3);
            
        }
        insert itemList;
        //test 
        Test.startTest();
        List<Case> updatedMaintenanceRequestList = new List<Case>();
        for(Case c : maintenanceRequestList){
            Case updatingMaintenanceRequest = new Case();
            updatingMaintenanceRequest.id = c.id;
            updatingMaintenanceRequest.Status = 'Closed';
            updatedMaintenanceRequestList.add(updatingMaintenanceRequest);
            
        }
        system.debug([SELECT id From Case].size());
        update updatedMaintenanceRequestList;
        
        Test.stopTest();
        
        
        List<Case> maintenanceRequestUpdated = [SELECT id FROM Case WHERE ParentId IN :updatedMaintenanceRequestList];
        system.assert(maintenanceRequestUpdated.size() == 300 );
        
    }
    
}