@RestResource(urlmapping = '/AccountsPost/*')
global class accountRecordsREST {
    
    global static string accountInsert(String Name, string Id){
        Account acc = new Account();
        acc.Name = name;
        acc.Id = id;
        insert acc;
        return acc.Id;
    }

}