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

    public static void setPin(Person__c person, String newPin) {
        if(newPin.length() != 6) {
            throw new System.StringException('The pin must be 6 characters long');
        }

        person.Pin__c = newPin;
        update person;
    }

    public static boolean isPinValid(String pin, Person__c person) {
        return pin == person.Pin__c;
    }
}