"use strict";

import 'bootstrap'

import fontawesome from '@fortawesome/fontawesome';
import faSolid from '@fortawesome/fontawesome-free-solid'

require('../css/app.scss');

let Elm = require('../elm/Main.elm');
const elmDiv = document.getElementById('main');

let session = localStorage.getItem('gibs-session');
const elmApp = Elm.Main.embed(elmDiv, {
    session: session
});

elmApp.ports.setSession.subscribe(function (session) {
    localStorage.setItem('gibs-session', session);
});
