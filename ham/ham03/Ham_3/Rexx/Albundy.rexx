/* Al Bundy - the first prog */
spring = "Lab1 Lab2 Lab3 Lab4 Lab5 Lab6 Lab7 Lab8 Lab9"
Say "1...2...3..End?.. "
say "Hello World!! Hello,here is AL Bundy!!"
say "You are a great,man!!"
OPTIONS PROMPT "Please press 1 or 2 or 3 or 4 or 5 or ? >: "

Loop:
PULL Answer
SIGNAL VALUE WORD(spring,Answer)

Lab1:
SAY "Hey, AL Bundy, you are the greatest!"
SIGNAL VALUE "Loop"

Lab2:
SAY "Hello AL Bundy"
SIGNAL VALUE "Loop"

Lab3:
SAY "How are you ?"
SIGNAL VALUE "Loop"

Lab4:
say "I'm the father of DUMPFBACKE"
SIGNAL VALUE "Loop"

Lab5:
say "I'm the greatest Footballplayer all over the world"
say "Press the right number to quit!"
SIGNAL VALUE "Loop"

Lab6:
say "BYE , BYE"
DO i=1 to 100
end
exit

Lab7:
say "it's wrong!"
SIGNAL VALUE "Loop"

Lab8:
say "it's wrong!"
signal value "Loop"

Lab9:
say "it's wrong!"
signal value "Loop"




