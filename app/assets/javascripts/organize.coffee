# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "turbolinks:load", ->
  $("#tbody_organizer").on "click", "tr", ->
    $("#delete_org_id").val($(this).children("#other_id").val());
    $.ajax
      url: 'organize/'+$(this).children("#menu").val()+'/'+$(this).children("#user_id").val()+'/'+$(this).children("#other_id").val()
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
    $("#editModal").modal('show');

  $("#tbody_access_right").on "click", "tr", ->
    $("#delete_ar_id").val($(this).children("#access_right_id").val());
    $("#edit_ar_id").val($(this).children("#ar_id").html());
    $("#edit_name").val($(this).children("#ar_name").html());
    $("#editModal").modal('show');
  
  $("#tbody_election").on "click", "tr", ->
    $("#delete_election_id").val($(this).children("#election_id").val());
    $.ajax
      url: 'organize/'+$(this).children("#menu").val()+'/'+$(this).children("#election_id").val()+'/election'
      method: 'get'
      dataType: 'json'
      success: (data) ->
        $("#edit_election_id").val(data.user.id);
        $("#edit_name").val(data.user.name);
        $("#edit_participants").val(data.user.participants);
        $("#edit_description").val(data.user.description);
        $("#edit_start_date_").val(data.other.start_date);
        $("#edit_end_date_").val(data.other.end_date);
        $("#edit_show_image").attr('src', data.user.image);
    $("#editModal").modal('show');
  
  $("#tbody_voter").on "click", "tr", ->
    $("#delete_voter_id").val($(this).children("#other_id").val());
    $.ajax
      url: 'organize/'+$(this).children("#menu").val()+'/'+$(this).children("#user_id").val()+'/'+$(this).children("#other_id").val()
      method: 'get'
      dataType: 'json'
      success: (data) ->
        $("#edit_user_id").val(data.user.id);
        $("#edit_voter_id").val(data.other.id);
        $("#edit_election_id").val(data.other.election_id);
        $("#edit_name").val(data.user.name);
        $("#edit_id_number").val(data.user.idNumber);
        $("#edit_email").val(data.user.email);
        $("#edit_phone").val(data.user.phone);
        $("#edit_username").val(data.user.username);
        $("#edit_address").val(data.user.address);
        $("#edit_public_key").val(data.user.publicKey);
        $("#edit_hasattend").prop('checked', data.other.hasAttend);
        $("#edit_hasvote").prop('checked', data.other.hasVote);
    $("#editModal").modal('show');

  $("#tbody_candidate").on "click", "tr", ->
    $("#delete_candidate_id").val($(this).children("#other_id").val());
    $.ajax
      url: 'organize/'+$(this).children("#menu").val()+'/'+$(this).children("#user_id").val()+'/'+$(this).children("#other_id").val()
      method: 'get'
      dataType: 'json'
      success: (data) ->
        $("#edit_user_id").val(data.user.id);
        $("#edit_candidate_id").val(data.other.id);
        $("#edit_election_id").val(data.other.election_id);
        $("#edit_name").val(data.user.name);
        $("#edit_id_number").val(data.user.idNumber);
        $("#edit_email").val(data.user.email);
        $("#edit_phone").val(data.user.phone);
        $("#edit_username").val(data.user.username);
        $("#edit_description").val(data.other.description);
        $("#edit_address").val(data.user.address);
        $("#edit_public_key").val(data.user.publicKey);
        $("#edit_show_image").attr('src', data.other.image);
    $("#editModal").modal('show');
   