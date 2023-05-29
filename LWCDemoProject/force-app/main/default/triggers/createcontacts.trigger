trigger createcontacts on Account (after insert,after update) {
    List<contact> lst = new List<contact>();
    List<contact> deletecontactList = new List<contact>();
    Map<id,Contact>existingConRecords; 
    
    map<id,decimal> ma = new map<id,decimal>();
    if(trigger.isInsert){
         for(account acc:Trigger.new){
        ma.put(acc.id,acc.ContactsCount__c);
     
    }
        if(ma.size()>0 && ma != null){
        For(id acid:ma.keySet()){
            for(integer i=0;i<ma.get(acid);i++)  {
               contact cont = new contact();
                cont.AccountId = acid;
                cont.LastName = 'contact'+i;
                lst.add(cont);
            } 
             }
      }
    }
   
    if(trigger.isUpdate){
        for(Account acc : trigger.new) {
            if(trigger.oldMap !=null){
                existingConRecords = new  Map<Id,Contact>([select id,accountId from contact where accountId IN:trigger.oldmap.keyset()]);
            }
            if(acc.ContactsCount__c != trigger.oldmap.get(acc.Id).ContactsCount__c){
                if(trigger.oldmap.get(acc.Id).ContactsCount__c < acc.ContactsCount__c){
                   Integer recordsToCreate = (Integer)(acc.ContactsCount__c - trigger.oldmap.get(acc.Id).ContactsCount__c) ;
                    for(integer i =0; i< recordsToCreate; i++){
                      contact cont = new contact();
                    cont.AccountId = acc.Id;
                    cont.LastName = 'contact'+i;
                    lst.add(cont);  
                }
                }else if(trigger.oldmap.get(acc.Id).ContactsCount__c > acc.ContactsCount__c){
                    system.debug(trigger.oldmap.get(acc.Id).ContactsCount__c);
                    system.debug(acc.ContactsCount__c);
                    Integer recordsToDelete = (Integer)(trigger.oldmap.get(acc.Id).ContactsCount__c - acc.ContactsCount__c) ;
                  	
                         for(Contact conList : existingConRecords.values()){
                             system.debug('existingConRecords'+existingConRecords.values());
                             if(conList.accountId == acc.Id){
                                 if(deletecontactList.size() < recordsToDelete) {
                                     deletecontactList.add(conList);
                                 }
                             }
                         }
                }
                }

        }
    }
    
    if(lst.size()>0 && lst != null){
     insert lst;    
    }
      
    
    if(deletecontactList.size()>0 && deletecontactList != null){
      Delete deletecontactList;       
    }
     
}