trigger updateParentOpp on Account (before update) {
    Switch on trigger.operationtype{
        when Before_update{
            triggerHandler.triggerHandlermethod(trigger.new);
        }
    }
    
}