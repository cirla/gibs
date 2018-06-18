"use strict";

import 'bootstrap'

import fontawesome from '@fortawesome/fontawesome';
import faSolid from '@fortawesome/fontawesome-free-solid'

require('../css/app.scss');

var Elm = require('../elm/Main.elm');
const elmDiv = document.getElementById('main');
const elmApp = Elm.Main.embed(elmDiv);
