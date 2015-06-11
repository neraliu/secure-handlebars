/*
Copyright (c) 2015, Yahoo Inc. All rights reserved.
Copyrights licensed under the New BSD License.
See the accompanying LICENSE file for terms.

Authors: Nera Liu <neraliu@yahoo-inc.com>
         Albert Yu <albertyu@yahoo-inc.com>
         Adonis Fung <adon@yahoo-inc.com>
*/
(function () {

    mocha = require("mocha");
    var expect = require('chai').expect,
        testPatterns = require('../test-patterns.js'),
        handlebarsParser = require('../../src/handlebars/handlebars-parser.js');

    describe("Handlebars Parser Parsing Test Suite", function() {

        /* Handlebars basic {{expression}} parser test */
        it("handlebars basic {{expression}} parser test", function() {
            testPatterns.expressionParserTestPatterns.forEach(function(testObj) {
                try {
                    var r = handlebarsParser.parse(testObj.syntax);
console.log(r);
                    expect(testObj.result).to.deep.equal(r);
                } catch (e) {
console.log(e);
                }
            });
        });

    });
}());
