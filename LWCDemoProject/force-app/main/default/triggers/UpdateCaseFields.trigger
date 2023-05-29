trigger UpdateCaseFields on Case (after insert) {
    
    for(Case caseobj: trigger.new){
        if(caseobj.Origin == 'Email'){
            caseobj.Status ='';
            caseobj.Priority = '';
        }
    }
}