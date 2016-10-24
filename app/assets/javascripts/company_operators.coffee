# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $(document).on 'change', '#schemes_select', (evt) ->
    debugger;
    $.ajax 'update_businesses',
      type: 'GET'
      dataType: 'script'
      data: {
        scheme_id: $("#schemes_select option:selected").val(), format: 'js'
      }
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        console.log("Dynamic business select OK!")
