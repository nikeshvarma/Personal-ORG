public without sharing class DeleteDupContacts implements Database.Batchable<SObject>, Schedulable {
    
    public Iterable<AggregateResult> start(Database.BatchableContext BC) {
        return [SELECT Email FROM Contact WHERE Email != NULL GROUP BY Email HAVING COUNT(Email) > 1];
    }

    public void execute(Database.BatchableContext BC, List<AggregateResult> contacts) {
        
        Map<String, Contact> uniqueContactMap = new Map<String, Contact>();
        Set<String> duplicateEmails = new Set<String>();
        List<Contact> conToDelete = new List<Contact>();

        for (AggregateResult res : contacts) {
            duplicateEmails.add((String) res.get('Email'));
        }

        for (Contact con : [SELECT Id, Email FROM Contact WHERE Email IN: duplicateEmails]) {
            if (uniqueContactMap.containsKey(con.Email)) {
                conToDelete.add(con);
            } else {
                uniqueContactMap.put(con.Email, con);
            }
        }

        DELETE conToDelete;
    }

    public void finish(Database.BatchableContext BC) {
        
    }

    public void execute(SchedulableContext SC) {

    }
}