trigger OpportunityLineItemTrigger on OpportunityLineItem (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    Set<Id> opportunityIdSet = new Set<Id>();
    List<Opportunity> oppToUpdate = new List<Opportunity>();

    if (trigger.isAfter && trigger.isInsert) {
        for (OpportunityLineItem oli : trigger.new) {
            if (oli.Status__c == 'Delivered') {
                opportunityIdSet.add(oli.OpportunityId);
            }
        }
    }


    if (trigger.isAfter && trigger.isUpdate) {
        for (OpportunityLineItem oli : trigger.new) {
            if (oli.Status__c == 'Delivered' && oli.Status__c != trigger.oldMap.get(oli.Id).Status__c) {
                opportunityIdSet.add(oli.OpportunityId);
            }
        }
    }

    if (!opportunityIdSet.isEmpty()) {
        for (Opportunity opp : [SELECT Id, StageName, (SELECT Id FROM OpportunityLineItems WHERE Status__c != 'Delivered') FROM Opportunity WHERE Id IN: opportunityIdSet]) {
            if (opp.OpportunityLineItems.isEmpty()) {
                opp.StageName = 'Closed Won';
                oppToUpdate.add(opp);
            }
        }
    }

    if (!oppToUpdate.isEmpty()) {
        UPDATE oppToUpdate;
    }
}