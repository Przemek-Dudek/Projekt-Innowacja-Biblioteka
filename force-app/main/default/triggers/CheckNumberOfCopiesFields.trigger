trigger CheckNumberOfCopiesFields on Item__c (before insert) {
    for (Item__c item : Trigger.new) {
        if (item.RecordTypeId == RecordTypesUtility.getRecordTypeId('Item__c', 'Book')
        || item.RecordTypeId== RecordTypesUtility.getRecordTypeId('Item__c', 'Magazine')) {
            if (item.All_Copies__c < 1) {
                item.addError('Available copies or all copies cannot be less than 1 for Book or Magazine and they can not differ.');
            }
        }
    }
}