@isTest
private with sharing class WarehouseSyncScheduleTest {
    // implement scheduled code here
    @isTest
    static void WarehouseSyncTest(){
        test.startTest();
        WarehouseSyncSchedule sch = new WarehouseSyncSchedule();
        String scheduledTime = '0 0 1 * * ?';
        id job = system.Schedule('Test WarehouseSyncSchedule',scheduledTime, sch);
        CronTrigger cron = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id =:job];
        system.assertEquals(scheduledTime, cron.CronExpression);
        test.stopTest();
    }
    
}