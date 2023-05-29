trigger updateOpprtunity on Account (after Update) {
    set<Id> accIdSet = new Set<Id>();
    DateTime day30=system.now()-30;
    for(Account acc : trigger.new){
        accIdSet.add(acc.Id);
    }
    
    List<Opportunity> oppWithAccounts = [select id,name,createddate from Opportunity where AccountId IN :accIdSet];
    List<Opportunity> oppListToUpdate=new List<Opportunity>();
    for(Opportunity OppList : oppWithAccounts){
        if(OppList.createddate < day30 && OppList.stageName != 'Closed Won'){
            
            OppList.StageName = 'Closed Lost';
            OppList.CloseDate = system.today();
            oppListToUpdate.add(OppList);
        }
    }
    if(oppListToUpdate.size()>0){
        update oppListToUpdate;
    }
}