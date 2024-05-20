public without sharing class TriggerHandler {
	public static void checkIsBookAvailableForRental(List<Rental__c> newRentals) {
		Set<Id> itemIds = new Set<Id>();
		for (Rental__c rental : newRentals) {
			itemIds.add(rental.Item__c);
		}
		
		List<Item__c> items = [SELECT Id, Available_Copies__c FROM Item__c WHERE Id IN :itemIds];
		for(Item__c item : items) {
			if (item.Available_Copies__c < 1) {
				item.addError('Item is not available for rent');
			} else {
				item.Available_Copies__c -= 1;
			}
		}
		
		update items;
	}
	
	public static void checkNumberOfBorrowedItems(List<Rental__c> newRentals) {
		Set<Id> borrowerIds = new Set<Id>();
		Integer i=0;
		for (Rental__c rental : newRentals) {
			borrowerIds.add(rental.Borrower__c);
			i=i+1;
		}
		
		Map<Id, Person__c> borrowersMap = new Map<Id, Person__c>(
		[SELECT Id, Number_of_borrowed_items__c, Rental_Limitation__c
		FROM Person__c
		WHERE Id IN :borrowerIds]);
		
		for (Rental__c rental : newRentals) {
			Person__c borrower = borrowersMap.get(rental.Borrower__c);
			if (borrower.Number_of_borrowed_items__c >= borrower.Rental_Limitation__c) {
				rental.addError('Borrower has reached the rental limitation.');
			}
		}
	}
}