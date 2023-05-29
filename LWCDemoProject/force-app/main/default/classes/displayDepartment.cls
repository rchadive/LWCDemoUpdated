public class displayDepartment {
   public static List<AggregateResult> departmentDetails {get; set;}
    public List<AccWrapper> accWrapList {get; set;}
  
    
     public list<AccWrapper> getListOut() {
      accWrapList = new List<AccWrapper>();
   
      
        AggregateResult[] ar= [Select count(id) Totaldeps,DepartmentCatrgory__c depname from Department__c group by DepartmentCatrgory__c];
        
    
     for(AggregateResult a : ar) {   
            accWrapList.add(
                new AccWrapper(
                    String.valueOf(a.get('depname')),
                    Integer.valueOf(a.get('Totaldeps'))));
        }
 return accWrapList;
    }
    public class AccWrapper {
        public Integer Totaldeps {get;set;}
        public String depname {get;set;}
         
        public AccWrapper(String depname, Integer Totaldeps ) {
            this.Totaldeps =  Totaldeps;
            this.depname = depname;
        }
    }
}