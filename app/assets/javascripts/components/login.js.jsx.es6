import React from 'react';
import ReactDOM from 'react-dom';

class Login extends React.Component {

  authenticityToken() {
    return document.head.querySelector("[name=csrf-token]").content
  }

  render() {
    return <div id="login-container">
            <div className='pt-card'>
              <form className="new_user" id="new_user" action="/users/sign_in" acceptCharset="UTF-8" method="post">
                <input name="utf8" type="hidden" value="✓" />
                <input type="hidden" name="authenticity_token" value={this.authenticityToken()} />
                <div className="pt-input-group pt-large">
                  <div>
                    <input className="pt-input pt-large pt-fill" autoFocus placeholder="email" type="email" name="user[email]" id="user_email" />
                  </div>
                </div>
                <div className="pt-input-group">
                  <div>
                    <input className="pt-input pt-large pt-fill" placeholder="password" type="password" name="user[password]" id="user_password" />
                  </div>
                </div>
                <div className="pt-input-group">
                  <div>
                    <input type="submit" name="commit" value="Sign In" className="pt-button pt-large pt-fill" data-disable-with="Sign In" />
                  </div>
                </div>
                <br />
                <div>
                  keep me signed in:
                  <input name="user[remember_me]" type="hidden" value="0" />
                  <input type="checkbox" value="1" name="user[remember_me]" id="user_remember_me" />
                </div>
              </form>
            </div>
          </div>;
  }
}

window.Login = Login;
