/*
Handlebars Grammar for Safe JS Templating

Reference:
- https://handlebarsjs.com
- https://github.com/wycats/handlebars.js/blob/master/src/handlebars.yy
*/

%start root

%ebnf

%%

root
  : program EOF { return $1; }
  ;

program
  : statement* -> $1
  ;

statement
  : mustache -> $1
  | block -> $1
  | rawBlock -> $1
  | partial -> $1
  | content -> $1
  | COMMENT -> $1
  ;

content
  : CONTENT
    %{
      $$ = {};
      $$.type = 'html';
      $$.content = $1;
      $$.startPos = 0; // TODO: @$
    %}
  ;

rawBlock
  : openRawBlock content END_RAW_BLOCK
    %{
      $$ = {};
      $$.type = 'rawblock';
      $$.content = $1;
      $$.content += $2.content !== undefined? $2.content: '';
      $$.content += "{{{{/"+$3+"}}}}";
      $$.startPos = 0; // TODO: @$
    %}
  ;

openRawBlock
  : OPEN_RAW_BLOCK helperName param* hash? CLOSE_RAW_BLOCK
    %{
      $$ = $1;
      if (typeof $2 === 'string') {
        $$ += $2;
      } else {
        // TODO 
      }     
      $$ += $5;
    %}
  ;

closeBlock
  : OPEN_ENDBLOCK helperName CLOSE
    %{
      $$ = $1;
      if (typeof $2 === 'string') {
        $$ += $2;
      } else {
        // TODO 
      }     
      $$ += $3;
    %}
  ;

mustache
  : OPEN helperName param* hash? CLOSE
    %{
      $$ = {};
      $$.type = 'escapeexpression';
      $$.content = $1;
      if (typeof $2 === 'string') {
        $$.content += $2;
      } else {
        // TODO 
      }
      $$.content += $5;
      $$.startPos = 0; // TODO: @$
    %}
  | OPEN_UNESCAPED helperName param* hash? CLOSE_UNESCAPED
    %{
      $$ = {};
      $$.type = 'rawexpression';
      $$.content = $1;
      if (typeof $2 === 'string') {
        $$.content += $2;
      } else {
        // TODO 
      }
      $$.content += $5;
      $$.startPos = 0; // TODO: @$
    %}
  ;

partial
  : OPEN_PARTIAL partialName param* hash? CLOSE
    %{
      $$ = {};
      $$.type = 'expression';
      $$.content = $1;
      if (typeof $2 === 'string') {
        $$.content += $2;
      } else {
        // TODO 
      }
      $$.content += $5;
      $$.startPos = 0; // TODO: @$
    %}
  ;

partialName
  : helperName -> $1
  | sexpr -> $1
  ;

param
  : helperName -> $1
  | sexpr -> $1
  ;

sexpr
  : OPEN_SEXPR helperName param* hash? CLOSE_SEXPR
    %{
      $$ = {};
      $$.helper = $2;
      $$.params = $3 !== undefined? $3: '';
      $$.hash = $4 !== undefined? $4: '';
    %}
  ;

hash
  : hashSegment+
    %{
      $$ = {};
      $$ = $1;
    %}
  ;

hashSegment
  : ID EQUALS param 
    %{
      $$ = {};
      $$.id = $1;
      $$.sign = $2;
      $$.param = $3;
    %}
  ;

helperName
  : path -> $1
  | dataName -> $1
  | STRING -> $1
  | NUMBER -> $1
  | BOOLEAN -> $1
  | UNDEFINED -> $1
  | NULL -> $1
  ;

dataName
  : DATA pathSegments
    %{
      $$ = {};
      $$.data = $1;
      $$.pathSegments = $2; 
    %}
  ;

path
  : pathSegments -> $1
  ;

pathSegments
  : pathSegments SEP ID
    %{
      $$ = {};
      $$.pathSegments = $1;
      $$.separator = $2;
      $$.id = $3;
    %}
  | ID -> $1
  ;

/*
blockParams
  : OPEN_BLOCK_PARAMS ID+ CLOSE_BLOCK_PARAMS -> yy.id($2)
  ;
*/
