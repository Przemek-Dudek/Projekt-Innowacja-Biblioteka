trigger CheckNumberOfCopiesFields on Item__c (before insert) {
    for (Item__c item : Trigger.new) {
        if (item.RecordTypeId == ItemRecordTypesUtility.getRecordTypeId(Item__c.getSobjectType(), 'Book') || item.RecordTypeId== ItemRecordTypesUtility.getRecordTypeId(Item__c.getSobjectType(), 'Magazine')) {
            if (item.All_Copies__c < 1 || item.All_Copies__c != item.Available_Copies__c) {
                item.addError('Available copies or all copies cannot be less than 1 for Book or Magazine and they can not differ.');
            }
        }
    }
}