trigger UpdateTaskToAttchements on Task(After insert) {

    Map < id, id > MapProTaskId = new Map < id, id > ();
    list < task > deleteList = new list < task > ();
    list < note > insertNote = new list < note > ();
    set < task > taskListToDelete = new set < task > ();
    list < attachment > updateListAttach = new list < attachment > ();
    if (trigger.isInsert && trigger.isAfter) {
        for (task tsk: trigger.new) {
            //check the Subject with email 
            if (tsk.Subject.startswith('Email:')) {
                string str = tsk.WhatId;

                //check if it project then only it process down
                if (str!=null && (str.length() > 2) && (str.substring(0, 3) == 'a1s')) {
                    MapProTaskId.put(tsk.id, tsk.WhatId);

                    note n = new note();
                    n.body = tsk.Description;
                    n.Title = tsk.Subject;
                    n.ParentId = tsk.WhatId;
                    insertNote.add(n);
                    deleteList.add(tsk);
                }

            }
        }
        //loop through task ids and get the attachements and create new attachments.
        if(MapProTaskId.keyset().size()>0){
        list < attachment > attach = [select id, name, ContentType, body, parentId from attachment where parentId IN: MapProTaskId.keyset()];
        if (attach.size() > 0) {
            for (attachment attc: attach) {
                attachment att = new attachment();
                att.Name = attc.name;
                att.Body = attc.body;
                att.ContentType = attc.ContentType;
                att.parentId = MapProTaskId.get(attc.parentId);
                updateListAttach.add(att);
            }
        }
        }
        if (updateListAttach.size() > 0) {
            list < Database.SaveResult > srList = Database.insert(updateListAttach, false);
            for (Database.SaveResult sr: srList) {
                if (sr.isSuccess()) {

                    for (task tk: [select id, Subject, WhatId from task where id IN: deleteList]) {
                        if (tk.Subject.startswith('Email:')) {
                            taskListToDelete.add(tk);
                        }
                    }

                }
            }
        }

        if (insertNote.size() > 0) {
            list < Database.SaveResult > srList = Database.insert(insertNote, false);
            for (Database.SaveResult sr: srList) {
                if (sr.isSuccess()) {

                    for (task tk: [select id, Subject, WhatId from task where id IN: deleteList]) {
                        if (tk.Subject.startswith('Email:')) {
                            taskListToDelete.add(tk);
                        }
                    }

                }
            }
        }
        if (taskListToDelete.size() > 0) {
            list<task> dTask = new list<task>();
            dTask.addall(taskListToDelete);
            delete dTask;
        }


    }
}