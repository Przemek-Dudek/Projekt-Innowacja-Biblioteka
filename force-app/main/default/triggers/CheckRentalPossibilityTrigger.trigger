trigger CheckRentalPossibilityTrigger on Rental__c (before insert, after insert) {
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            TriggerHandler.checkIsBookAvailableForRental(Trigger.new);
        }
        when AFTER_INSERT {
            TriggerHandler.updateItemCopies(Trigger.new);
        }
    }
}