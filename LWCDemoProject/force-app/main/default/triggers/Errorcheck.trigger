trigger Errorcheck on Opportunity (before update) {
    set<Id> oppIds = new set<Id>();
        Map<Id,Opportunity> mapcollec = new Map<Id,Opportunity>();
    for(Opportunity opp: trigger.new){
        oppIds.add(opp.Id);
    }

  List<Opportunity> OpprelatedList =[select id,stageName,(select id from OpportunityLineItems) from Opportunity where Id In: oppIds];
    for(Opportunity opp: OpprelatedList){
        if(opp.OpportunityLineItems.size()>0){
            mapcollec.put(opp.Id,opp);
        }
    }
         for(Opportunity Opp : trigger.new){
             if(mapcollec.containsKey(Opp.Id)){
                    if(opp.stageName != trigger.oldmap.get(opp.Id).stageName){
           				 opp.adderror('Please donot change');             }
     
        		}
    		}
    }