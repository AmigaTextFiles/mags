OPT MODULE

MODULE 'exec/ports', 'exec/nodes', 'dos/dosextens'

MODULE 'utility', 'utility/tagitem'

EXPORT OBJECT message_handler

    sig

    PRIVATE

    port:PTR TO mp

ENDOBJECT

EXPORT OBJECT message_node OF mn PRIVATE
    
    tags:PTR TO LONG

ENDOBJECT

->> message_handler
PROC init(mp=-1:PTR TO mp) OF message_handler

    DEF t:PTR TO process

    IF mp<>-1

        self.port:=mp

    ELSE

        t:=FindTask(NIL)

        self.port:=t.msgport

    ENDIF

    self.sig:=Shl(1, self.port.sigbit)

ENDPROC

PROC end() OF message_handler

    DEF m:PTR TO message_node

    WHILE m:=self.get() DO self.reply(m)

ENDPROC

PROC wait() OF message_handler IS WaitPort(self.port)

PROC send(target:PTR TO mp, taglist:PTR TO tagitem) OF message_handler

    DEF tm:PTR TO message_node

    NEW tm.init(self.port, taglist)

    PutMsg(target, tm)

ENDPROC

PROC wait_for_value(tag, id) OF message_handler

    DEF m:PTR TO message_node, finish=FALSE

    REPEAT

        self.wait()

        WHILE m:=self.get()

            IF (m.get(tag)=id) THEN finish:=TRUE

            self.reply(m)

        ENDWHILE

    UNTIL (finish=TRUE)

ENDPROC

PROC get() OF message_handler IS GetMsg(self.port)

PROC reply(m:PTR TO message_node) OF message_handler

    IF (m.replyport<>self.port) THEN ReplyMsg(m) ELSE END m

ENDPROC
-><

->> message_node
PROC init(port:PTR TO mp, tags:PTR TO LONG) OF message_node

    self.ln.type:=NT_MESSAGE
    self.length:=SIZEOF message_node
    self.replyport:=port
    self.tags:=tags

ENDPROC

PROC get(tagvalue) OF message_node IS GetTagData(tagvalue, NIL, self.tags)

PROC change(taglist:PTR TO tagitem) OF message_node IS ApplyTagChanges(self.tags, taglist)
-><

