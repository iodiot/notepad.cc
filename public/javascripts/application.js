var hasChanged = false;
var justClickedBubble = false;
var preventSubmit = true;

function saveContent()
{
  if (hasChanged) {
    $.post(
      "/options/save_content/" +  $("#login").val(),
      {content: $("textarea.contents").val() },
      function(data){
    });

    hasChanged = false;
  }

  setTimeout("saveContent()", 1000);
}

function checkExistence()
{
  $("#message_for_change_url_unavailable").hide();
  $("#change_url_input").addClass("loading");

  $.get("/options/check_existence/" + $("#change_url_input").val(), function(data)
  {
    $("#change_url_input").removeClass("loading");

    if (data == "true") {
      $("#message_for_change_url_unavailable").show();
    } else {
      $("#message_for_change_url_unavailable").hide();
      preventSubmit = false;
      $('#change_url_form').submit();
    }
  });
}

function closeIt()
{
  if (hasChanged) {
    return "You have unsaved content.\n\nPlease wait a few seconds before leaving the page. The content will save automatically.";
  }
}

window.onbeforeunload = closeIt;

$(document).ready(function() {
  saveContent();

  $("textarea.contents").keyup(function() {
    hasChanged = true;
  });


  $(window).click(function() {
    if (justClickedBubble) {
      justClickedBubble = false;
    } else {
      $(".bubble").hide();
    }
  });

  $("[href='#add_password']").click(function() {
    $(".bubble").hide();
    $("#bubble_for_set_password").show();
    $("#add_password_input").focus();
  });

  $("[href='#change_url']").click(function() {
    $(".bubble").hide();
    $("#message_for_change_url_unavailable").hide();
    $("#bubble_for_change_url").show();
    $("#change_url_input").focus();
  });

  $("#change_url_form").submit(function() {
    if (preventSubmit) {
      checkExistence();
      return false;
    }
  });
});

