trigger ItemTrigger on Item__c (before insert) {
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            ItemTriggerHandler.onBeforeInsert(Trigger.new);
        }
    }
}