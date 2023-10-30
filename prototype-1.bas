100 REM Init Game
101 LET x = 16
102 LET y = 11
103 LET s = 0

110 BORDER 0

150 REM Generate Limes
151 FOR l=1 to 5
152 PRINT AT INT(RND*20)+1,INT(RND*31);"@"
153 NEXT l

200 REM Main Game Loop
201 PRINT AT y,x;"A"
202 PRINT AT 0,0;"Score: ";s

210 LET vx = 0
211 LET vy = 0

212 LET k$ = INKEY$
213 IF k$ = "q" THEN LET vy=-1
214 IF k$ = "a" THEN LET vy=1
215 IF k$ = "o" THEN LET vx=-1
216 IF k$ = "p" THEN LET vx=1

250 IF vx = 0 AND vy = 0 THEN GOTO 210

260 PRINT AT y,x;" "

270 LET x = x+vx
271 IF x < 0 THEN LET x = 0
272 IF x > 31 THEN LET x = 31
280 LET y = y+vy
281 IF y < 1 THEN LET y = 1
282 IF y > 21 THEN LET y = 21

290 IF SCREEN$(y,x) = "@" THEN LET s = s+1:PRINT AT INT(RND*20)+1,INT(RND*31);"@"
300 GOTO 200