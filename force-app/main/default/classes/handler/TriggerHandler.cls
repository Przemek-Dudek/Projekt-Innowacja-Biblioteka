public without sharing class TriggerHandler {
    public static void checkIsBookAvailableForRental(List<Rental__c> newRentals) {
        for (Rental__c rental : newRentals) {
            if (rental.Item__r.Available_Copies__c < 1) {
                rental.addError('Item is not available for rent');
            }
        }
    }

    public static void updateItemCopies(List<Rental__c> newRentals) {
        Set<Id> itemIds = new Set<Id>();
        for (Rental__c rental : newRentals) {
            itemIds.add(rental.Item__c);
        }

        List<Item__c> itemsToUpdate = [SELECT Id, Available_Copies__c FROM Item__c WHERE Id IN :itemIds];
        Map<Id, Item__c> itemMap = new Map<Id, Item__c>(itemsToUpdate);

        for (Rental__c rental : newRentals) {
            Item__c item = itemMap.get(rental.Item__c);
            item.Available_Copies__c -= 1;
        }

        update itemMap.values();
    }

}