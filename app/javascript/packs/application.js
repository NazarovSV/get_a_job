// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "bootstrap";
import "packs/location"
import "packs/currency_exchange"
import "filter"
import "pagy"

require("jquery")
require("../stylesheets/application.scss");
require("easy-autocomplete")

Rails.start()
Turbolinks.start()
ActiveStorage.start()

