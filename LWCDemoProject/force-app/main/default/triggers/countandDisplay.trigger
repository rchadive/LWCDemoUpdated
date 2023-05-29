trigger countandDisplay on OpportunityLineItem (after insert,after update) {
    Set<Id> oliId = new Set<Id>();
    Map<id,String> mapIdString = new Map<id,String>();
  
    List<Opportunity>  oppList1 = new List<Opportunity> ();
    if(trigger.isInsert){
        
         for(opportunityLineItem OLI : trigger.new){  
             if(!mapIdString.containsKey(OLI.opportunityId)){
                 mapIdString.put(OLI.opportunityId,OLI.Name);
             }else{
                string str = mapIdString.get(OLI.opportunityId);
                mapIdString.put(OLI.opportunityId,str+OLI.Name);
             }    
    		}
 
    /*List<AggregateResult> aList =[Select Count(id)cId, name from OpportunityLineItem where opportunityid IN :mapIdString.keySet() GROUP BY name];
    system.debug('aList'+aList);
    for(AggregateResult ar : aList){
        
        Opportunity opp = new Opportunity();
        	opp.CountProducts__c = (Integer)(ar.get('cId'));
        	opp.Id = (Id)(ar.get('oId'));
        	opp.ProductNames__c = (String)(ar.get('name'));
        	oppList.add(opp);
    }*/
    for(Opportunity oppty: [select id,CountProducts__c,ProductNames__c,(select id from Opportunitylineitems) from Opportunity where Id IN :mapIdString.keySet()])
        {
            oppty.CountProducts__c = oppty.Opportunitylineitems.size();
            if(oppty.ProductNames__c !='' || oppty.ProductNames__c != null){
              oppty.ProductNames__c = oppty.ProductNames__c + mapIdString.get(oppty.Id)+';';  
            }else{
              oppty.ProductNames__c =   mapIdString.get(oppty.Id)+';';
            }
            	
            oppList1.add(oppty);
        }
    }
     update oppList1;
    Map<id,Map<String,String>> mapOldList = new Map<id,Map<String,String>>();
		Map<String,String> strMap = new Map<String,String>();
    if(trigger.isUpdate || trigger.isDelete){
        if(trigger.isUpdate){
            for(opportunityLineItem OLI1 : trigger.new){
                Opportunitylineitem oldOLI = trigger.oldmap.get(OLI1.id);
                String newName = OLI1.name;
                String oldName = oldOLI.Name;
                if(newName!=oldName){
                    strMap.put(oldname,newname);
                    mapOldList.Put(OLI1.opportunityId,strMap);
                }
            }
        }else{
            for(opportunityLineItem OLI1 : trigger.old){
               String OldName =  OLI1.name;
                strMap.put(oldname,'');
                mapOldList.Put(OLI1.opportunityId,strMap);
                
            }
        }
    }
    for(Opportunity Opp :[select id,CountProducts__c,ProductNames__c,(select id from Opportunitylineitems) from Opportunity where Id IN :mapIdString.keySet() ])
    {
        if(mapOldList.containsKey(opp.Id)){
            for(Map<String,String> mpStr : mapOldList.values()){
                if(Opp.ProductNames__c!=null && Opp.ProductNames__c!=''){
                    List<String> lstAlpha = Opp.ProductNames__c.split(';');
                 for(String str : lstAlpha){
                      if(mpStr.containsKey(str)){
                          if(trigger.isUpdate){
                              Opp.ProductNames__c = Opp.ProductNames__c.replace(str,mpStr.get(str));
                          	  Opp.CountProducts__c = Opp.Opportunitylineitems.size();
                            

                          }
                          else if(trigger.isDelete) {
                            Opp.ProductNames__c =   Opp.ProductNames__c.replace(str+';',mpStr.get(str));  
                          	Opp.CountProducts__c = Opp.Opportunitylineitems.size();  
                          }
                            
                            oppList1.add(Opp)  ;
                      }
                     
                 }
            }
        }
    }
}
    update oppList1;
}