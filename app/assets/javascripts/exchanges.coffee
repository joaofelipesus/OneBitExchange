api_call = ->
  $.ajax '/convert',
      type: 'GET'
      dataType: 'json'
      data: {
              source_currency: $("#source_currency").val(),
              target_currency: $("#target_currency").val(),
              amount: $("#amount").val()
            }
      error: (jqXHR, textStatus, errorThrown) ->
        alert textStatus
      success: (data, text, jqXHR) ->
        $('#result').val(data.value)
    return false;

$(document).ready ->

  $('form').submit ->
    if $('form').attr('action') == '/convert'
      api_call()

  $('#btn-reverse').click ->
    event.preventDefault()
    source = $("#source_currency").val()
    target = $("#target_currency").val()
    $('#target_currency').val(source)
    $('#source_currency').val(target)
    api_call()

  $('#amount').keyup -> api_call()

  $('#source_currency').change -> api_call()

  $('#target_currency').change -> api_call()
