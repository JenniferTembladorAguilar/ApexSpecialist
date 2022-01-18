@IsTest
public class WarehouseCalloutServiceTest {
    // implement your mock callout test here
    @IsTest
    static void testWarehouseCalloutService(){
        
        
        test.startTest();
        WarehouseCalloutServiceMock callout = new WarehouseCalloutServiceMock(false);
        Test.setMock(HttpCalloutMock.class,callout);
        system.enqueueJob(new WarehouseCalloutService());	
        test.stopTest();
        system.assertEquals(200, callout.response.getStatusCode());
    }
    
    @IsTest
    static void testWarehouseCalloutServiceError(){
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock(true));
        system.enqueueJob(new WarehouseCalloutService());
        test.stopTest();
        
    }
}