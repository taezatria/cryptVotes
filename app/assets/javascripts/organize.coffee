# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $("tr").on "click", "#modalEditButton", ->
    $.ajax
      url: 'organize/organizer/'+$(this).siblings("#organizer_id").val()
      method: 'get'
      dataType: 'json'
      success: (data) ->
        alert(data);
        console.log(data);