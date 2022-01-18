@isTest
global class WarehouseCalloutServiceMock implements HttpCalloutMock {
    // implement http mock callout
    global HttpResponse response = new HttpResponse();
    
    global WarehouseCalloutServiceMock(Boolean dataError){
        if(dataError){
            response.setBody('[{"_id":"","replacement":false,"quantity":5,"name":"Generator 1000 kW","maintenanceperiod":365,"lifespan":120,"cost":5000,"sku":"100003"},{"_id":"55d66226726b611100aaf742","replacement":true,"quantity":183,"name":"Cooling Fan","maintenanceperiod":0,"lifespan":0,"cost":300,"sku":"100004"}]');
            
        }else{
            response.setBody('');
            
        }
    }
    
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        response.setHeader('Content-Type', 'application/json');
        response.setStatusCode(200);
        return response; 
    }
    
    
    
    
}