public with sharing class ReturnItemNotification implements Schedulable, Database.Batchable<SObject>, Database.Stateful{
  //TODO: const class with consts
  //TODO: add custom settings/custom metadata for DATS_TO_RETURN change
  //TODO: add icon of library to email with email template
    public static final Integer DAYS_TO_RETURN = 3;
    public static final String JOB_NAME = 'Notification to return an Item';
    public static final String SUBJECT = 'Return Item Reminder';
    public static final String BORROW_STATUS = 'borrowed';
    public static final String RETURN_NOTIFICATION = 'Please return the following items:';
    public static final String RETURN_NOTIFICATION_DATE = 'In following date: ';
    public static final String ERROR_MESSAGE = 'Error sending return reminder';

    public static final String CRON_TIME = '0 0 5 * * ?';


    @TestVisible
    private static Boolean shouldForceException = false;
    @TestVisible
    private final Map<String, List<String>> errorToAddress = new Map<String, List<String>>();
    
    public static Id scheduleMe() {
        ReturnItemNotification schedule = new ReturnItemNotification();
        return System.schedule(
          JOB_NAME,
          CRON_TIME,
          schedule
        );
      }

      public void execute(SchedulableContext context) {
        Database.executeBatch(new ReturnItemNotification(), 100);
      }

      public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
          [
            SELECT 
                Id, Borrower__r.Email_Address__c, Item__r.Name, Returning_Date__c
            FROM Rental__c
            WHERE
                Status__c = :BORROW_STATUS
                AND Returning_Date__c = :addBusinessDays(Date.today(), DAYS_TO_RETURN)
          ]
        );
      }

      public void execute(Database.BatchableContext bc, List<Rental__c> rentals) {
        Map<String, List<String>> emailToItems = generateEmailToItemsMap(rentals);
        Date endOfRentalDate = addBusinessDays(Date.today(), DAYS_TO_RETURN);
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        for (String email : emailToItems.keySet()) {
          Messaging.SingleEmailMessage newEmail = EmailManager.createSingleEmail(
              email,
              RETURN_NOTIFICATION + '\n' +
              String.join(emailToItems.get(email), '\n') + '\n' +
              RETURN_NOTIFICATION_DATE + endOfRentalDate.format(),
            SUBJECT
            );
    
          if ((Test.isRunningTest() && shouldForceException)) {
            newEmail.toAddresses = new List<String>{ 'exampleEmail' };
          }
    
          mails.add(newEmail);
        }
        List<Messaging.SendEmailResult> emailResults = Messaging.sendEmail(
          mails,
          false
        );
    
        for (Integer i = 0; i < emailResults.size(); i++) {
          if (!emailResults[i].isSuccess()) {
            String statusCode = emailResults[i]
              .getErrors()
              .get(0)
              .getStatusCode()
              .name();
            if (!errorToAddress.containsKey(statusCode)) {
              errorToAddress.put(statusCode, new List<String>());
            }
            errorToAddress.get(statusCode).add(mails[i].toAddresses[0]);
          }
        }
      }
    
      public void finish(Database.BatchableContext bc) {
        if (errorToAddress.size() > 0) {
          String body = String.format(
            ERROR_MESSAGE,
            new List<String>{
              Date.today().format(),
              EmailManager.createEmailContent(errorToAddress)
            }
          );
    
          EmailManager.sendErrorMessage(
            ERROR_MESSAGE,
            body
          );
        }
      }
    
      private static Map<String, List<String>> generateEmailToItemsMap(List<Rental__c> rentals) {
        Map<String, List<String>> emailToItems = new Map<String, List<String>>();
    
        for (Rental__c rental : rentals) {
          if (!emailToItems.containsKey(rental.Borrower__r.Email_Address__c)) {
            emailToItems.put(
                rental.Borrower__r.Email_Address__c,
                new List<String>()
            );
          }
          emailToItems.get(rental.Borrower__r.Email_Address__c).add(rental.Item__r.Name);
        }
    
        return emailToItems;
      }
    
      @TestVisible
      public static Date addBusinessDays(Date yourDate, Integer additionalDays) {
        if (additionalDays <= 0) {
          return yourDate;
        }
    
        Datetime finalDate = yourDate;
        Integer addedDays = 0;
        while (addedDays != additionalDays) {
          finalDate = finalDate.addDays(1);
          if (
            !(finalDate.format('E').equals('Sat') ||
            finalDate.format('E').equals('Sun'))
          ) {
            addedDays++;
          }
        }
    
        return finalDate.date();
      }
}