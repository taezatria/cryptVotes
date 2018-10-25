# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "turbolinks:load", ->
  $(".card").on "click", "button", ->
    $("#vote_election_id").val($(this).siblings("#elec_id").val());
    $.ajax
      url: 'vote/'+$(this).siblings("#elec_id").val()
      method: 'get'
      dataType: 'json'
      error: ->
        $("#card_list").html("");
        $("#card_list").append('<div class="card bg-light" style="width:225px"><img class="card-img-top" src="foo" alt="Card image"><div class="card-body"><h4 class="card-title">foo</h4><p class="card-text">foo</p><div class="custom-control custom-radio text-center"><input type="radio" class="custom-control-input" id="bar" name="bar"><label class="custom-control-label" for="bar"></label></div></div></div>');