({
	doInit : function(component, event, helper) {
		var accListdisplay = component.get("c.displayAccountsDelete");
        accListdisplay.setCallback(this,function(response){
            var state = response.getState();
            var reposnevalue = response.getReturnValue();

        if(state === 'SUCCESS'){
            component.set("v.accList",reposnevalue)
        }
        else{
            alert('Error fetching data');
        }
        });
        $A.enqueueAction(accListdisplay);
	},
    handleClick : function(component, event, helper) {
        var recordId = event.getSource().get("v.value");
		var acctodelete = component.get("c.deleteAccounts");
        acctodelete.setParams({
            accId:event.target.id
        });
        acctodelete.setCallback(this,function(response){
            var state = response.getState();
            var reposnevalue = response.getReturnValue();

            component.set("v.accList",reposnevalue)
       
        });
        $A.enqueueAction(acctodelete);
	}
})