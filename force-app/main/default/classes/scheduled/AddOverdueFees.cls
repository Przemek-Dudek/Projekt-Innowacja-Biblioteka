public with sharing class AddOverdueFees implements Schedulable, Database.Stateful, Database.Batchable<SObject> {

    private Set<Id> errorToIDs = new Set<Id>();
    private Boolean isUpdateSuccessful = true;

    public void execute(SchedulableContext ctx) {
        Database.executeBatch(new AddOverdueFees());
    }

    public Database.QueryLocator start(Database.BatchableContext context) {
        errorToIDs = new Set<Id>();
        isUpdateSuccessful = true;

        return Database.getQueryLocator([SELECT Id, Overdue_Payment__c,Item__c,Item__r.RecordTypeId  FROM Rental__c WHERE Status__c = 'delayed']);
    }

    public void execute(Database.BatchableContext context, List<Rental__c> rentals) {
        for (Rental__c rental : rentals) {
            if(rental.Item__r.RecordTypeId == RecordTypesUtility.getRecordTypeId(Item__c.SobjectType, 'Book')){
                rental.Overdue_Payment__c += 5;
            }
            if(rental.Item__r.RecordTypeId == RecordTypesUtility.getRecordTypeId(Item__c.SobjectType, 'Magazine')){
                rental.Overdue_Payment__c += 3;
            }
        }
        try {
            update rentals;
        } catch (Exception e) {
            isUpdateSuccessful = false;
            for (Rental__c rental : rentals) {
                errorToIDs.add(rental.Id);
            }
        }
    }

    public void finish(Database.BatchableContext context) {
        if (!isUpdateSuccessful) {
            System.debug('Error in RentalStatusScheduler Batch'+errorToIDs);
        }
    }
}

