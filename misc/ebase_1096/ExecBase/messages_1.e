
MODULE 'utility', 'utility/tagitem'

MODULE '*messages', 'amigalib/ports', 'exec/ports'

CONST PLEASE_QUIT_NOW=TAG_USER, IM_QUITTING=100

PROC main() HANDLE

    DEF message=NIL:PTR TO message_handler, node=NIL:PTR TO message_node, quit=FALSE,
        port=NIL:PTR TO mp

    IF utilitybase:=OpenLibrary('utility.library', 37)

        IF FindPort('example')=NIL

            IF port:=createPort('example', 0)

            NEW message.init(port)

            REPEAT

                message.wait()

                WHILE node:=message.get()

                    IF node.get(PLEASE_QUIT_NOW)=TRUE

                        WriteF('Hey! I got a QUIT message!\n')

                        node.change([PLEASE_QUIT_NOW, IM_QUITTING,
                                     TAG_DONE])

                        quit:=TRUE

                    ENDIF

                    message.reply(node)

                ENDWHILE

            UNTIL quit

            ELSE

                WriteF('Couldn''t create the example port :(\n')

            ENDIF

        ELSE

            WriteF('Messages_1 is already running.\n')

        ENDIF

    ENDIF

EXCEPT DO

    IF utilitybase THEN CloseLibrary(utilitybase)

    IF message THEN END message

    IF port THEN deletePort(port)

ENDPROC
