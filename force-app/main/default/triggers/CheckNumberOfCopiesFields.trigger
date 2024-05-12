trigger CheckNumberOfCopiesFields on Item__c (before insert) {
    ItemRecordTypesUtility itemRecordTypesUtility = new ItemRecordTypesUtility();
    for (Item__c item : Trigger.new) {
        if (item.RecordTypeId == itemRecordTypesUtility.bookRecordTypeId || item.RecordTypeId== itemRecordTypesUtility.magazineRecordTypeId) {
            if (item.All_Copies__c < 1 || item.All_Copies__c != item.Available_Copies__c) {
                item.addError('Available copies or all copies cannot be less than 1 for Book or Magazine and they can not differ.');
            }
        }
    }
}