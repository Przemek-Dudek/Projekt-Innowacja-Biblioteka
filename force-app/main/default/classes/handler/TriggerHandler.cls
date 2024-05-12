public without sharing class TriggerHandler {
    public static void checkIsBookAvailableForRental(List<Rental__c> newRentals) {
        Set<Id> itemIds = new Set<Id>();
        for (Rental__c rental : newRentals) {
            itemIds.add(rental.Item__c);
        }

        List<Item__c> items = [SELECT Id, Available_Copies__c FROM Item__c WHERE Id IN :itemIds];
        for(Item__c item : items) {
            if (item.Available_Copies__c < 1) {
                item.addError('Item is not available for rent');
            } else {
                item.Available_Copies__c -= 1;
            }
        }

        update items;
    }
}