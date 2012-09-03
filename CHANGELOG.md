## 0.3.0 (2012.9.01)

Major gem revisions:

* Interpolation class moved to Interpolate::Points
* Binary search to find the correct interpolation interval
* Optional blending function block can be passed to Interpolate::Points
* gemspec file completely rebuilt, sans Jeweler

## 0.2.4 (2011.4.10)

* Project cleanup: minor updates to the lib/ file structure and documentation

## 0.2.2 (2008.2.4)

* Single source file has been split into class files
* Tests now use `freeze`
* Better edge case testing in the `Array` and `Numeric` `interpolate` methods

## 0.2.1 (2008.1.27)

First public release

Project Cleanup:

* Documentation enhancements and updates.
* `add` is now `merge`

## 0.2.0 (2008.1.24)

* Changed the library name to "interpolate"
* Added `Array#interpolate` that covers uniform arrays and nested arrays
* Added more tests, documentation, and examples

## 0.1.0 (2008.1.22)

2 Major Changes:

* Gradient calls `interpolate` on values for OOP goodness
* Checks added for `respond_to?(:interpolate)` on values
* Added `Numeric#interpolate`

## 0.0.1 (2008.1.20)

* Initial coding
* N-sized arbitrary floating point gradients

