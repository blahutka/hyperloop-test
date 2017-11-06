ReactDOM = require('react-dom');
React = require('react');
createReactClass = require('create-react-class');

Sticky = require('react-stickynode');

ReactRouter = require('react-router');
ReactRouterDOM = require('react-router-dom');
History = require('history');

Sem = require('semantic-ui-react');

ReactTimeAgo = require('react-timeago').default;

Tokenizer = {
  parse: function( props ) {
    var parseText = props.parseText;
    var parsers = props.parsers;
    var deftok = props.deftok;

    var m, r, l, t, tokens = [];
    while ( parseText ) {
      t = null;
      m = parseText.length;
      for ( var key in parsers ) {
        r = parsers[ key ].exec( parseText );
        // try to choose the best match if there are several
        // where "best" is the closest to the current starting point
        if ( r && ( r.index < m ) ) {
          t = {
            token: r[ 0 ],
            type: key,
            matches: r.slice( 1 )
          }
          m = r.index;
        }
      }
      if ( m ) {
        // there is text between last token and currently
        // matched token - push that out as default or "unknown"
        tokens.push({
          token : parseText.substr( 0, m ),
          type  : deftok || 'unknown'
        });
      }
      if ( t ) {
        // push current token onto sequence
        tokens.push( t );
      }
      parseText = parseText.substr( m + (t ? t.token.length : 0) );
    }
    return tokens;
  }
}

console.log('All imported JS libs loaded (c_and_s.js)')
