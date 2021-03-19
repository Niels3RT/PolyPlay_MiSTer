## Introduction

This is the Poly-Play arcade from East Germany for the [MiSTer board](https://github.com/MiSTer-devel).

All information taken from [mame/polyplay.cpp](https://github.com/mamedev/mame/blob/master/src/mame/drivers/polyplay.cpp). Many thanks to Martin Buchholz and all the other contributors.

Heavily based on the [KC87](https://github.com/beokim/kc87fpga) and [KC85/4](https://github.com/beokim/kc854fpga) cores by beokim.

See https://en.wikipedia.org/wiki/Poly_Play

## The MiSTer Core

There is a lot of guesswork going on (clocks, video). Analog video should be good now, at least my flatscreen tv accepts the rgb+composite sync output.

The romsets (polyplay.zip/polyplay2.zip) should come from mame 0229.

First button is fire, second button coin.

## Light Organ

The original hardware features a "light organ" on top of the cabinet, basically a row of colored lightbulbs. On MiSTer there are 3 modes for it:

1. use the 3 LEDs on MiSTer
1. the ext. DS8205D setting outputs the signals to user port bits 2:0 that were passed to a DS8205 on original hardware. 74xx137 are functionally identical and could be used for a modern recreation.
1. off, ignore it

## The Copyright Notice that came with the Sources of the KC87 and KC85/4 cores

Copyright (c) 2015, $ME
All rights reserved.

Redistribution and use in source and synthezised forms, with or without modification, are permitted 
provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions 
   and the following disclaimer.

2. Redistributions in synthezised form must reproduce the above copyright notice, this list of conditions
   and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED 
WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR 
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED 
TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING 
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
POSSIBILITY OF SUCH DAMAGE.
