trigger CheckNumberOfBorrowedItems on Rental__c (before insert) {
    Set<Id> borrowerIds = new Set<Id>();
    Integer i=0;
    for (Rental__c rental : Trigger.new) {
        borrowerIds.add(rental.Borrower__c);
        i=i+1;
    }
    System.debug('pierwsza petla '+borrowerIds.toString());
    System.debug('czy to wgl dziala? '+i);

    Map<Id, Person__c> borrowersMap = new Map<Id, Person__c>(
    [SELECT Id, Number_of_borrowed_items__c, Rental_Limitation__c 
         FROM Person__c
         WHERE Id IN :borrowerIds]);
    System.debug('rozmiar mapy: '+borrowersMap.size());
    for (Rental__c rental : Trigger.new) {
        Person__c borrower = borrowersMap.get(rental.Borrower__c);
        //System.debug('pierwsza petla '+rental.Borrower__c.Surname__c);
        System.debug('limit:'+borrower.Rental_Limitation__c);
        System.debug('obecne wypozyczenia:'+borrower.Number_of_borrowed_items__c);
        if (borrower.Number_of_borrowed_items__c >= borrower.Rental_Limitation__c) {
            System.debug('limit:'+borrower.Rental_Limitation__c);
            System.debug('obecne wypozyczenia:'+borrower.Number_of_borrowed_items__c);
            rental.addError('Użytkownik osiągnał maksimum wypożyczonych książek');
        }
    } 
    
}