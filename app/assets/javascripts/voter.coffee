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

  $("#electvote_card").on "click", ".card", ->
    $("#vote_election_id").val($(this).children("#elec_id").val());
    $.ajax
      url: '/vote/'+$(this).children("#elec_id").val()
      method: 'get'
      dataType: 'json'
      success: (res) ->
        #alert(JSON.stringify(res));
        $(res.candidate).each (i, data) ->
          $("#card_list").append('<div class="card bg-light" style="width:225px"><img class="card-img-top" src="'+data.image+'" alt="Card image"><div class="card-body"><h4 class="card-title">'+res.other[i].name+'</h4><p class="card-text">'+data.description+'</p><div class="custom-control custom-radio text-center"><input type="radio" class="custom-control-input" name="vote_candidate_id" value="'+data.id+'" required><label class="custom-control-label"></label></div></div></div>');
        #$("#card_list").html('<div class="card bg-light" style="width:225px"><img class="card-img-top" src="/assets/default.jpg" alt="Card image"><div class="card-body"><h4 class="card-title">Abstance</h4><p class="card-text">if you dont want to choose anyone</p><div class="custom-control custom-radio text-center"><input type="radio" class="custom-control-input" name="vote_candidate_id" value="0" required><label class="custom-control-label"></label></div></div></div>');
    $("#voteModal").modal('show');

  $("#card_list").on "click", ".card", ->
    ch = $(this).find("input").prop('checked');
    $(this).find("input").prop('checked', !ch);
    $(this).siblings(".card").each ->
      $(this).removeClass('border-primary');
      # $(this).addClass('bg-light');
    $(this).toggleClass('border-primary');
    $("#abstain_vote").removeClass('border-primary');
    $("#abstain_vote").find("input").prop('checked', false);
  
  $("#abstain_vote").click ->
    $("#card_list .card").each ->
      $(this).find("input").prop('checked', false);
      $(this).removeClass('border-primary');
    $(this).toggleClass('border-primary');
    ch = $(this).find("input").prop('checked');
    $(this).find("input").prop('checked', !ch);

  $("#verifybutt").click ->
    $("#openverify").val("verify");
    $("#verifyModal").modal('hide');
    $("#passModal").modal('show');

  $("#electverify_card").on "click", "#openbutt",->
    $("#elect_id").val($(this).siblings("#elec_id").val());
    $("#openverify").val("open");
    $("#passModal").modal('show');

  $("#formPass").submit (event) ->
    event.preventDefault();
    formPass_check(true);
    $("#passModal").modal('hide');
    raw = $("#formPass").serializeArray();
    data = {};
    $(raw).each (i,val) ->
      data[val.name] = val.value
    clear_passphrase();
    data['authenticity_token'] = $('meta[name=csrf-token]').attr('content');
    $.ajax
      url: 'vote/verify'
      method: 'post'
      dataType: 'json'
      data: data
      success: (res) ->
        # console.log(res);
        if res.status == 1
          if res.verifystatus
            if res.counted == null
              $("#isimessage").html('<div class="alert alert-success alert-dismissible fade show" role="alert"><h4 class="alert-heading">Verified</h4><p class="mb-0"> Your ballot is not changed ! </p><button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button></div>');
            else if res.counted
              $("#isimessage").html('<div class="alert alert-success alert-dismissible fade show" role="alert"><h4 class="alert-heading">Verified & Counted</h4><p class="mb-0"> Your ballot is not changed and succeed to be counted ! </p><button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button></div>');
            else
              $("#isimessage").html('<div class="alert alert-danger alert-dismissible fade show" role="alert"><h4 class="alert-heading">NOT COUNTED</h4><p> Your ballot seems to be verified but it is not counted ! </p><hr /><p class="mb-0">Please contact our organizer. </p><button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button></div>');
          else
            $("#isimessage").html('<div class="alert alert-danger alert-dismissible fade show" role="alert"><h4 class="alert-heading">NOT VERIFIED</h4><p> Your ballot has changed ! </p><hr /><p class="mb-0">Please contact our organizer. </p><button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button></div>');
        else if res.status == 0
          $("#verifyModal").modal('show');
          $("#txid").val(res.tx.txid);
          $("#blockhash1").val(res.tx.blockhash);
          $("#data").val(res.tx.data);
          $("#data_img").prop("src", res.other.image)
          $("#data_text").html(res.other.description);
          $("#data_title").html(res.other.name);
          $(res.tx.vout).each (i, data) ->
            if data.assets.length > 0
              $("#toaddress").val(data.scriptPubKey.addresses);
            else if data.scriptPubKey.addresses != ""
              $("#fromaddress").val(data.scriptPubKey.addresses);
        else
          alert('input is not valid');

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
  
  $("#voteForm").submit (event) ->
    voteForm_check(true);
    event.preventDefault();
    raw = $("#voteForm").serializeArray();
    data = {}
    $(raw).each (i,val) ->
      data[val.name] = val.value
    clear_passphrase();
    data['authenticity_token'] = $('meta[name=csrf-token]').attr('content');
    $encrypt = new JSEncrypt();
    $encrypt.setPublicKey($('#pbkey').val());
    $encrypted = $encrypt.encrypt($("input[name=vote_candidate_id]:checked").val());
    data['vote_candidate_id'] = $encrypted;
    $.ajax
      url: 'vote'
      method: 'post'
      dataType: 'json'
      data: data
      success: (res) ->
        window.location.href = 'voter?menu=vote'

voterchangepasswordForm_check = ($submit) ->
  if !$("#oldpassword").hasClass("is-invalid") && !$("#newpassword").hasClass("is-invalid") && !$("#retypepassword").hasClass("is-invalid")
    $("#voterchangepasswordForm").children("input[type=submit]").removeAttr("disabled")
  else if $submit
    event.preventDefault();
  else
    $("#voterchangepasswordForm").children("input[type=submit]").attr("disabled",true)

voteForm_check = ($submit) ->
  if !$("#passphrase").hasClass("is-invalid")
    $("#voteSubmit").removeAttr("disabled")
  else if $submit
    event.preventDefault();
  else
    $("#voteSubmit").attr("disabled",true)

formPass_check = ($submit) ->
  if !$("#passphrase").hasClass("is-invalid")
    $("#verifySubmit").removeAttr("disabled")
  else if $submit
    event.preventDefault();
  else
    $("#verifySubmit").attr("disabled",true)

clear_passphrase = () ->
  $("#passphrase").val("");
  $("#passphrase").removeClass("is-invalid");
  $("#passphrase").removeClass("is-valid");
  $("#passphrase").siblings(".valid-feedback").removeAttr("hidden");
  $("#passphrase").siblings(".invalid-feedback").removeAttr("hidden"); 
