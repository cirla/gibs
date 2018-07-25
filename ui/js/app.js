"use strict";

import 'bootstrap'

import { library, dom } from '@fortawesome/fontawesome-svg-core'
import { fas } from '@fortawesome/free-solid-svg-icons'

require('../css/app.scss');

library.add(fas);
dom.watch();

let Elm = require('../elm/Main.elm');
const elmDiv = document.getElementById('main');

let session = localStorage.getItem('gibs-session');
const elmApp = Elm.Main.embed(elmDiv, {
    session: session
});

elmApp.ports.setSession.subscribe(function (session) {
    localStorage.setItem('gibs-session', JSON.stringify(session));
});
