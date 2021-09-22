@IsTest
public with sharing class AccountAssignmentBatchableTest {

    static testmethod void testBehavior() {

        // Create test account
        Id sysAdminId = [SELECT Id FROM User WHERE Alias = 'sysadmin'].Id;
        Account a = new Account(Name = 'Test Account', BillingCountry = 'USA', OwnerId = sysAdminId);
        insert(a);

        // Run the job
        AccountAssignmentBatchable job = new AccountAssignmentBatchable();
        Iterable<Account> recs = job.start(null);
        job.execute(null, (List<SObject>) recs);
        job.finish(null);

        // Make sure it was assigned to Amir
        Id amirId = [SELECT Id from User WHERE Alias = 'amir' AND IsActive = true].Id;
        a = [SELECT Id, OwnerId FROM Account WHERE Id = :a.Id];
        System.assertEquals(amirId, a.OwnerId);
    }

}