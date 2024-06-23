@RestResource(urlMapping='/createCase/*')
global with sharing class CaseController {
    
    @HttpPost
    global static String createCase(String contactPhone, String contactEmail, String origin, String type, String reason, String subject, String description, String priority, String status, String product) {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        Contact contact = [SELECT Id, Email, Phone FROM Contact WHERE Email = :contactEmail OR Phone = :contactPhone LIMIT 1];

        Case newCase = new Case();
        newCase.ContactId = contact != null ? contact.Id : null;
        newCase.ContactPhone = contactPhone;
        newCase.ContactEmail = contactEmail;
        newCase.Origin = origin;
        newCase.Type = type;
        newCase.Reason = reason;
        newCase.Subject = subject;
        newCase.Description = description;
        newCase.Priority = priority;
        newCase.Status = status;
        newCase.Product__c = product;

        insert newCase;

        Group queue = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = :type LIMIT 1];
        if (queue != null) {
            newCase.OwnerId = queue.Id;
            update newCase;
        }

        if (contact != null) {
            sendEmailNotification(contact, newCase);
        }

        return 'Case created with Id: ' + newCase.Id;
    }

    private static void sendEmailNotification(Contact contact, Case caseRecord) {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[] { contact.Email });
        email.setSubject('Your case has been created');
        email.setPlainTextBody('Dear ' + contact.FirstName + ',\n\nYour case with the following details has been created:\n\nCase Number: ' + caseRecord.CaseNumber + '\nSubject: ' + caseRecord.Subject + '\nDescription: ' + caseRecord.Description + '\n\nWe will get back to you soon.\n\nBest regards,\nCustomer Support Team');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
    }
}
