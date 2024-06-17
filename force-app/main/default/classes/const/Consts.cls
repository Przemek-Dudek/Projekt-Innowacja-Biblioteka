public with sharing class Consts {
    @TestVisible
    public static final String EMAIL_SENDER = 'Library Notification';
    @TestVisible
    public static final String LIBRARY_LOGO = 'Library logo';

    public static final Integer DAYS_TO_RETURN {
        get {
            if(DAYS_TO_RETURN == null) {
                DAYS_TO_RETURN = Integer.valueOf([
                select Days_to_return__c 
                from Days_to_Return__mdt 
                where QualifiedApiName = 'Three_days_to_return'
            ].Days_to_return__c);
            }
            return DAYS_TO_RETURN;
            }
        private set ;
    }

    public static final String JOB_NAME = 'Notification to return an Item';
    public static final String BORROW_STATUS = 'borrowed';
    public static final String CRON_TIME_EVERY_MORNING = '0 0 5 * * ?';
    public static final String ERROR_MESSAGE = 'An error occured.';
    public static final String NOTIFICATION_EMAIL_TEMPLATE_ID {
        get {
            if(NOTIFICATION_EMAIL_TEMPLATE_ID == null) {
                NOTIFICATION_EMAIL_TEMPLATE_ID = [
                    SELECT Id 
                    FROM EmailTemplate 
                    WHERE DeveloperName = 'Email_Template_For_Library'
                ].Id;
            }
            return NOTIFICATION_EMAIL_TEMPLATE_ID;
        }
        private set;
    }
}