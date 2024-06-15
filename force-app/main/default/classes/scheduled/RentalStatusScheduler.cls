public class RentalStatusScheduler implements Schedulable, Database.Stateful, Database.Batchable<SObject>{
    

    private Set<Id> errorToIDs = new Set<Id>();

    public void execute(SchedulableContext ctx) {
        Database.executeBatch(new RentalStatusScheduler());
    }

    public Database.QueryLocator start(Database.BatchableContext context) {
        errorToIDs = new Set<Id>();

        return Database.getQueryLocator([SELECT Id, Status__c, Returning_Date__c FROM Rental__c WHERE Returning_Date__c < TODAY AND Status__c = 'borrowed']);
    }

    public void execute(Database.BatchableContext context, List<Rental__c> rentals) {
        for (Rental__c rental : rentals) {
            rental.Status__c = 'delayed';
        }
        List<Database.SaveResult> results = Database.update(rentals, false);
            
        
        for (Integer i = 0; i < results.size(); i++) {
            if (!results[i].isSuccess()) {
                System.debug('Error in RentalStatusScheduler');
                System.debug(rentals[i].Id);
                System.debug(results[i].getErrors()[0].getMessage());
                errorToIDs.add(rentals[i].Id);
            }
        }
        
    }

    public void finish(Database.BatchableContext context) {
        if (errorToIDs.size() > 0) {
            System.debug('Error in RentalStatusScheduler Batch'+errorToIDs);
        }
    }

}
