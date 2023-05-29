public class displayAccounts {
    public  List<Account> accList {get; set;} 
    public displayAccounts(){
      accList = new List<Account>([Select id, name,Phone from Account]);  
    }

}