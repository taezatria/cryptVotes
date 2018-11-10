# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "turbolinks:load", ->
  $("#user_role").change ->
    if $("#user_role").val() == "0"
      window.location.href = "/voter?role=0";
    else if $("#user_role").val() == "1"
      window.location.href = "/organize?role=1"
    else if $("#user_role").val() == "-1"
      window.location.href = "/organize?role=-1"

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
        $("#edit_admin").prop("checked", data.other.admin);
        $("#edit_name").val(data.user.name);
        $("#edit_id_number").val(data.user.idNumber);
        $("#edit_email").val(data.user.email);
        $("#edit_phone").val(data.user.phone);
        $("#edit_username").val(data.user.username);
        $("#edit_address").val(data.user.addressKey);
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
        $("#edit_address").val(data.user.addressKey);
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
        $("#edit_show_image").attr('src', data.other.image);
    $("#editModal").modal('show');
  
  $("#add_user_id").change ->
    if $(this).val() == "0"
      $("#add_name").removeAttr("readonly");
      $("#add_id_number").removeAttr("readonly");
      $("#add_email").removeAttr("readonly");
      $("#add_phone").removeAttr("readonly");
      $("#add_name").val("");
      $("#add_id_number").val("");
      $("#add_email").val("");
      $("#add_phone").val("");
    else
      $.ajax
        url: 'organize/user/'+$(this).val()+'/0'
        method: 'get'
        dataType: 'json'
        success: (data) ->
          $("#add_name").attr("readonly",true);
          $("#add_id_number").attr("readonly",true);
          $("#add_email").attr("readonly",true);
          $("#add_phone").attr("readonly",true);
          $("#add_name").val(data.user.name);
          $("#add_id_number").val(data.user.idNumber);
          $("#add_email").val(data.user.email);
          $("#add_phone").val(data.user.phone);

  $("#voter_search").keyup ->
    # alert('searching...');
    $search = $(this).val();
    if $(this).val() == ""
      $search = "all";
    $.ajax
      url: 'organize/voter/search/'+$search
      method: 'get'
      dataType: 'json'
      success: (data) ->
        $("#tbody_voter").html("");
        $(data.other).each (i, value1) ->
          $(data.user).each (i, value2) ->
            if value1.user_id == value2.id
              $("#tbody_voter").append('<tr><input type="hidden" id="menu" value="voter"><input type="hidden" id="user_id" value="'+value2.id+'"><input type="hidden" id="other_id" value="'+value1.id+'"><td>'+value1.election_id+'</td><td>'+value2.name+'</td><td>'+value2.idNumber+'</td><td>'+value2.email+'</td><td>'+value2.username+'</td><td>'+value1.hasAttend+'</td><td>'+value1.hasVote+'</td></tr>');
              return false;

  $("#voter_searchid").keyup ->
    # alert('searching...');
    $search = $(this).val();
    if $(this).val() == ""
      $search = "all";
    $.ajax
      url: 'organize/voter/searchid/'+$search
      method: 'get'
      dataType: 'json'
      success: (data) ->
        $("#tbody_voter").html("");
        $(data.other).each (i, value1) ->
          $(data.user).each (i, value2) ->
            if value1.user_id == value2.id
              $("#tbody_voter").append('<tr><input type="hidden" id="menu" value="voter"><input type="hidden" id="user_id" value="'+value2.id+'"><input type="hidden" id="other_id" value="'+value1.id+'"><td>'+value1.election_id+'</td><td>'+value2.name+'</td><td>'+value2.idNumber+'</td><td>'+value2.email+'</td><td>'+value2.username+'</td><td>'+value1.hasAttend+'</td><td>'+value1.hasVote+'</td></tr>');
              return false;

  $("#voter_searchel").change ->
    # alert('searching...');
    $search = $(this).val();
    if $(this).val() == "0"
      $search = "all";
    $.ajax
      url: 'organize/voter/filter/'+$search
      method: 'get'
      dataType: 'json'
      success: (data) ->
        $("#tbody_voter").html("");
        $(data.other).each (i, value1) ->
          $(data.user).each (i, value2) ->
            if value1.user_id == value2.id
              $("#tbody_voter").append('<tr><input type="hidden" id="menu" value="voter"><input type="hidden" id="user_id" value="'+value2.id+'"><input type="hidden" id="other_id" value="'+value1.id+'"><td>'+value1.election_id+'</td><td>'+value2.name+'</td><td>'+value2.idNumber+'</td><td>'+value2.email+'</td><td>'+value2.username+'</td><td>'+value1.hasAttend+'</td><td>'+value1.hasVote+'</td></tr>');
              return false;

  $("#candidate_search").keyup ->
    # alert('searching...');
    $search = $(this).val();
    if $(this).val() == ""
      $search = "all";
    $.ajax
      url: 'organize/candidate/search/'+$search
      method: 'get'
      dataType: 'json'
      success: (data) ->
        $("#tbody_candidate").html("");
        $(data.other).each (i, value1) ->
          $(data.user).each (i, value2) ->
            if value1.user_id == value2.id
              $("#tbody_candidate").append('<tr><input type="hidden" id="menu" value="candidate"><input type="hidden" id="user_id" value="'+value2.id+'"><input type="hidden" id="other_id" value="'+value1.id+'"><td>'+value1.election_id+'</td><td>'+value2.name+'</td><td>'+value2.idNumber+'</td><td>'+value2.email+'</td><td>'+value2.username+'</td></tr>');
              return false;

  $("#candidate_searchid").keyup ->
    # alert('searching...');
    $search = $(this).val();
    if $(this).val() == ""
      $search = "all";
    $.ajax
      url: 'organize/candidate/searchid/'+$search
      method: 'get'
      dataType: 'json'
      success: (data) ->
        $("#tbody_candidate").html("");
        $(data.other).each (i, value1) ->
          $(data.user).each (i, value2) ->
            if value1.user_id == value2.id
              $("#tbody_candidate").append('<tr><input type="hidden" id="menu" value="candidate"><input type="hidden" id="user_id" value="'+value2.id+'"><input type="hidden" id="other_id" value="'+value1.id+'"><td>'+value1.election_id+'</td><td>'+value2.name+'</td><td>'+value2.idNumber+'</td><td>'+value2.email+'</td><td>'+value2.username+'</td></tr>');
              return false;

  $("#candidate_searchel").change ->
    # alert('searching...');
    $search = $(this).val();
    if $(this).val() == "0"
      $search = "all";
    $.ajax
      url: 'organize/candidate/filter/'+$search
      method: 'get'
      dataType: 'json'
      success: (data) ->
        $("#tbody_candidate").html("");
        $(data.other).each (i, value1) ->
          $(data.user).each (i, value2) ->
            if value1.user_id == value2.id
              $("#tbody_candidate").append('<tr><input type="hidden" id="menu" value="candidate"><input type="hidden" id="user_id" value="'+value2.id+'"><input type="hidden" id="other_id" value="'+value1.id+'"><td>'+value1.election_id+'</td><td>'+value2.name+'</td><td>'+value2.idNumber+'</td><td>'+value2.email+'</td><td>'+value2.username+'</td></tr>');
              return false;

  $("#organizer_search").keyup ->
    # alert('searching...');
    $search = $(this).val();
    if $(this).val() == ""
      $search = "all";
    $.ajax
      url: 'organize/organizer/search/'+$search
      method: 'get'
      dataType: 'json'
      success: (data) ->
        $("#tbody_organizer").html("");
        $(data.other).each (i, value1) ->
          $(data.user).each (i, value2) ->
            if value1.user_id == value2.id
              $("#tbody_organizer").append('<tr><input type="hidden" id="menu" value="organizer"><input type="hidden" id="user_id" value="'+value2.id+'"><input type="hidden" id="other_id" value="'+value1.id+'"><td>'+value1.election_id+'</td><td>'+value2.name+'</td><td>'+value2.idNumber+'</td><td>'+value2.email+'</td><td>'+value2.username+'</td></tr>');
              return false;

  $("#organizer_searchid").keyup ->
    # alert('searching...');
    $search = $(this).val();
    if $(this).val() == ""
      $search = "all";
    $.ajax
      url: 'organize/organizer/searchid/'+$search
      method: 'get'
      dataType: 'json'
      success: (data) ->
        $("#tbody_organizer").html("");
        $(data.other).each (i, value1) ->
          $(data.user).each (i, value2) ->
            if value1.user_id == value2.id
              $("#tbody_organizer").append('<tr><input type="hidden" id="menu" value="organizer"><input type="hidden" id="user_id" value="'+value2.id+'"><input type="hidden" id="other_id" value="'+value1.id+'"><td>'+value1.election_id+'</td><td>'+value2.name+'</td><td>'+value2.idNumber+'</td><td>'+value2.email+'</td><td>'+value2.username+'</td></tr>');
              return false;

  $("#organizer_searchel").change ->
    # alert('searching...');
    $search = $(this).val();
    if $(this).val() == "0"
      $search = "all";
    $.ajax
      url: 'organize/organizer/filter/'+$search
      method: 'get'
      dataType: 'json'
      success: (data) ->
        $("#tbody_organizer").html("");
        $(data.other).each (i, value1) ->
          $(data.user).each (i, value2) ->
            if value1.user_id == value2.id
              $("#tbody_organizer").append('<tr><input type="hidden" id="menu" value="organizer"><input type="hidden" id="user_id" value="'+value2.id+'"><input type="hidden" id="other_id" value="'+value1.id+'"><td>'+value1.election_id+'</td><td>'+value2.name+'</td><td>'+value2.idNumber+'</td><td>'+value2.email+'</td><td>'+value2.username+'</td></tr>');
              return false;

  $("#election_search").keyup ->
    # alert('searching...');
    $search = $(this).val();
    if $(this).val() == ""
      $search = "all";
    $.ajax
      url: 'organize/election/search/'+$search
      method: 'get'
      dataType: 'json'
      success: (data) ->
        $("#tbody_election").html("");
        $(data.user).each (i, value) ->
          $sd = new Date(value.start_date).toDateString();
          $ed = new Date(value.end_date).toDateString();
          $("#tbody_election").append('<tr><input type="hidden" id="menu" value="election"><input type="hidden" id="election_id" value="'+value.id+'"><td>'+value.name+'</td><td>'+value.description+'</td><td>'+$sd+'</td><td>'+$ed+'</td><td>'+value.participants+'</td></tr>');

  $(".name-check").change ->
    if (/^[a-z ]{6,50}$/i).test($(this).val())
      $(this).removeClass("is-invalid");
      $(this).addClass("is-valid");
      $(this).siblings(".valid-feedback").removeAttr("hidden");
      $(this).siblings(".invalid-feedback").attr("hidden", true);    
    else
      $(this).removeClass("is-valid");
      $(this).addClass("is-invalid");
      $(this).siblings(".invalid-feedback").removeAttr("hidden");
      $(this).siblings(".valid-feedback").attr("hidden", true);
  
  $(".username-check").change ->
    if (/^[a-z0-9]{6,}$/i).test($(this).val())
      $(this).removeClass("is-invalid");
      $(this).addClass("is-valid");
      $(this).siblings(".valid-feedback").removeAttr("hidden");
      $(this).siblings(".invalid-feedback").attr("hidden", true);    
    else
      $(this).removeClass("is-valid");
      $(this).addClass("is-invalid");
      $(this).siblings(".invalid-feedback").removeAttr("hidden");
      $(this).siblings(".valid-feedback").attr("hidden", true);

  $(".password-check").change ->
    if (/^[a-z0-9]{8,}$/i).test($(this).val())
      $(this).removeClass("is-invalid");
      $(this).addClass("is-valid");
      $(this).siblings(".valid-feedback").removeAttr("hidden");
      $(this).siblings(".invalid-feedback").attr("hidden", true);    
    else
      $(this).removeClass("is-valid");
      $(this).addClass("is-invalid");
      $(this).siblings(".invalid-feedback").removeAttr("hidden");
      $(this).siblings(".valid-feedback").attr("hidden", true);
    organizerchangepasswordForm_check(false);
  
  $(".email-check").change ->
    $re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    if $re.test($(this).val())
      $(this).removeClass("is-invalid");
      $(this).addClass("is-valid");
      $(this).siblings(".valid-feedback").removeAttr("hidden");
      $(this).siblings(".invalid-feedback").attr("hidden", true);    
    else
      $(this).removeClass("is-valid");
      $(this).addClass("is-invalid");
      $(this).siblings(".invalid-feedback").removeAttr("hidden");
      $(this).siblings(".valid-feedback").attr("hidden", true);
  
  $(".idnumber-check").change ->
    if (/^[a-z]{0,1}[0-9]{6,}$/i).test($(this).val())
      $(this).removeClass("is-invalid");
      $(this).addClass("is-valid");
      $(this).siblings(".valid-feedback").removeAttr("hidden");
      $(this).siblings(".invalid-feedback").attr("hidden", true);    
    else
      $(this).removeClass("is-valid");
      $(this).addClass("is-invalid");
      $(this).siblings(".invalid-feedback").removeAttr("hidden");
      $(this).siblings(".valid-feedback").attr("hidden", true);
  
  $(".phone-check").change ->
    if (/^[0-9-]{6,}$/i).test($(this).val())
      $(this).removeClass("is-invalid");
      $(this).addClass("is-valid");
      $(this).siblings(".valid-feedback").removeAttr("hidden");
      $(this).siblings(".invalid-feedback").attr("hidden", true);    
    else
      $(this).removeClass("is-valid");
      $(this).addClass("is-invalid");
      $(this).siblings(".invalid-feedback").removeAttr("hidden");
      $(this).siblings(".valid-feedback").attr("hidden", true);
  
  $(".number-check").change ->
    if (/^[0-9]+$/i).test($(this).val())
      $(this).removeClass("is-invalid");
      $(this).addClass("is-valid");
      $(this).siblings(".valid-feedback").removeAttr("hidden");
      $(this).siblings(".invalid-feedback").attr("hidden", true);    
    else
      $(this).removeClass("is-valid");
      $(this).addClass("is-invalid");
      $(this).siblings(".invalid-feedback").removeAttr("hidden");
      $(this).siblings(".valid-feedback").attr("hidden", true);

  $("#organizerchangepasswordForm").submit ->
    organizerchangepasswordForm_check(true);

organizerchangepasswordForm_check = ($submit) ->
  if $("#oldpassword").hasClass("is-valid") && $("#newpassword").hasClass("is-valid") && $("#retypepassword").hasClass("is-valid")
    $("#organizerchangepasswordForm").children("input[type=submit]").removeAttr("disabled")
  else if $submit
    event.preventDefault();
  else
    $("#organizerchangepasswordForm").children("input[type=submit]").attr("disabled",true)