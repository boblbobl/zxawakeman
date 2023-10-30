'Global Variables
Dim x,y,vx,vy as Byte
Dim s as uInteger

Let x = 16
Let y = 11
Let s = 0
Let vx = 0
Let vy = 0

Dim limeX, limeY as uByte

Dim limes(23,30) as uByte

Dim udg (7) as uByte => {0, 60, 102, 255, 255, 126, 60, 0}

Sub updateScore(n as uInteger)
    Let s = s+n:
    Print At 0,0;"Score: ";s
End Sub

Sub generateLimes(n as uByte)
    Ink 4
    For l=1 To n
        Let limeY = INT(RND*20)+1
        Let limeX = INT(RND*31)
        limes(limeY, limeX) = 1
        Print At limeY,limeX;CHR$(144)
    Next l
End Sub

Sub initScreen()
    Border 0: Paper 0: Ink 7: Bright 0: Cls
    Print At 23,0;"Q/A/O/P - up/down/left/right"
    Poke uInteger 23675, @udg (0)
    updateScore(0)
    generateLimes(5)
End Sub

Sub movePlayer()
    Let vx = 0
    Let vy = 0

    Let k$ = INKEY$
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

        If limes(y,x) = 1 Then
            limes(y,x) = 0
            updateScore(1)
            generateLimes(1)
        End If
    END IF
End Sub

initScreen()

'Main Game Loop
Do
    'Draw Player
    Ink 7
    Print At y,x;"A"

    Asm
        halt
        halt
    End Asm

    movePlayer()
    
Loop