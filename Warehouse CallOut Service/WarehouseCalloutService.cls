public with sharing class WarehouseCalloutService implements Queueable, Database.AllowsCallouts {
    
    private final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    
    public void execute(QueueableContext context){
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        try{
            request.setEndpoint(WAREHOUSE_URL);
            request.setMethod('GET');
            HttpResponse response = http.send(request);	
            
            system.debug(response.getStatusCode());
            if(response.getStatusCode()==200){
                 
                List<Object> externalEquipments = (List<Object>)JSON.deserializeUntyped(response.getBody());
                List<Product2> equipmentsList = New List<Product2>(); 
                 
                system.debug('Equipments received');
                
                for(Object equipment : externalEquipments){
                    Map<String, Object> equipmentMap = (Map<String, Object>)equipment;
                    
                    Product2 productEquipment = new Product2();
                    productEquipment.Warehouse_SKU__c = (String)equipmentMap.get('_id');
                    productEquipment.Replacement_Part__c = (Boolean)equipmentMap.get('replacement');
                    productEquipment.Current_Inventory__c = (Integer)equipmentMap.get('quantity');
                    productEquipment.Maintenance_Cycle__c = (Integer)equipmentMap.get('maintenanceperiod');
                    productEquipment.Lifespan_Months__c = (Integer)equipmentMap.get('lifespan');
                    productEquipment.Cost__c = (Decimal)equipmentMap.get('cost');
                    productEquipment.Name = (String)equipmentMap.get('name');
                    productEquipment.ProductCode = (String)equipmentMap.get('sku');
                    
                    equipmentsList.add(productEquipment);
                    
                }
                
                if(equipmentsList.size() > 0 ){
                    system.debug('antes upsert');
                    upsert equipmentsList;
                    system.debug('success');
                }
              
                
            }
        }catch(Exception e){
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
    }
}