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
 */

public with sharing class AccountAssignmentBatchable implements Database.Batchable<Account> {

    public static String systemAccountOwnerAlias = 'sysadmin';

    public Iterable<Account> start(Database.BatchableContext bc) {

        List<Account> Records = [SELECT Id, Name, OwnerId, BillingCountry FROM Account WHERE Owner.Alias=:systemAccountOwnerAlias];
            return REcords;
    }

    public void execute(Database.BatchableContext bc, List<SObject> objects) {

        Integer amirCap = 30;
        Integer sarahCap = 20;
        Integer bobCap = 10;

        Integer amirNum = 0;
        Integer sarahNum = 0;
        Integer bobNum = 0;

        // Look up our user Ids
        Id amirId = [SELECT Id from User WHERE Alias = 'amir' AND IsActive = true].Id;
        Id bobId = [SELECT Id from User WHERE Alias = 'bob' AND IsActive = true].Id;
        Id sarahId = [SELECT Id from User WHERE Alias = 'sarah' AND IsActive = true].Id;

        // Loop through the accounts and assign US/Canada ones to sales users until they reach their cap
        List<Account> accounts = new List<Account>();
        for (Object o : objects) {
            Account a = (Account)o;

            if (a.BillingCountry == 'USA' || a.BillingCountry == 'Canada') {

                if (amirNum < amirCap) {
                    amirNum++;
                    a.OwnerId = amirId;
                }
                else if (sarahNum < sarahCap) {
                    sarahNum++;
                    a.OwnerId = sarahId;
                }
                else if (bobNum < bobCap) {
                    bobNum++;
                    a.OwnerId = bobId;
                }
            }
            accounts.add(a);
        }

        update(accounts);
    }

    public void finish(Database.BatchableContext bc) { }

}