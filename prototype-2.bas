# include <screen.bas>

'Global Variables
DIM x,y,s,vx,vy AS INTEGER

LET x = 16
LET y = 11
LET s = 0
LET vx = 0
LET vy = 0

Sub updateScore(n AS INTEGER)
    LET s = s+n:
    PRINT AT 0,0;"Score: ";s
End Sub

Sub generateLimes(n AS INTEGER)
    INK 4
    FOR l=1 to n
        PRINT AT INT(RND*20)+1,INT(RND*31);"@"
    NEXT l
End Sub

Sub initScreen()
    BORDER 0
    PAPER 0
    INK 7
    BRIGHT 0
    CLS
    PRINT AT 23,0;"Q/A/O/P - up/down/left/right"
    updateScore(0)
    generateLimes(5)
End Sub

Sub movePlayer()
    LET vx = 0
    LET vy = 0

    LET k$ = INKEY$
    IF k$ = "q" THEN LET vy=-1
    IF k$ = "a" THEN LET vy=1
    IF k$ = "o" THEN LET vx=-1
    IF k$ = "p" THEN LET vx=1

    IF vx <> 0 OR vy <> 0 THEN
        PRINT AT y,x;" "

        LET x = x+vx
        IF x < 0 THEN LET x = 0
        IF x > 31 THEN LET x = 31
        LET y = y+vy
        IF y < 1 THEN LET y = 1
        IF y > 21 THEN LET y = 21

        IF SCREEN$(y,x) = "@" THEN
            updateScore(1)
            generateLimes(1)
        END IF
    END IF
End Sub

initScreen()

'Main Game Loop
While 1
    'Draw Player
    INK 7
    PRINT AT y,x;"A"

    Asm
        halt
        halt
    End Asm

    movePlayer()
    
End While