# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  if $("#rulings_index").length > 0
    $(".edit_ruling select").change ->
      $(this).closest("form").submit()