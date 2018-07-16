Wsave
=====

Wsave is (will be) a web crawler and web data format processing program.

It is currently in development.


Supported task summary
----------------------

TODO: list features


Getting started
---------------

### Installation

TODO: make and link to releases

### Usage

TODO: write and link to manual


Development
-----------

### API

Wsave uses an accompanying library [Plumekit](https://github.com/chfoo/plumekit) for driving its main functionality. Developers may wish to use it directly for their own needs.

### Compiling

You will need:

* Haxe 3/4

Compile using Haxe:

    haxe hxml/app.js.hxml
    haxe hxml/app.cpp.hxml

Output will be placed in the `out/` directory.

TODO: renaming/packaging/installing binaries


### Testing

Test using:

    haxe hxml/test.js.hxml  # run test.html in browser
    haxe hxml/test.cpp.hxml && out/cpp/test/TestAll-debug


Copyright
---------

Copyright (C) 2018 Christopher Foo. Licensed under [GPL 3](LICENSE.txt).
