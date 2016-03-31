// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require semantic-ui
//= require_tree .

$(document).ready(function() {
  $(".icon.close").on("click", function() {
    $(this).parents(".ui.flash.message").remove();
  });

  $("#trigger-tab-2015").on('click', function() {
    $(".ui.top.attached.tabular.menu .item").removeClass('active');
    $("#tab-2016").transition('hide');
    $("#tab-2015").transition('show');
    $("#tab-all").transition('hide');
    $(this).parent().addClass('active');
  });

  $("#trigger-tab-2016").on('click', function() {
    $(".ui.top.attached.tabular.menu .item").removeClass('active');
    $("#tab-2015").transition('hide');
    $("#tab-2016").transition('show');
    $("#tab-all").transition('hide');
    $(this).parent().addClass('active');
  });

  $("#trigger-tab-all").on('click', function() {
    $(".ui.top.attached.tabular.menu .item").removeClass('active');
    $("#tab-2015").transition('hide');
    $("#tab-2016").transition('hide');
    $("#tab-all").transition('show');
    $(this).parent().addClass('active');
  });
});
