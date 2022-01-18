global with sharing class WarehouseSyncSchedule implements Schedulable {
    // implement scheduled code here
    global void execute(SchedulableContext context){
        
        //WarehouseCalloutService apiCallWarehouse  = new WarehouseCalloutService();
        //String scheduledTime = '0 0 1 * * ?';
        //String jobID = system.schedule('WarehouseSyncScheduleJob', scheduledTime, apiCallWarehouse);
        system.enqueueJob(new WarehouseCalloutService());
    }
}