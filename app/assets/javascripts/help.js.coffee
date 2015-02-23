#scrollTo = (obj) ->
#  obj.click (e) ->
#    e.preventDefault()
#    id = $(this).attr("href")
#    $("html, body").animate(
#      scrollTop: $(id).offset().top
#    , 1000)
#    
#    $(":animated").promise().done -> location.hash = id
#
$(window).load ->
  $('#content').css("min-height", $(window).height() - $('footer').height())
  if $("#welcome_help").length > 0
    $("#help_nav a").click (e) -> 
      scroll_here($(this).attr("href"))
      
    $("#sticky").sticky({topSpacing: "120px"});
    #
    #$(".scroll_nav").sticky({topSpacing: "120px"});
    #
    #scrollTo($(".scroll_nav a"))
    #
    $("img[data-caption]").each ->
      pic_real_width = undefined
      img = $(this)
      $("<img/>").attr("src", img.attr("src")).load ->
        if @width < img.width()
          width = @width
        else
          width = img.width()
        img.after("<div class='caption' style=' width:" + width + "px;'>" + img.data("caption") + "</div>")