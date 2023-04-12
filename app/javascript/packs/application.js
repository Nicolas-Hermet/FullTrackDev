// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "../css/application"
import './main-template'
import './richtext'
import './embed'

require.context("../../assets/images", true)


Rails.start()
Turbolinks.start()
ActiveStorage.start()

require("trix")
require("@rails/actiontext")

import "controllers"


document.addEventListener('DOMContentLoaded', () => {
  const categorySelect = document.getElementById('category-select');

  if (categorySelect) {
    categorySelect.addEventListener('change', (event) => {
      const category = event.target.value;
      const url = `/articles/filter_by_category?category=${category}`;

      Rails.ajax({
        url,
        type: 'GET',
        dataType: 'script',
      });
    });
  }
});