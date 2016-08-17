COSC345 [![Build Status](https://travis-ci.org/NimbleNavigatorsCOSC/COSC345.svg?branch=master)](https://travis-ci.org/NimbleNavigatorsCOSC/COSC345)
========================
A smart watch application prototype using HTML, CSS &amp; Dart

Live Version
------------
A live prebuilt version of this project is available at [https://cosc345.xtansia.com](https://cosc345.xtansia.com)

Group
-----
Group Name: Nimble Navigators

| Name            | ID      | Email                                       | GitHub                                                  |
| --------------- | ------- | ------------------------------------------- | ------------------------------------------------------- |
| Benjaman Dutton | 247060  | dutbe383(at)student(dot)otago(dot)ac(dot)nz | [NimbleNavigators](https://github.com/NimbleNavigators) |
| Allan Tan       | 4288015 | tanal793(at)student(dot)otago(dot)ac(dot)nz | [Arluna](https://github.com/Arluna)                     |
| Thomas Farr     | 5953956 | farth938(at)student(dot)otago(dot)ac(dot)nz | [Xtansia](https://github.com/Xtansia)                   |

Set Up
------
Upon cloning the repository you should run the following to fetch the dependencies

    $ pub get

Building
--------
Building this project requires the Dart SDK installed.
Simply run the following from the base directory.

    $ pub build

The resulting files will be in the build/web directory.

### Serving Directly
Alternatively you can just run the following, to make it accessible at http://localhost:8080

    $ pub serve

### Testing
The project's tests can be run by running the following from the base directory.
As this project is designed to run in a browser, you need to pass the name of the browser 
to run the tests on as an argument.

    $ pub run test -p <dartium|content-shell|chrome|firefox>


Attributions
------------
- [Images](web/assets/img/ATTRIBUTION.md)
- [Sounds](web/assets/sound/ATTRIBUTION.md)