Swiby uses the BSD licensed project named MigLayout that implements
a Swing layout manager. The project site is http://www.miglayout.com/

Swiby uses Silk icon set, licencsed under a Creative Commons Attribution 
2.5 License. The project site is http://www.famfamfam.com/lab/icons/silk/


Notes:
*****

1. icons used by Swiby were renamed:

   | Original name    | Renamed to      |
   |------------------+-----------------|
   | wrench           | console         |
   | arrow_refresh    | reload          |
   | arrow_left       | go-previous     |
   | arrow_right      | go-next         |


Tests

Swiby has two type of tests, usual automated test and manual tests.

To run the manual tests, from the Swiby directory:
  jruby -Ilib test/manual/test_all.rb

To run one of the manual test:
  jruby -Ilib test/manual/test_all.rb toggle_test 
or
  jruby -Ilib test/manual/test_all.rb toggle_test.rb

To run several manual tests:
  jruby -Ilib test/manual/test_all.rb check_test toggle_test

