@isTest
private class ReturnItemNotificationTest {
    @TestSetup
    static void makeData(){
        for (Integer i = 0; i < 3; i++) {
            Person__c person = new Person__c(
                Name__c = 'John' + String.valueOf(i),
                Surname__c = 'Doe' + String.valueOf(i),
                Email_Address__c = '240810@edu.p.lodz.pl' + String.valueOf(i)
            );
            insert person;

            Item__c item = new Item__c(
                Name = 'Test Item' + String.valueOf(i),
                All_Copies__c = 5
            );
            insert item;
        }
        

        List<Person__c> persons = [select Id from Person__c];

        List<Item__c> items = [select Id from Item__c];
        
        for (Integer i = 0; i < 3; i++) {
            Rental__c rental = new Rental__c(
                Status__c = 'borrowed',
                Returning_Date__c = System.today().addDays(3),
                Borrower__c = persons[i].Id,
                Item__c = items[i].Id
            );
            insert rental;
        }
    }
    
    @isTest
    static void testScheduleMe() {
        Test.startTest();
        Id jobId = ReturnItemNotification.scheduleMe();
        Test.stopTest();
        
        CronTrigger cronTrigger = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobId];
        System.assertEquals('0 0 5 * * ?', cronTrigger.CronExpression);
    }

    @isTest
    static void testExecute() {
        Test.startTest();
        ReturnItemNotification returnItemNotification = new ReturnItemNotification();
        returnItemNotification.execute(null);
        Test.stopTest();

        List<EmailMessage> emails = [
            SELECT TextBody, Subject, ToAddress, Id
            FROM EmailMessage
            WHERE MessageDate > :Datetime.now().addMinutes(-1)
        ];

        Assert.areEqual(
            3,
            emails.size(),
            'Invalid number of emails sent'
        );    
    }

    @isTest
    static void testBatchableMethods() {        
        Test.startTest();
        Database.BatchableContext bc;
        ReturnItemNotification batch = new ReturnItemNotification();

        Database.QueryLocator ql = batch.start(bc);
        System.assertNotEquals(null, ql);

        List<Rental__c> rentalList = [SELECT Id, Borrower__r.Email_Address__c, Item__r.Name, Returning_Date__c FROM Rental__c];
        batch.execute(bc, rentalList);

        Integer emailInvocations = Limits.getEmailInvocations();
        System.assertEquals(1, emailInvocations);

        batch.finish(bc);
        Test.stopTest();
    }

    @isTest
    static void testFinishWithError() {
        ReturnItemNotification.shouldForceException = true;
        List<Rental__c> rentalList = [SELECT Id, Borrower__r.Email_Address__c, Item__r.Name, Returning_Date__c FROM Rental__c];

        Test.startTest();
        ReturnItemNotification batch = new ReturnItemNotification();
        batch.execute(null, rentalList);
        batch.finish(null);
        Test.stopTest();

        System.assertNotEquals(0, batch.errorToAddress.size());
    }

    @IsTest
  static void addDaysInWeek() {
    Date inputDate1 = Date.newInstance(2024, 6, 3); // Monday
    Date expectedDate1 = inputDate1.addDays(1); // Tuesday
    Integer additionalDays1 = 1;
    Date actualDate1 = ReturnItemNotification.addBusinessDays(
      inputDate1,
      additionalDays1
    );
    Assert.areEqual(expectedDate1, actualDate1, 'Test case 1 failed');

    Date expectedDate2 = inputDate1.addDays(3); // Thursday
    Integer additionalDays2 = 3;
    Date actualDate2 = ReturnItemNotification.addBusinessDays(
      inputDate1,
      additionalDays2
    );
    Assert.areEqual(expectedDate2, actualDate2, 'Test case 2 failed');
  }

  @IsTest
  static void addDaysInWeekend() {
    Date inputDate1 = Date.newInstance(2024, 6, 8); // Saturday
    Date expectedDate1 = Date.newInstance(2024, 6, 10); // Monday
    Integer additionalDays1 = 1;
    Date actualDate1 = ReturnItemNotification.addBusinessDays(
      inputDate1,
      additionalDays1
    );
    Assert.areEqual(expectedDate1, actualDate1, 'Test case 1 failed');

    Date inputDate3 = inputDate1; // Saturday
    Date expectedDate3 = inputDate1.addDays(6); // Friday
    Integer additionalDays3 = 5;
    Date actualDate3 = ReturnItemNotification.addBusinessDays(
      inputDate3,
      additionalDays3
    );
    Assert.areEqual(expectedDate3, actualDate3, 'Test case 2 failed');
  }
}
