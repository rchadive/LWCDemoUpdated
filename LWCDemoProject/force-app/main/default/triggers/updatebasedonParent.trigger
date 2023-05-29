trigger updatebasedonParent on OpportunityLineItem (before insert) {
Set<Id> oppIds = new Set<Id>();

for(opportunityLineItem OLi : trigger.new){
		if(OLI.opportunityId != null){
			oppIds.add(OLI.opportunityId);
		}
}
    
List<opportunity> childwithValues = [Select id,ComissionPercentage__c, (select id from opportunitylineitems) from opportunity Where Id In:oppIds ];
    Map<Id,decimal> oppMap = new  Map<Id,decimal> ();
    for(opportunity opp : childwithValues){
        if(opp.ComissionPercentage__c != null){
            oppMap.put(opp.id,opp.ComissionPercentage__c);
        }
    }
    
    for(opportunityLineItem OLi : trigger.new)
        OLi.ComissionPercentage__c = oppMap.get(OLI.OpportunityId);
    }