# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "turbolinks:load", ->
  $('.selectpicker').selectpicker();
  $("#add_start_date_").val(new Date().toISOString().substring(0,10));
  $("#add_end_date_").val(new Date().toISOString().substring(0,10));
  $("#add_image").change ->
    $(".custom-file-label").html($(this).val().replace(/C:\\fakepath\\/i, ''));
  $("#edit_image").change ->
    $(".custom-file-label").html($(this).val().replace(/C:\\fakepath\\/i, ''));
  $("#addfile").change ->
    $(".custom-file-label").html($(this).val().replace(/C:\\fakepath\\/i, ''));
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
        $("#edit_election_id").next().children().children().children().html($("#edit_election_id :selected").text());
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
        if data.user.status == 0
          $("#div-start").removeAttr("hidden")
          $("#div-stop").attr("hidden", true)
          $("#btn-stop").attr("disabled", true)
          $("#btn-start").removeAttr("disabled")

          $("#div-anounce").removeAttr("hidden")
          $("#div-count").attr("hidden",true)
          $("#btn-anounce").removeAttr("disabled")
          $("#btn-count").attr("disabled", true)
          $("#add_participants").removeAttr("disabled");
        else if data.user.status == 1
          $("#div-stop").removeAttr("hidden")
          $("#div-start").attr("hidden",true)
          $("#btn-stop").removeAttr("disabled")
          $("#btn-start").attr("disabled", true)

          $("#div-count").attr("hidden", true)
          $("#div-anounce").removeAttr("hidden")
          $("#btn-anounce").removeAttr("disabled")
          $("#btn-count").attr("disabled", true)     
          $("#add_participants").removeAttr("disabled");     
        else
          $("#div-start").removeAttr("hidden")
          $("#div-stop").attr("hidden",true)
          $("#btn-start").attr("disabled",true)
          $("#btn-stop").attr("disabled",true)

          $("#div-count").removeAttr("hidden")
          $("#div-anounce").attr("hidden",true)
          $("#btn-anounce").attr("disabled", true)
          $("#btn-count").removeAttr("disabled") 
          $("#add_participants").attr("disabled", true);

        $("#edit_election_id").val(data.user.id);
        $("#edit_name").val(data.user.name);
        $("#edit_participants").val(data.user.participants);
        $("#edit_description").val(data.user.description);
        $("#edit_start_date_").val(data.other.start_date);
        $("#edit_end_date_").val(data.other.end_date);
        $("#edit_show_image").attr('src', data.user.image);
    $("#editModal").modal('show');

  $("#add_end_date_").change ->
    if $("#add_end_date_").val() <= $("#add_start_date_").val()
      $("#add_end_date_").val($("#add_start_date_").val());

  $("#add_start_date_").change ->
    if $("#add_end_date_").val() <= $("#add_start_date_").val()
      $("#add_end_date_").val($("#add_start_date_").val());
  
  $("#edit_end_date_").change ->
    if $("#edit_end_date_").val() <= $("#edit_start_date_").val()
      $("#edit_end_date_").val($("#edit_start_date_").val());
  
  $("#edit_start_date_").change ->
    if $("#edit_end_date_").val() <= $("#edit_start_date_").val()
      $("#edit_end_date_").val($("#edit_start_date_").val());
  
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
        $("#edit_election_id").next().children().children().children().html($("#edit_election_id :selected").text());
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
        $("#edit_election_id").next().children().children().children().html($("#edit_election_id :selected").text());
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
    reset_addForm();
    $("#add_submit").removeAttr("disabled");

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
    if (/^[a-z0-9 ]{6,50}$/i).test($(this).val())
      $(this).removeClass("is-invalid");
      $(this).addClass("is-valid");
      $(this).siblings(".valid-feedback").removeAttr("hidden");
      $(this).siblings(".invalid-feedback").attr("hidden", true);    
    else
      $(this).removeClass("is-valid");
      $(this).addClass("is-invalid");
      $(this).siblings(".invalid-feedback").removeAttr("hidden");
      $(this).siblings(".valid-feedback").attr("hidden", true);
    form_add_check(false);
  
  $(".username-check").change ->
    if $(this).val() == ""
      $(this).removeClass("is-invalid");
      $(this).removeClass("is-valid");
      $(this).siblings(".invalid-feedback").attr("hidden", true);
      $(this).siblings(".valid-feedback").attr("hidden", true);
    else if (/^[a-z0-9]{6,}$/i).test($(this).val())
      $(this).removeClass("is-invalid");
      $(this).addClass("is-valid");
      $(this).siblings(".valid-feedback").removeAttr("hidden");
      $(this).siblings(".invalid-feedback").attr("hidden", true);    
    else
      $(this).removeClass("is-valid");
      $(this).addClass("is-invalid");
      $(this).siblings(".invalid-feedback").removeAttr("hidden");
      $(this).siblings(".valid-feedback").attr("hidden", true);
    form_edit_check(false);

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
  
  $("#add_email").change ->
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
    form_add_check(false);

  $("#edit_email").change ->
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
    form_edit_check(false);
  
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
    form_add_check(false);
  
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
    form_add_check(false);
  
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

  $("#btn-start").click ->
    raw = $("#form_org_alter").serializeArray();
    data = {};
    data[raw[0].name] = raw[0].value;
    data[raw[1].name] = raw[1].value;
    $.ajax
      url: 'organize/election/'+$("#edit_election_id").val()+'/'+"start"
      method: 'post'
      dataType: 'json'
      data: data
      success: (res) ->
        # alert(JSON.stringify(res));
        window.location.href = '/organize?menu=election'
  $("#btn-stop").click ->
    raw = $("#form_org_alter").serializeArray();
    data = {};
    data[raw[0].name] = raw[0].value;
    data[raw[1].name] = raw[1].value;
    $.ajax
      url: 'organize/election/'+$("#edit_election_id").val()+'/'+"stop"
      method: 'post'
      dataType: 'json'
      data: data
      success: (res) ->
        # alert(JSON.stringify(res));
        window.location.href = '/organize?menu=election'
  $("#btn-count").click ->
    raw = $("#form_org_alter").serializeArray();
    data = {};
    data[raw[0].name] = raw[0].value;
    data[raw[1].name] = raw[1].value;
    $.ajax
      url: 'organize/tally/'+$("#edit_election_id").val()
      method: 'post'
      dataType: 'json'
      data: data
      success: (res) ->
        # alert(JSON.stringify(res));
        window.location.href = '/organize?menu=election'
  $("#btn-anounce").click ->
    raw = $("#form_org_alter").serializeArray();
    data = {};
    data[raw[0].name] = raw[0].value;
    data[raw[1].name] = raw[1].value;
    $.ajax
      url: 'organize/anounce/'+$("#edit_election_id").val()
      method: 'post'
      dataType: 'json'
      data: data
      success: (res) ->
        # alert(JSON.stringify(res));
        window.location.href = '/organize?menu=election'

organizerchangepasswordForm_check = ($submit) ->
  if !$("#oldpassword").hasClass("is-invalid") && !$("#newpassword").hasClass("is-invalid") && !$("#retypepassword").hasClass("is-invalid")
    $("#organizerchangepasswordForm").children("input[type=submit]").removeAttr("disabled")
  else if $submit
    event.preventDefault();
  else
    $("#organizerchangepasswordForm").children("input[type=submit]").attr("disabled",true)

form_add_check = ($submit) ->
  if $("#add_user_id").val() == "0" && !$("#add_name").hasClass("is-invalid") && !$("#add_id_number").hasClass("is-invalid") && !$("#add_email").hasClass("is-invalid") && !$("#add_phone").hasClass("is-invalid")
    $("#add_submit").removeAttr("disabled");
  else if $submit
    event.preventDefault();
  else
    $("#add_submit").attr("disabled",true);

form_edit_check = ($submit) ->
  if !$("#edit_email").hasClass("is-invalid") && !$("#edit_username").hasClass("is-invalid")
    $("#edit_submit").removeAttr("disabled");
  else if $submit
    event.preventDefault();
  else
    $("#edit_submit").attr("disabled",true);

reset_addForm = () ->
  $("#add_name").removeClass("is-valid");
  $("#add_id_number").removeClass("is-valid");
  $("#add_email").removeClass("is-valid");
  $("#add_phone").removeClass("is-valid");

  $("#add_name").removeClass("is-invalid");
  $("#add_id_number").removeClass("is-invalid");
  $("#add_email").removeClass("is-invalid");
  $("#add_phone").removeClass("is-invalid");

  $("#add_name").siblings(".invalid-feedback").attr("hidden", true);
  $("#add_id_number").siblings(".invalid-feedback").attr("hidden", true);
  $("#add_email").siblings(".invalid-feedback").attr("hidden", true);
  $("#add_phone").siblings(".invalid-feedback").attr("hidden", true);

  $("#add_name").siblings(".valid-feedback").attr("hidden", true);
  $("#add_id_number").siblings(".valid-feedback").attr("hidden", true);
  $("#add_email").siblings(".valid-feedback").attr("hidden", true);
  $("#add_phone").siblings(".valid-feedback").attr("hidden", true);