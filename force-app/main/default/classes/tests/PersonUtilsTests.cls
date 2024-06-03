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
private class PersonUtilsTests {
    @testSetup
    static void setup() {
        Person__c testPerson = new Person__c();
        testPerson.Name__c = 'Test';
        testPerson.Surname__c = 'Person';
        testPerson.Email_Address__c = 'test@example.com';
        testPerson.Pin__c = '123456';
        insert testPerson;
    }

    @isTest
    static void testGetPin() {
        Person__c testPerson = [SELECT Id FROM Person__c WHERE Name__c = 'Test'];

        String pin = PersonUtils.getPin(testPerson.Id);

        System.assertEquals('123456', pin, 'The pin should be the same as the one set on the Person__c record');
    }

    @isTest
    static void testSetPin() {
        Person__c testPerson = [SELECT Id FROM Person__c WHERE Name__c = 'Test'];
        PersonUtils.setPin(testPerson.Id);
        
        testPerson = [SELECT Id, Pin__c FROM Person__c WHERE Id = :testPerson.Id];
        System.assertNotEquals(null, testPerson.Pin__c, 'The pin should be updated to the new value');
    }

    @isTest
    static void testIsPinValid() {
        Person__c testPerson = [SELECT Id FROM Person__c WHERE Name__c = 'Test'];
        System.assertEquals(true, PersonUtils.isPinValid('123456', testPerson.Id), 'The pin should be valid');
        System.assertEquals(false, PersonUtils.isPinValid('654321', testPerson.Id), 'The pin should not be valid');
    }

    @isTest
    static void testSendPinEmail() {
        Person__c testPerson = [SELECT Id FROM Person__c WHERE Name__c = 'Test'];

        Test.startTest();
        Integer emailInvocationsBefore = Limits.getEmailInvocations();
       
        PersonUtils.sendPinEmail(new List<Person__c>{ testPerson });

        Integer emailInvocationsAfter = Limits.getEmailInvocations();
        Test.stopTest();

        System.assertEquals(emailInvocationsBefore + 1, emailInvocationsAfter, 'An email should be sent to the person');
    }
}