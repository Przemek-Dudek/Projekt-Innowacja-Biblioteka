public with sharing class PersonUtils {
    public static String generateNewPin() {
        String pin = '';

        for (Integer i = 0; i < 6; i++) {
            pin += String.valueOf(randomInteger()); 
        }

        return pin;
    }

    public static Integer randomInteger() {
        return Integer.valueOf(Math.floor(Math.random() * 10));
    }

    public static String getPin(Id personId) {
        Person__c person = [SELECT Id, Pin__c FROM Person__c WHERE Id = :personId];
        return person.Pin__c;
    }

    @AuraEnabled(cacheable=false)
    public static void setPin(String personId) {
        String newPin = generateNewPin();

        System.debug('Setting new pin for person: ' + personId);

        Person__c person = [SELECT Id, Pin__c, Email_Address__c FROM Person__c WHERE Id = :personId];

        System.debug(person);

        person.Pin__c = newPin;

        update person;

        sendPinEmail(new List<Person__c>{ person });
    }

    public static boolean isPinValid(String pin, Id personId) {
        Person__c person = [SELECT Id, Pin__c FROM Person__c WHERE Id = :personId];
        return pin == person.Pin__c;
    }

    public static void sendPinEmail(List<Person__c> p) {
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        
        for(Person__c person : p) {
            String htmlBody = EmailHandler.createHtmlEmailContent(person.Pin__c);
            Messaging.SingleEmailMessage mail = EmailHandler.createSingleEmail(person.Email_Address__c, htmlBody, 'Your New Pin');
            mail.setHtmlBody(htmlBody);
            mails.add(mail);
        }
    
        Messaging.sendEmail(mails);
    }

    public static void removePenalty(string rentalId) {
        Rental__c rental = [SELECT Id, Overdue_Payment__c FROM Rental__c WHERE Id = :rentalId];
        
        rental.Overdue_Payment__c = 0;
        update rental;
    }

    @AuraEnabled(cacheable=true)
    public static List<Rental__c> getRentals(String personId){
        try {
            List<Rantal__c> rentals = [SELECT Id, Item__r., Rental_Date__c, Returning_Date__c, Overdue_Payment__c FROM Rental__C WHERE Borrower__c =: personId];
            return rentals;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}