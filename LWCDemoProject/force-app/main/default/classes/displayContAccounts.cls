public with sharing class displayContAccounts {
   @AuraEnabled
    public static list<Contact> getRelatedList(Id recordId)
    {
        List<Contact> Conlist = [Select id, name,firstname,lastname from Contact  where AccountId=: recordId ];
        system.debug('recordId'+recordId);
        return Conlist;
        
    }

}