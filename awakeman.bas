#include once "fsp2.1.bas"
#include once "spritesheet.bas"

'Global Variables
Dim pX,pY,pStep,pFacing,vx,vy as Byte
Dim s as uInteger

Let pX = 16
Let pY = 11
Let vx = 0
Let vy = 0
Let s = 0

Dim limeX, limeY as uByte

Dim limes(23,30) as uByte

Dim udg (7) as uByte => {0, 60, 102, 255, 255, 126, 60, 0}

Sub updateScore(n as uInteger)
    Let s = s+n:
    Ink 7
    Print At 0,0;"Score: ";s
End Sub

Sub doStep () 
	pStep = pStep + 1: If pStep = 4 Then pStep = 0: End If
End Sub

Sub generateLimes(n as uByte)
    Ink 4
    For l=1 To n
        Let limeY = Int(Rnd*20)+1
        Let limeX = Int(Rnd*30)+1
        limes(limeY, limeX) = 1
        Print At limeY,limeX;Chr$(144)
    Next l
End Sub

Sub eatLimeAt(y as uByte, x as uByte)
    limes(y,x) = 0
    Print At y,x;" "
    updateScore(1)
    generateLimes(1)
End Sub

Sub initScreen()
    Border 0: Paper 0: Ink 7: Bright 0: Cls
    Print At 23,0;"Q/A/O/P - up/down/left/right"
    Poke uInteger 23675, @udg (0)

    'Setup Fourspriter
    fsp21SetGfxAddress(@spritesheet (0))
    fsp21SetGfxSprite(3, 0, 1, 2, 3)
    fsp21ColourSprite(3, 7, 7, 7, 7)
    fsp21MoveSprite(3, pX, pY)
    fsp21DuplicateCoordinatesSprite(3)
    fsp21ActivateSprite(3)
    fsp21InitSprites()

    updateScore(0)
    generateLimes(5)
End Sub

Sub movePlayer()
    Let vx = 0
    Let vy = 0

    Let k$ = INKEY$
    If k$ = "q" Then Let vy=-1:pFacing=16
    If k$ = "a" Then Let vy=1:pFacing=0
    If k$ = "o" Then Let vx=-1:pFacing=48
    If k$ = "p" Then Let vx=1:pFacing=32

    If vx <> 0 OR vy <> 0 Then
        
        doStep()

        LET pX = pX+vx
        If pX < 1 Then Let pX = 0
        If pX > 30 Then Let pX = 30
        Let pY = pY+vy
        If pY < 1 Then Let pY = 1
        If pY > 21 Then Let pY = 21

        If limes(pY,pX) = 1 Then eatLimeAt(pY,pX)
        If limes(pY+1,pX) = 1 Then eatLimeAt(pY+1,pX)
        If limes(pY,pX+1) = 1 Then eatLimeAt(pY,pX+1)
        If limes(pY+1,pX+1) = 1 Then eatLimeAt(pY+1,pX+1)
        
    END IF
End Sub

Sub updatesFrame()
   If pStep = 0 Then
      fsp21SetGfxSprite(3, pFacing, pFacing + 1, pFacing + 2, pFacing + 3)
   ElseIf pStep = 1 Or pStep = 3 Then
      fsp21SetGfxSprite(3, pFacing + 4, pFacing + 5, pFacing + 6, pFacing + 7)
   Else
      fsp21SetGfxSprite(3, pFacing + 8, pFacing + 9, pFacing + 10, pFacing + 11)
   End If
End Sub

initScreen()

'Main Game Loop
Do    
    Asm
        halt
        halt
    End Asm

    movePlayer()

    'Draw Player
    updatesFrame()
    fsp21MoveSprite(3, pX, pY)
    fsp21UpdateSprites()
Loop