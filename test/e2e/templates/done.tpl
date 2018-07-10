{{#> cdnLayout}}
// OIDC Redirect Flow - this is the page that is redirected to with
// tokens in the parameters

function addMessageToPage(id, msg) {
  var appNode = document.createElement('div');
  appNode.setAttribute('id', id);
  appNode.innerHTML = msg;
  document.body.appendChild(appNode);
}

var oktaSignIn = new OktaSignIn({
  'baseUrl': '{{{WIDGET_TEST_SERVER}}}',
  'clientId': '{{{WIDGET_CLIENT_ID}}}'
});
addMessageToPage('page', 'oidc_app');


/**
 * Upon redirecting back to the application via callback URI
 * "/done", tokens must be parsed via the hash fragment.
 *   - parseTokens: Manually handle the success/error handlers
 *   - parseTokensWithDefaultHandlers: Use oktaSignIn's default handlers
 */
function parseTokens() {
  if (oktaSignIn.token.hasTokensInUrl()) {
    oktaSignIn.token.parseTokensFromUrl(
      function (res) {
        addMessageToPage('idtoken_user', res.claims.name);
      },
      function (err) {
        addMessageToPage('oidc_error', JSON.stringify(err));
      }
    );
  }
}

function parseTokensWithDefaultHandlers() {
  if (oktaSignIn.token.hasTokensInUrl()) {
    oktaSignIn.token.parseTokensFromUrl()
    .then(function() {
      var idToken = oktaSignIn.tokenManager.get('idToken');
      addMessageToPage('idtoken_user', idToken.claims.name);
    });
  }
}
{{/cdnLayout}}
