trigger PostponeReturnalEmailTrigger on Rental__c (after update) {
	
	Set<Id> updatedRentalsDemanders=new Set<Id>();
	for (Rental__c  r: Trigger.new) {
		updatedRentalsDemanders.add(r.Borrower__c);
	}
	
	Map<String, Person__c> ClientDetails = new Map<String, Person__c>();
    
	List<String> EmployeeAddresses=[SELECT 	Email_Address__c FROM Person__c WHERE RecordTypeId = recordTypes.get('Employee').getRecordTypeId();];

	List<Person__c> listOfClients =  [SELECT Email_Address__c, Name, Surname__c FROM Person__c WHERE Id IN :updatedRentalsDemanders];
	
	for(Person__c person : listOfClients) {
		ClientDetails.put(person.Id, person);
	}
	
	List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
	
	for (Rental__c rental : Trigger.new) {
		Person__c client = ClientDetails.get(rental.Borrower__c);
		if (client != null && client.Email_Address__c != null) {

			
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			mail.setToAddresses(EmployeeAddresses);//adres do wysylki
			mail.setSubject('Request to postpone date of the item returnal');
			
			String build = String.format('Check if postponing returnal is aviable for this client. Here are his data:\n Rental Date:{0}\nReturning Date: {1}',
			new List<Object> {
				rental.Rental_Date__c,
                rental.Returning_Date__c
			}
			);
			
			mail.setPlainTextBody(build);
			emails.add(mail);
		}
	}
	
	
	Messaging.sendEmail(emails);
	
}