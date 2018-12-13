# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "turbolinks:load", ->
  $("#submit-verify").click ->
    raw = $("#formVerify").serializeArray();
    data = {};
    $(raw).each (i,val) ->
      data[val.name] = val.value

    data['authenticity_token'] = $('meta[name=csrf-token]').attr('content');
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

  $("#loginForm #username").change ->
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
    loginForm_check(false);
  
  $("#loginForm #password").change ->
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
    loginForm_check(false);
  
  $("#setupForm #password").change ->
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
    setupForm_check(false);
  
  $("#setupForm #username").change ->
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
    setupForm_check(false);
  
  $("#verifyemail").change ->
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
    regisEmailForm_check(false);
  
  $("#email").change ->
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
    registerForm_check(false);
  
  $("#name").change ->
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
    registerForm_check(false);
  
  $("#idnumber").change ->
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
    registerForm_check(false);
  
  $("#phone").change ->
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
    registerForm_check(false);

  $("#setupForm #passphrase").change ->
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
    setupForm_check(false);

  $("#resetPasswordForm .password-check").change ->
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
    resetPasswordForm_check(false);
  
  $("#resetPassphraseForm #passphrase").change ->
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
    resetPassphraseForm_check(false);

  $("#word_button").click ->
    raw = $("#regisEmailForm").serializeArray();
    data = {};
    $(raw).each (i,val) ->
      data[val.name] = val.value
    data['authenticity_token'] = $('meta[name=csrf-token]').attr('content');
    $.ajax
      url: '/home/forget'
      method: 'post'
      dataType: 'json'
      data: data
      window.location.href = "/"

  $("#phrase_button").click ->
    raw = $("#regisEmailForm").serializeArray();
    data = {};
    $(raw).each (i,val) ->
      data[val.name] = val.value
    data['authenticity_token'] = $('meta[name=csrf-token]').attr('content');
    $.ajax
      url: '/home/genkey'
      method: 'post'
      dataType: 'json'
      data: data
      window.location.href = "/"
  
  $("#loginForm").submit ->
    loginForm_check(true);
  
  $("#regisEmailForm").submit ->
    regisEmailForm_check(true);
  
  $("#registerForm").submit ->
    registerForm_check(true);
  
  $("#setupForm").submit ->
    setupForm_check(true);

  $("#resetPasswordForm").submit ->
    resetPasswordForm_check(true);
  
  $("#resetPassphraseForm").submit ->
    resetPassphraseForm_check(true);

loginForm_check = ($submit) ->
  if !$("#username").hasClass("is-invalid") && !$("#password").hasClass("is-invalid")
    $("#loginForm").children("input[type=submit]").removeAttr("disabled")
  else if $submit
    event.preventDefault();
  else
    $("#loginForm").children("input[type=submit]").attr("disabled",true)

regisEmailForm_check = ($submit) ->
  if !$("#verifyemail").hasClass("is-invalid")
    $("#regisEmailForm").children("input[type=submit]").removeAttr("disabled")
    $("#word_button").removeAttr("disabled")
    $("#phrase_button").removeAttr("disabled")
  else if $submit
    event.preventDefault();
  else
    $("#regisEmailForm").children("input[type=submit]").attr("disabled",true)
    $("#word_button").attr("disabled", true)
    $("#phrase_button").attr("disabled", true)

registerForm_check = ($submit) ->
  if !$("#name").hasClass("is-invalid") && !$("#idnumber").hasClass("is-invalid") && !$("#email").hasClass("is-invalid") && !$("#phone").hasClass("is-invalid")
    $("#registerForm").children("input[type=submit]").removeAttr("disabled")
  else if $submit
    event.preventDefault();
  else
    $("#registerForm").children("input[type=submit]").attr("disabled",true)

setupForm_check = ($submit) ->
  if !$("#username").hasClass("is-invalid") && !$("#password").hasClass("is-invalid") && !$("#passphrase").hasClass("is-invalid")
    $("#setupForm").children("input[type=submit]").removeAttr("disabled")
  else if $submit
    event.preventDefault();
  else
    $("#setupForm").children("input[type=submit]").attr("disabled",true)

resetPasswordForm_check = ($submit) ->
  if !$("#newpassword").hasClass("is-invalid") && !$("#retypepassword").hasClass("is-invalid")
    $("#resetPasswordForm").children("input[type=submit]").removeAttr("disabled")
  else if $submit
    event.preventDefault();
  else
    $("#resetPasswordForm").children("input[type=submit]").attr("disabled",true)

resetPassphraseForm_check = ($submit) ->
  if !$("#passphrase").hasClass("is-invalid")
    $("#resetPassphraseForm").children("input[type=submit]").removeAttr("disabled")
  else if $submit
    event.preventDefault();
  else
    $("#resetPassphraseForm").children("input[type=submit]").attr("disabled",true)