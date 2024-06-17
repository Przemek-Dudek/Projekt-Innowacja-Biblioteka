@isTest
private class EmailManagerTest {
    public static final String EMAIL_RECEIVER = '240810@edu.p.lodz.pl';
    public static final String EMAIL_CONTENT = 'Example email content.';
    public static final String EXPECTED_EMAIL_HTML_CONTENT = 
    '<html><body>' + EMAIL_CONTENT + '<br /> <img alt="Library logo" src="test" /></body></html>';
  
    @IsTest
    public static void testCreateSingleEmail() {
      Messaging.SingleEmailMessage email = EmailManager.createSingleEmail(
        EMAIL_RECEIVER,
        EMAIL_CONTENT,
        'Test Email Subject'
      );

      System.assertEquals(EMAIL_RECEIVER, email.getToAddresses()[0]);
      System.assertEquals('Test Email Subject', email.getSubject());
      System.assertEquals(EXPECTED_EMAIL_HTML_CONTENT, email.getHtmlBody());
      System.assertEquals(Consts.EMAIL_SENDER, email.getSenderDisplayName());
    }
  
    @IsTest
    public static void testCreateSingleEmailEmptySubject() {
      Messaging.SingleEmailMessage email = EmailManager.createSingleEmail(
        EMAIL_RECEIVER,
        EMAIL_CONTENT,
        ''
      );
  
      System.assertEquals(EMAIL_RECEIVER, email.getToAddresses()[0]);
      System.assertEquals('', email.getSubject());
      System.assertEquals(EXPECTED_EMAIL_HTML_CONTENT, email.getHtmlBody());
      System.assertEquals(Consts.EMAIL_SENDER, email.getSenderDisplayName());
    }
  
    @IsTest
    public static void testCreateEmailContent() {
      Map<String, List<String>> errorsMap = new Map<String, List<String>>();
      errorsMap.put('Error1', new List<String>{ 'ID1', 'ID2' });
      errorsMap.put('Error2', new List<String>{ 'ID3', 'ID4', 'ID5' });
  
      String expectedContent = 'Error1 : ID1,ID2\nError2 : ID3,ID4,ID5';
      String actualContent = EmailManager.createEmailContent(errorsMap);
  
      System.assertEquals(expectedContent, actualContent);
    }
  
    @IsTest
    public static void testCreateEmailContentEmptyMap() {
      Map<String, List<String>> errorsMap = new Map<String, List<String>>();
  
      String expectedContent = '';
      String actualContent = EmailManager.createEmailContent(errorsMap);
  
      System.assertEquals(expectedContent, actualContent);
    }
  
    @IsTest
    public static void testSendErrorMessage() {
      Test.startTest();
      EmailManager.sendErrorMessage(
        'Test Error Subject',
        'This is the error message content.'
      );
      Test.stopTest();
  
      List<EmailMessage> sentEmails = [
        SELECT Id, ToAddress, Subject, TextBody
        FROM EmailMessage
      ];
      System.assertEquals(1, sentEmails.size());
      EmailMessage email = sentEmails[0];
  
      System.assertEquals(
        EMAIL_RECEIVER,
        email.ToAddress
      );
      System.assertEquals('Test Error Subject', email.Subject);
      System.assertEquals('This is the error message content.', email.TextBody);
    }
}