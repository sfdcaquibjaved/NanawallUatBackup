// Full Circle Response Reanimator, V1.8, 11/13/15
trigger FC_ResponseReanimatorTrigger on CampaignMember (after insert) {
    FC_ResponseReanimator.requestHandler(trigger.newMap);
}