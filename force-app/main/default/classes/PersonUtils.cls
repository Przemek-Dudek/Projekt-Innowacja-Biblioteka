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

    public static void setPin(Person__c person) {
        String newPin = generateNewPin();

        person.Pin__c = newPin;

        update person;

        sendPinEmail(new List<Person__c>{ person });
    }

    public static boolean isPinValid(String pin, Person__c person) {
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
}