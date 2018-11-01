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
        if res.blockhash
          $("#cek").html("verified");
        else
          $("#cek").html("not same block");
        $("#txhex").val(res.tx.hex);
        $("#blockhash1").val(res.tx.blockhash);
        $("#mined").val(res.tx.time);
        $("#data").val(res.tx.data);
        $("#size").val(res.size);
        $("#confirmation").val(res.tx.confirmations);
        $(res.tx.vout).each (i, data) ->
          if data.assets.length > 0
            $("#toaddress").val(data.scriptPubKey.addresses);
            $("#amount").val(data.assets[0].qty);
          else if data.scriptPubKey.addresses != ""
            $("#fromaddress").val(data.scriptPubKey.addresses);