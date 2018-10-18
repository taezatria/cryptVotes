# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $("tr").on "click", "#modalEditButton", ->
    $.ajax
      url: 'organize/'+$(this).siblings("#menu").val()+'/'+$(this).siblings("#user_id").val()+'/'+$(this).siblings("#other_id").val()
      method: 'get'
      dataType: 'json'
      success: (data) ->
        $("#edit_user_id").val(data.user.id);
        $("#edit_org_id").val(data.other.id);
        $("#edit_election_id").val(data.other.election_id);
        $("#edit_access_right_id").val(data.other.access_right_id);
        $("#edit_name").val(data.user.name);
        $("#edit_id_number").val(data.user.idNumber);
        $("#edit_email").val(data.user.email);
        $("#edit_phone").val(data.user.phone);
        $("#edit_username").val(data.user.username);
        $("#edit_address").val(data.user.address);
        $("#edit_public_key").val(data.user.publicKey);

  $("tr").on "click", "#modalDeleteButton", ->
    $("#delete_org_id").val($(this).siblings("#other_id").val());