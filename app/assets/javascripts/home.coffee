# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "turbolinks:load", ->
  $("#submit-verify").click ->
    raw = $("#formVerify").serializeArray();
    data = {};
    $(raw).each (i,val) ->
      data[val.name] = val.value
    $.ajax
      url: '/home/verify'
      method: 'post'
      dataType: 'json'
      data: data
      success: (res) ->
        alert(JSON.stringify(res));
        # $("#txhex").val()
        # $("#blockhash1").val()
        # $("#mined").val()
        # $("#size").val()
        # $("#confirmation").val()
        # $("#amount").val()
        # $("#fromaddress").val()
        # $("#toaddress").val()