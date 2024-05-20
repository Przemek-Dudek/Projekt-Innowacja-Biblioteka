trigger CheckNumberOfBorrowedItemsTrigger on Rental__c (before insert) {
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            TriggerHandler.checkNumberOfBorrowedItems(Trigger.new);
        }
    }
    
}