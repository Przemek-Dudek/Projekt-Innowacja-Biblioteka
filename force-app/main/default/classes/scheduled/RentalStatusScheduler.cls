public class RentalStatusScheduler implements Schedulable, Database.Stateful, Database.Batchable<SObject>{
    private Set<Id> errorToIDs = new Set<Id>();
    private Boolean isUpdateSuccessful = true;

    public void execute(SchedulableContext ctx) {
        Database.executeBatch(new RentalStatusScheduler());
    }

    public Database.QueryLocator start(Database.BatchableContext context) {
        errorToIDs = new Set<Id>();
        isUpdateSuccessful = true;

        return Database.getQueryLocator([SELECT Id, Status__c, Returning_Date__c FROM Rental__c WHERE Returning_Date__c < TODAY AND Status__c = 'borrowed']);
    }

    public void execute(Database.BatchableContext context, List<Rental__c> rentals) {
        for (Rental__c rental : rentals) {
            rental.Status__c = 'delayed';
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
