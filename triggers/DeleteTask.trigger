trigger DeleteTask on Attachment (after insert) {
    set<id> projectId = new set<id>();
    for(Attachment att:trigger.new){
        string str = att.ParentId;
            system.debug(str);
            if((str.length()>2) && (str.substring(0,3)=='a1s')){
                projectId.add(att.ParentId);
            }
    }
    list<task> taskListToDelete = new list<task>();
    for(task tk :[select id,Subject ,WhatId from task where whatId IN:projectId]){
        if(tk.Subject.startswith('Email:')){
            taskListToDelete.add(tk);
        }
    }
    if(taskListToDelete.size()>0){
        delete taskListToDelete;
    }
}