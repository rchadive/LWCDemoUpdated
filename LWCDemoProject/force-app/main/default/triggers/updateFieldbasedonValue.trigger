trigger updateFieldbasedonValue on Opportunity (before update) {
    
    for(Opportunity Opp : trigger.new){
        
        if(opp.StageName != trigger.oldmap.get(Opp.Id).StageName){
            if(opp.StageName == 'Closed Won' || opp.StageName =='Closed Lost'){
                
                opp.Triggertest__c = opp.CloseDate;                
            }
            
        }
        
    }

}