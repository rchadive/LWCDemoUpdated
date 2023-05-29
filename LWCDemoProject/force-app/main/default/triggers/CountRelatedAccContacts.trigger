trigger CountRelatedAccContacts on Contact (after insert,after update,after delete,after undelete) {
	set<id> accidset = new set<id>();	
    if(trigger.isInsert && trigger.isAfter){
       for(Contact con : trigger.new){
        if(con.AccountId != null){
            accidset.add(con.AccountId);
        }
    } 
    }
    
        List<Account> acctsToRollup = new List<Account>();
    for (AggregateResult ar :[select count(id) contcount,accountId accId from contact where accountId =:accidset group by accountId ]){
        Account acc = new Account ();
        acc.Id = (Id)ar.get('accId');
        acc.ContactsCount__c = (Integer)ar.get('contcount');
        acctsToRollup.add(acc);
    }
    update acctsToRollup;
}