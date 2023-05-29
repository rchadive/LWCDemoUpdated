public class triggerHandler {
    public static void triggerHandlermethod(List<Account> accList){
        set<Id> accountIdSet = new set<Id>();
    Map<Id,double> oppValue = new Map<Id,double>();
    for(Account acc : accList){
        accountIdSet.add(acc.Id);
    }
    
   List<AggregateResult> oppSumList = [Select Sum(Amount) TotalAmount,accountId from Opportunity where accountId IN:accountIdSet Group By accountId];
    
    for(AggregateResult aList : oppSumList){
        Id accountId = (Id)aList.get('accountId');
        double totalamount = (double)aList.get('TotalAmount');
        oppValue.put(accountId, totalamount);
    }
    
    for(Account acc : accList){
        acc.Total_Opportunity_Amount__c = oppValue.get(acc.Id);	
    }
    }
}