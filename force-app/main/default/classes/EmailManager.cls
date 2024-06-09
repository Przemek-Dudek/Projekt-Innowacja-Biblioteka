public with sharing class EmailManager {
    public static Messaging.SingleEmailMessage createSingleEmail(
        String emailAddress,
        String emailTextBody,
        String emailSubject
    ) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new List<String>{ emailAddress };
        mail.setToAddresses(toAddresses);
        mail.setSubject(emailSubject);

        String baseUrl = URL.getOrgDomainUrl().toExternalForm();

        List<String> sb = new List<String>();
        sb.add('<html><body>');
        sb.add(emailTextBody);
        sb.add('<br /> <img alt="Library logo" src="'+ prepareImageSrc() +'" />');
        sb.add('</body></html>');        
        String htmlBody = String.join(sb, '');
        
        mail.setHtmlBody(htmlBody);
        mail.setSenderDisplayName(Consts.EMAIL_SENDER);
        return mail;
    }

    public static String prepareImageSrc() {
        String baseUrl = URL.getOrgDomainUrl().toExternalForm();
        Document doc = [select Id from Document where Name = :Consts.LIBRARY_LOGO];

        return baseUrl + '/servlet/servlet.FileDownload?file=' + doc.Id;
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
        //TODO: send mail to user id not email
        Id userEmail = UserInfo.getUserEmail();

        mails.add(
        createSingleEmail(
            userEmail,
            body,
            subject
        )
        );
        Messaging.sendEmail(mails);
    }
}