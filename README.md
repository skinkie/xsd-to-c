I have been recently working on a variaty of parser implementations in C.
Most of these parsers were based on XML Schema (XSD) [1].
The majority of the program look the same, it is really boring to make them.
Typically if you design your software in a proper way, a code generator can apply all optimisations for you in an uniform way.

Given that all parser implementations must follow its XSD strictly, such implementation can be expressed as a transformation on the XML Schema.
For the first "bootstrap" version I choose XSLT Transformations (XSLT) [2] to express the first generation of the parser generator.

Due to the limitations of xslt-proc [3], not supporting XSLT 2.0 [4] features such as for-each-group, some optimisations are expressed in C, but must be hand optimised.
Luckily the C compiler of choice will warn the developer if such hand optimisation is required.
Secondary, the order of struct definitions in C it may be required to re-order the output of the transformation manually to fullfill C constraints.


While I am able to write my own C pre/post plane parser [5] in C, I am putting my trust in LibAxl [6].


My ambition for this project is the following;

Given that the bootstrap version only requires a working XSLT 1.0 implementation its result can a 90% implementation of definitive XSD to C parser in C.
The 10% final gap could be hand made, resulting in a clean parser generator.


[1] http://www.w3.org/XML/Schema
[2] http://www.w3.org/TR/xslt
[3] http://xmlsoft.org/XSLT/xsltproc2.html
[4] http://www.w3.org/TR/xslt20/
[5] http://www.ximeco.org/Xime/UpdatingPrePostPlaneManegold.pdf
[6] http://www.aspl.es/xml/
