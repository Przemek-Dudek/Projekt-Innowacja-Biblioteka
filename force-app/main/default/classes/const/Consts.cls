public with sharing class Consts {
    @TestVisible
    public static final String EMAIL_SENDER = 'Library Notification';
    public static final String LIBRARY_LOGO = 'Library logo';

    public static final Integer DAYS_TO_RETURN = Integer.valueOf([
        select Days_to_return__c 
        from Days_to_Return__mdt 
        where QualifiedApiName = 'Three_days_to_return'
    ].Days_to_return__c);
    
    public static final String JOB_NAME = 'Notification to return an Item';
    public static final String SUBJECT = 'Return Item Reminder';
    public static final String BORROW_STATUS = 'borrowed';
    public static final String RETURN_NOTIFICATION = 'Please return the following items:';
    public static final String RETURN_NOTIFICATION_DATE = 'In following date: ';
    public static final String CRON_TIME = '0 0 5 * * ?';
    public static final String ERROR_MESSAGE = 'An error occured.';
}