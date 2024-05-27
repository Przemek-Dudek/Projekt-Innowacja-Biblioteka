public with sharing class ItemTriggerHandler {
    public static void onBeforeInsert(List<Item__c> newList) {
        for(Item__c item : newList) {
            if (item.RecordTypeId == RecordTypesUtility.getRecordTypeId(Item__c.SobjectType, 'Book')
            || item.RecordTypeId== RecordTypesUtility.getRecordTypeId(Item__c.SobjectType, 'Magazine')) {
                if (item.All_Copies__c < 1) {
                    item.addError('All copies cannot be less than 1 for Book or Magazine.');
                }
            }
        }
    }
}