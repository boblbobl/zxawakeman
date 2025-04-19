# Making a ZX Spectrum Game

This repository contain the companion files to the [Making a ZX Spectrum Game](https://boblbobl.com/2020/11/04/making-a-zx-spectrum-game-part-0-defining-the-project/) series on [boblbobl.com](https://boblbobl.com).

The files contained here either require zmakebas or zxbc to compile.

Use the following commands for the Sinclair BASIC examples:

```sh
zmakebas -o out/test.tap  test.bas
zmakebas -o out/colours.tap  colours.bas
zmakebas -o out/prototype-1.tap  prototype-1.bas

```

Use the following commands for the ZXBASIC examples:

```sh
zxbc.py -o out/prototype-2.tap  prototype-2.bas -taB
zxbc.py -o out/prototype-3.tap  prototype-3.bas -taB
zxbc.py -o out/awakeman.tap  awakeman.bas -taB

```