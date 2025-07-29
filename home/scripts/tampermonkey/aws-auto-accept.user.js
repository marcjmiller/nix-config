// ==UserScript==
// @name         AWS Auto-Accept
// @description  Automatically accepts Auth request
// @namespace
// @version      1.0
// @author       marcjmiller
// @match        https://login.afwerx.dso.mil/*
// @match        https://login.gamewarden.io/*
// @match        https://login.dso.mil/*
// @match        https://d-9067aa9977.awsapps.com/*
// @match        https://device.sso.us-gov-east-1.amazonaws.com/*
// @match        https://start.us-gov-east-1.us-gov-home.awsapps.com/*
// @grant        none
// ==/UserScript==

(function () {
  "use strict";

  setTimeout(() => {
    if (document.getElementById("cli_verification_btn")) {
      document.getElementById("cli_verification_btn").click();
    }
  }, 2000);

  setTimeout(() => {
    if (document.getElementById("kc-accept")) {
      document.getElementById("kc-accept").click();
    }
  }, 2000);

  setTimeout(() => {
    if (
      document.querySelector('button[data-analytics="consent-allow-access"]')
    ) {
      document
        .querySelector('button[data-analytics="consent-allow-access"]')
        .click();
    }
  }, 4000);
})();
