# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "turbolinks:load", ->
  $("#electvote_card").on "click", ".card", ->
    $("#vote_election_id").val($(this).children("#elec_id").val());
    $.ajax
      url: 'vote/'+$(this).children("#elec_id").val()
      method: 'get'
      dataType: 'json'
      success: (res) ->
        #alert(JSON.stringify(res));
        $("#card_list").html("");
        $(res.candidate).each (i, data) ->
          $("#card_list").append('<div class="card bg-light" style="width:225px"><img class="card-img-top" src="'+data.image+'" alt="Card image"><div class="card-body"><h4 class="card-title">'+res.other[i].name+'</h4><p class="card-text">'+data.description+'</p><div class="custom-control custom-radio text-center"><input type="radio" class="custom-control-input" name="candidate_id" value="'+data.id+'"><label class="custom-control-label"></label></div></div></div>');
    $("#voteModal").modal('show');

  $("#card_list").on "click", ".card", ->
    ch = $(this).find("input").prop('checked');
    $(this).find("input").prop('checked', !ch);
    $(this).siblings(".card").each ->
      $(this).removeClass('bg-secondary');
      $(this).addClass('bg-light');
    $(this).toggleClass('bg-secondary bg-light');

  $("#electverify_card").on "click", "#verifybutt",->
    $("#elect_id").val($(this).siblings("#elec_id").val());
    $("#open-verify").val("verify");
    $("#passModal").modal('show');
    $(this).attr('hidden',true);
    $(this).siblings("#openbutt").removeAttr("hidden");

  $("#electverify_card").on "click", "#openbutt",->
    $("#elect_id").val($(this).siblings("#elec_id").val());
    $("#open-verify").val("open");
    $("#passModal").modal('show');
    $(this).attr('hidden',true);
    $(this).siblings("#verifybutt").removeAttr("hidden");