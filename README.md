# subconv
A very simple subtitle converter. For now it's able to convert ZDF flavour of XML timed text to MicroDVD and SRT (the task it was born for).

## Usage

    $ subconv -f microdvd -r 60 input.xml output.txt
    $ subconv -f srt input.xml output.srt

Example parseable input file is `test/fixtures/1.xml`.

## TODO

Parse other flavours (`2.xml`, `3.xml`)  
Translate text position and formatting markup  
Infer output format from output filename's suffix if -f not specified
