# airport_information
airport_information is a small Alteryx workflow that generates airport information sheets. The crucial pieces of information I want in front of me while I fly are:
* The runways at the airport, overlayed with a compass ring so I can note winds and active runways
* The elevation of the airport, so I can determine pattern altitude
* The radio frequencies I need to use to communicate and obtain weather information
* A large, structured space for taking notes

This workflow queries a public FAA airport datasource and generates the information I need on a half sheet of paper (the size of my kneeboard). I can fit two airports on a single sheet that is folded in half. This simple sheet frees my iPad to be a fully-dedicated backup navigation device and provides me with a space for noting weather, ATC instructions, etc. The narrowly-focused information section should allow for quicker retrieval of information while in-flight when compared with the kneeboard product I used to use.

Interestingly, this workflow uses a very diverse set of tools that I do not normally interact with. The Python tool is used for querying the FAA airport API, spatial tools are used to generate the runway diagram, and reporting tools are used to create the actual report file output.
