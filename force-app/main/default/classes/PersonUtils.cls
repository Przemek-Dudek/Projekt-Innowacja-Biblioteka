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

    @AuraEnabled(cacheable=false)
    public static void removePenalty(string personId) {
        Person__c person = [SELECT Id, Pin__c, Email_Address__c FROM Person__c WHERE Id = :personId]; //+Penalty
        
        // person.Penalty__c = 0;
        // update person;

        String htmlBody = '<html><body>';
        htmlBody += '<h3>Your Penalty</h3>';
        htmlBody += '<p>Your penalty has been removed</p>';
        htmlBody += '</body></html>';

        Messaging.SingleEmailMessage mail = EmailHandler.createSingleEmail(person.Email_Address__c, htmlBody, 'Your Penalty has been Removed');
        mail.setHtmlBody(htmlBody);
        
        Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
    }
}