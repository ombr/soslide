$ ()->
  $input = $('#site_name')
  if $input.length > 0
    $form = $input.parents('form')
    $controls = $input.parents('.form-group')
    $btn = $('input[type=submit]', $form)
    error = ()->
      #$btn.attr('disabled', 'disabled')
      $controls.addClass('has-error')
      $btn.removeClass('btn-primary')
      $btn.removeClass('btn-success')
      $btn.addClass('btn-danger')
    success = ()->
      $btn.removeAttr('disabled')
      $btn.removeClass('btn-primary')
      $btn.removeClass('btn-danger')
      $btn.addClass('btn-success')
      $controls.addClass('has-success')

    $input.autocomplete
      source: (response)->
        $controls.removeClass('has-success')
        $controls.removeClass('has-error')
        name = $input.val()
        name = name.toLowerCase()
        name = name.replace(/[^a-z0-9-]/g,'-')
        $input.val(name)
        unless name.match(/^[a-z][a-z0-9-]{0,20}$/)
          error()
          return
        $controls.addClass('has-warning')
        $.get("/sites/#{name}.json", (data)->
          $controls.removeClass('has-warning')
          if data == null
            success()
          else
            error()
        )
