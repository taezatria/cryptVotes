# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "turbolinks:load", ->
  $("#electvote_card").on "click", ".card", ->
    $("#vote_election_id").val($(this).children("#elec_id").val());
    $.ajax
      url: '/vote/'+$(this).children("#elec_id").val()
      method: 'get'
      dataType: 'json'
      success: (res) ->
        #alert(JSON.stringify(res));
        $("#card_list").html("");
        $(res.candidate).each (i, data) ->
          $("#card_list").append('<div class="card bg-light" style="width:225px"><img class="card-img-top" src="'+data.image+'" alt="Card image"><div class="card-body"><h4 class="card-title">'+res.other[i].name+'</h4><p class="card-text">'+data.description+'</p><div class="custom-control custom-radio text-center"><input type="radio" class="custom-control-input" name="candidate_id" value="'+data.id+'" required><label class="custom-control-label"></label></div></div></div>');
    $("#voteModal").modal('show');

  $("#card_list").on "click", ".card", ->
    ch = $(this).find("input").prop('checked');
    $(this).find("input").prop('checked', !ch);
    $(this).siblings(".card").each ->
      $(this).removeClass('bg-secondary');
      $(this).addClass('bg-light');
    $(this).toggleClass('bg-secondary bg-light');

  $("#verifybutt").click ->
    $("#openverify").val("verify");
    $("#verifyModal").modal('hide');
    $("#passModal").modal('show');

  $("#electverify_card").on "click", "#openbutt",->
    $("#elect_id").val($(this).siblings("#elec_id").val());
    $("#openverify").val("open");
    $("#passModal").modal('show');

  $("#formPass").submit ->
    formPass_check(true);
    raw = $("#formPass").serializeArray();
    data = {};
    $(raw).each (i,val) ->
      data[val.name] = val.value
    $("#passphrase").val("");
    $.ajax
      url: 'vote/verify'
      method: 'post'
      dataType: 'json'
      data: data
      success: (res) ->
        alert(JSON.stringify(res));
        if res.status == 1
          alert("verified");
        else if res.status == 0
          $("#verifyModal").modal('show');
        else
          alert('nil');

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
    voterchangepasswordForm_check(false);

  $("#formPass .passphrase-check").change ->
    if (/^[0-9]{6}$/i).test($(this).val())
      $(this).removeClass("is-invalid");
      $(this).addClass("is-valid");
      $(this).siblings(".valid-feedback").removeAttr("hidden");
      $(this).siblings(".invalid-feedback").attr("hidden", true);    
    else
      $(this).removeClass("is-valid");
      $(this).addClass("is-invalid");
      $(this).siblings(".invalid-feedback").removeAttr("hidden");
      $(this).siblings(".valid-feedback").attr("hidden", true);
    formPass_check(false);
  
  $("#voteForm .passphrase-check").change ->
    if (/^[0-9]{6}$/i).test($(this).val())
      $(this).removeClass("is-invalid");
      $(this).addClass("is-valid");
      $(this).siblings(".valid-feedback").removeAttr("hidden");
      $(this).siblings(".invalid-feedback").attr("hidden", true);    
    else
      $(this).removeClass("is-valid");
      $(this).addClass("is-invalid");
      $(this).siblings(".invalid-feedback").removeAttr("hidden");
      $(this).siblings(".valid-feedback").attr("hidden", true);
    voteForm_check(false);
        
  $("#voterchangepasswordForm").submit ->
    voterchangepasswordForm_check(true);
  
  $("#voteForm").submit ->
    voteForm_check(true);

voterchangepasswordForm_check = ($submit) ->
  if $("#oldpassword").hasClass("is-valid") && $("#newpassword").hasClass("is-valid") && $("#retypepassword").hasClass("is-valid")
    $("#voterchangepasswordForm").children("input[type=submit]").removeAttr("disabled")
  else if $submit
    event.preventDefault();
  else
    $("#voterchangepasswordForm").children("input[type=submit]").attr("disabled",true)

voteForm_check = ($submit) ->
  if $("#passphrase").hasClass("is-valid")
    $("#voteSubmit").removeAttr("disabled")
  else if $submit
    event.preventDefault();
  else
    $("#voteSubmit").attr("disabled",true)

formPass_check = ($submit) ->
  if $("#passphrase").hasClass("is-valid")
    $("#verifySubmit").removeAttr("disabled")
  else if $submit
    event.preventDefault();
  else
    $("#verifySubmit").attr("disabled",true)