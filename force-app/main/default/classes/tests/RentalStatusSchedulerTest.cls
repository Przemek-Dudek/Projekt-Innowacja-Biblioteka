/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
public class RentalStatusSchedulerTest {

    @testSetup
    static void setupTestData() {
        Item__c book = new Item__c(Name = 'Book 1', All_Copies__c = 10, RecordTypeId = RecordTypesUtility.getRecordTypeId(Item__c.SobjectType, 'Book'));
        insert book;
        Person__c person = new Person__c(Name__c = 'Test', Surname__c = 'Test', RecordTypeId = RecordTypesUtility.getRecordTypeId(Person__c.SobjectType, 'Client'));
        insert person;
        List<Rental__c> rentals = new List<Rental__c>();
        rentals.add(new Rental__c(Status__c = 'borrowed', Returning_Date__c = Date.today().addDays(-1), Borrower__c = person.Id, Item__c = book.Id));
        rentals.add(new Rental__c(Status__c = 'borrowed', Returning_Date__c = Date.today().addDays(-2), Borrower__c = person.Id, Item__c = book.Id));
        rentals.add(new Rental__c(Status__c = 'returned', Returning_Date__c = Date.today().addDays(-1), Borrower__c = person.Id, Item__c = book.Id));
        insert rentals;
    }

    @isTest
    static void testExecuteBatch() {
        Test.startTest();
        RentalStatusScheduler scheduler = new RentalStatusScheduler();
        String jobId = System.schedule('Test RentalStatusScheduler', '0 0 0 15 6 ? 2022', scheduler);
        Test.stopTest();

        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                          FROM CronTrigger WHERE Id = :jobId];
        System.assertEquals('0 0 0 15 6 ? 2022', ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);

        Test.startTest();
        Database.executeBatch(scheduler);
        Test.stopTest();

        List<Rental__c> updatedRentals = [SELECT Id, Status__c, Returning_Date__c FROM Rental__c WHERE Status__c = 'delayed'];
        System.assertEquals(2, updatedRentals.size(), 'Two rentals should be delayed');
    }

    @isTest
    static void testBatchErrorHandling() {
        List<Rental__c> rentalsWithErrors = new List<Rental__c>();
        rentalsWithErrors.add(new Rental__c(Status__c = 'borrowed', Returning_Date__c = null,Borrower__c = null, Item__c = null));
        insert rentalsWithErrors;

        Test.startTest();
        RentalStatusScheduler scheduler = new RentalStatusScheduler();
        Database.executeBatch(scheduler);
        Test.stopTest();

        List<Rental__c> delayedRentals = [SELECT Id, Status__c FROM Rental__c WHERE Status__c = 'delayed'];
        System.assertEquals(2, delayedRentals.size(), 'Two rentals should be delayed from the previous test');

        List<Rental__c> errorRentals = [SELECT Id, Status__c FROM Rental__c WHERE Status__c = 'borrowed' AND Returning_Date__c = null];
        System.assertEquals(1, errorRentals.size(), 'One rental should remain borrowed due to error');
    }
}
