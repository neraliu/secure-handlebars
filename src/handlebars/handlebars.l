/*
Copyright (c) 2015, Yahoo Inc. All rights reserved.
Copyrights licensed under the New BSD License.
See the accompanying LICENSE file for terms.

Authors: Nera Liu <neraliu@yahoo-inc.com, neraliu@gmail.com>

Lexical definition of Handlebars for Safe JS Templating

Reference:
- https://handlebarsjs.com

*/

h		[0-9a-fA-F]						
digit           [0-9]
alphabat        [a-fA-F]

s		[ \t\r\n\f]+
w		{s}?
nl		\n|\r\n|\r|\f

%%

{s}			{return 'S';}

"{{{""}}}"              {return 'RAWEXPRESSION';}

.			{return 'CONTENT';}
