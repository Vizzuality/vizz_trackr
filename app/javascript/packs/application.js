// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require("chartkick")
require("chart.js")

import 'bootstrap';
import 'bootstrap-datepicker';
import 'metismenu';
import '../stylesheets/application';
import "controllers";

$.fn.datepicker.defaults.format = "dd/mm/yyyy";

// Sidebar Menu
$( document ).on('turbolinks:load', function() {
  setTimeout(function () {
    $('.vertical-nav-menu').metisMenu();
  }, 100);


  $('.close-sidebar-btn').click(function () {

    var classToSwitch = $(this).attr('data-class');
    var containerElement = '.app-container';
    $(containerElement).toggleClass(classToSwitch);

    var closeBtn = $(this);

    if (closeBtn.hasClass('is-active')) {
      closeBtn.removeClass('is-active');
    } else {
      closeBtn.addClass('is-active');
    }
  });
});
