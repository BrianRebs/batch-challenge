/**
 * Batch job (runs daily) to take US and Canada Accounts currently owned by the system user, and reassign
 * them to Sales users based on their daily caps. However it's not well written, and it has a
 * couple of bugs.
 *
 * TODOs:
 * 1. This job doesn't work right when there is more than one batch -- sales users get assigned
 *    more accounts than their daily cap allows. Fix that.
 * 2. The assignments aren't evenly distributed when there are fewer Accounts to assign than
 *    there is capacity. Fix that.
 * 3. A new Sales user Joe has been added to the team with a cap of 5, update as needed to include him. 
 * 4. Update the code to follow best practices for scalability, maintainability, and testing.
 *    You may add files or config if needed -- if you add config provide specifics. Do whatever YOU
 *    think will make this better. Assume it will be in use for several years as the company grows.
 * 5. Please include comments explaining any assumptions you have made.

    Actions:
    1. Get Admin by Id Instead of Alias ✅
    2. Get a better record scope with drilled down query ✅
    3. Imporving scalability of users removing the hardcoded ones and gettting them through profileId ✅
    4. Creating a User custom field "Cap_Size__c" - package.xml
    5. Distribute algorithm 
    6. 
    
 */

global with sharing class AccountAssignmentBatchable implements Database.Batchable<sObject> {

    String systemAccountOwnerId = '00000000000xXXXXXX';

    String query = 'SELECT Id, OwnerId, BillingCountry FROM Account WHERE OwnerId =:systemAccountOwnerId AND (BillingCountry = 'USA' or BillingCountry = 'Canada')';

    global Database.Querylocator start(Database.BatchableContext bc) {

        return Database.getQuery(query);

    }

    global void execute(Database.BatchableContext bc, List<SObject> objects) {

    Map<String, User> UserAndCapSize = new Map<String, User>();

    List<User> iterableUsers =  new List<User>([Select Id, Cap_Size__c From User WHERE ProfileId = '00000000000xXXXXXX']);
    
        for (User usr : iterableUsers ){
    
	    UserAndCapSize.put(usr.Id, usr);    

        }
	
    List<Account> accounts = new List<Account>();
        
            

    accounts.add(a);
     

    update(accounts);
    }
    

    global void finish(Database.BatchableContext bc) { }
}




