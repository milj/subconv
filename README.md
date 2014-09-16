# subconv
Subtitle converter. For now it's only able to convert XML timed text to MicroDVD and SRT.

## Usage

    $ subconv -f microdvd -r 60 input.xml output.txt
    $ subconv -f srt input.xml output.srt

## TODO

translate text position and formatting markup

infer output format from output filename's suffix if -f not specified
