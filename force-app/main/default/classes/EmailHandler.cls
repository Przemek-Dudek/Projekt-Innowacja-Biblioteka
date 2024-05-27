public with sharing class EmailHandler {
    private static final String EMAIL_SENDER_NAME = 'Library';

    public static Messaging.SingleEmailMessage createSingleEmail(String emailAddress, String emailTextBody, String emailSubject) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> toAddresses = new List<String>{ emailAddress };

        mail.setToAddresses(toAddresses);
        mail.setSubject(emailSubject);
        mail.setPlainTextBody(emailTextBody);
        mail.setSenderDisplayName(EMAIL_SENDER_NAME);

        return mail;
    }

    public static String createHtmlEmailContent(String pin) {
        String htmlBody = '<html><body>';
        htmlBody += '<h1>Your New Pin</h1>';
        htmlBody += '<p>Your new pin is: <strong>' + pin + '</strong></p>';
        htmlBody += '</body></html>';
    
        return htmlBody;
    }
}
