trigger CheckDuplicates on Account (after Insert) {
   /*Map<string,Account> accMap = new Map<string,Account>();
    
    for(Account acc : trigger.new){
        
        if(trigger.isInsert || (acc.name != trigger.oldmap.get(acc.id).name)){
            if(accMap.containsKey(acc.Name)){
                acc.addError('Heloo');	
            }else{
               accMap.put(acc.Name, acc) ;
            }
        }
    }
    
    for(Account acc : [select id,name from Account where name IN :accMap.keySet()]){
        Account newAcc = accMap.get(acc.Name);
         newAcc.Name.addError('An account with this name ' + acc.Name + ' already exists.');

	}*/
    if(trigger.isDelete){
       for(Account acc : trigger.old){
        if(acc.active__c == 'yes'){
            acc.adderror('Please stop');
        }
    } 
    }
    List<Contact>conList = new List<contact>();
    set<Id> accId = new set<Id>();
    for(Account acc : trigger.new){
     	Contact cont = new Contact();
        cont.LastName = 'NewLookup';
        cont.AccountId = acc.Id;
        conList.add(cont);
        accId.add(cont.AccountId);
        
    }
    system.debug('conList'+conList);
    if(conList.size()>0){
        insert conList;
        
    }
    Map<Id,Account> mapAccount = new  Map<Id,Account>();
    List<account>newAccList = new List<account>();
   List<Account> accList = [select id,ClientContactLookup__c from Account where Id IN :accId];
    for(Account acc : accList){
        mapAccount.put(acc.Id, acc);
    }
    
    for(Contact conobj: conList){
        if(mapAccount.containsKey(conobj.AccountId)){
            Account acc = mapAccount.get(conobj.AccountId);
            acc.ClientContactLookup__c = conobj.id;
            newAccList.add(acc);
        }
    }
    if(newAccList.size()>0){
        update newAccList;
    }
}