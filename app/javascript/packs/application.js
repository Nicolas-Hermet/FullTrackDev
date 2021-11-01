// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import 'styles/navbar'
import 'styles/button'
import 'fonts/Montserrat'
import "stylesheets/application";

Rails.start();
Turbolinks.start();
ActiveStorage.start();

import myImageUrl from '../images/nico.png';

let myImage = new Image();
myImage.src = myImageUrl;
myImage.alt = "I'm a Webpacker-bundled image";