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
        //todo: add custom classic email template
        //mail.setTemplateId
        //mail.setEntity

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

    public static Messaging.SingleEmailMessage createSingleNotificationEmail(
        String emailAddress,
        List<String> emailTextBody
    ) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new List<String>{ emailAddress };
        mail.setToAddresses(toAddresses);
        EmailTemplate template = [
            SELECT Id, Name, Subject, Description, HtmlValue, DeveloperName, Body
            FROM EmailTemplate
            WHERE Id = :Consts.NOTIFICATION_EMAIL_TEMPLATE_ID
        ];

        // emailTextBody.add('<img alt="Library logo" src="'+ prepareImageSrc() +'" />');
        // mail.setTemplateId('00X3O000003lTYYUA2');
        // mail.setEntityId('a023O00000GAVqsQAH');
        mail.setSenderDisplayName(Consts.EMAIL_SENDER);
        mail.setSubject(template.Subject);
        mail.setHtmlBody(String.format(template.HtmlValue, emailTextBody));
        return mail;
    }    


    public static String prepareImageSrc() {
        if(Test.isRunningTest()) {
            return 'test';
        }
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
        String userEmail = UserInfo.getUserEmail();

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