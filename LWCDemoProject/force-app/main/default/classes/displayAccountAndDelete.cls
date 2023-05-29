public class displayAccountAndDelete {
    
    @Auraenabled
    public static List<Account> displayAccountsDelete(){       
        List<Account> accList =[select id, name from Account limit 50] ;  
        system.debug('accList'+accList);
        return accList;
    }
    
    @Auraenabled
    public static void deleteAccounts(string accId){       
        List<Account> accList =[select id, name from Account where Id=:accId limit 50] ;        
        delete accList;
    }

}