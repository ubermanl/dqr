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
//= require jquery.turbolinks
//= require jquery_ujs
//= require semantic-ui
//= require turbolinks
//= require chartist
//= require_tree .

$(document).ready(function(){
   $('.ui.sidebar').sidebar({ context: $('.bottom.segment')});
   $('.menu-toggle').on('click',function(){
        console.log($('.ui.sidebar').length);
        $('.ui.sidebar').sidebar('toggle');
   });
   
   new Chartist.Line('.ct-chart', {
        labels: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
        series: [
          [12, 9, 7, 8, 5],
          [2, 1, 3.5, 7, 3],
          [1, 3, 4, 5, 6]
        ]
      }, {
        fullWidth: true,
        chartPadding: {
          right: 40
        }
      });
   
});

