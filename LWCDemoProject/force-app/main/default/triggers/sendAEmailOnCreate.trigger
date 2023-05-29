trigger sendAEmailOnCreate on Contact (before insert) {
    List<string> toAddresses = new List<string>();
    List<Messaging.SingleEmailMessage> emailList = new  List<Messaging.SingleEmailMessage>();
    for(Contact Con : trigger.new){
        
        Messaging.SingleEmailMessage msgObj = new Messaging.SingleEmailMessage();
        toAddresses.add(userinfo.getUserEmail());
        msgObj.setToAddresses(toAddresses);
        msgObj.setSubject('Contact has been created');
        msgobj.setHtmlBody('Contact'+Con);
        emailList.add(msgobj);
       Messaging.sendEmail(emailList);  
        
    }

}