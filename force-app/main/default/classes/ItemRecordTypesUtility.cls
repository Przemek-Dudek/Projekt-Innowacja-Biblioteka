public with sharing class ItemRecordTypesUtility {
    public String bookRecordTypeId { get; private set; }
    public String magazineRecordTypeId { get; private set; }

    public ItemRecordTypesUtility() {
        fetchRecordTypeIds();
    }

    public void fetchRecordTypeIds() {
        List<RecordType> recordTypes = [SELECT Id, Name FROM RecordType WHERE SObjectType = 'Item__c'];
        
        for (RecordType rt : recordTypes) {
            if (rt.Name == 'Book') {
                bookRecordTypeId = rt.Id;
            } else if (rt.Name == 'Magazine') {
                magazineRecordTypeId = rt.Id;
            }
        }
    }
}