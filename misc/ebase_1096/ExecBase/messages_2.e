
MODULE 'utility', 'utility/tagitem'

MODULE '*messages', 'exec/ports'

CONST PLEASE_QUIT_NOW=TAG_USER, IM_QUITTING=100

PROC main() HANDLE

    DEF message=NIL:PTR TO message_handler, port=NIL:PTR TO mp

    IF utilitybase:=OpenLibrary('utility.library', 37)

        NEW message.init()

        IF port:=FindPort('example')

            message.send(port, [PLEASE_QUIT_NOW, TRUE,
                                TAG_DONE])

            message.wait_for_value(PLEASE_QUIT_NOW, IM_QUITTING)

            WriteF('Messages_2 received the quit response!\n')

        ELSE

            WriteF('You need to start messages_1 first!\n')

        ENDIF

    ENDIF

EXCEPT DO

    IF utilitybase THEN CloseLibrary(utilitybase)

    IF message THEN END message

ENDPROC
