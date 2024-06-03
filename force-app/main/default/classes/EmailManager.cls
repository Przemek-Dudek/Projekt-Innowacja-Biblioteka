public with sharing class EmailManager {
    @TestVisible
    private static final String EMAIL_SENDER = 'Library Notification';

    public static Messaging.SingleEmailMessage createSingleEmail(
        String emailAddress,
        String emailTextBody,
        String emailSubject
    ) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new List<String>{ emailAddress };
        mail.setToAddresses(toAddresses);
        mail.setSubject(emailSubject);
        mail.setPlainTextBody(emailTextBody);
        mail.setSenderDisplayName(EMAIL_SENDER);
        return mail;
    }

    public static String createEmailContent(Map<String, List<String>> errorsMap) {
        List<String> records = new List<String>();

        for (String error : errorsMap.keySet()) {
        records.add(error + ' : ' + String.join(errorsMap.get(error), ','));
        }
        return String.join(records, '\n');
    }
    

    public static void sendErrorMessage(String subject, String body) {
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();

        Id userId = UserInfo.getUserId();
        List<User> users = [SELECT Email FROM User WHERE Id = :userId];

        mails.add(
        createSingleEmail(
            users[0].Email,
            body,
            subject
        )
        );
        Messaging.sendEmail(mails);
    }
}