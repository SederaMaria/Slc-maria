App.notifications = App.cable.subscriptions.create(channel: 'NotificationsChannel', referer: window.location.href,
  connected: ->
    @setup()
    @setupMarkAsRead()
    @setupMarkAllRead()
    return

  disconnected: ->
    return

  received: (data) ->
    @.prependToList(data)
    @.setUnreadCount()
    return

  setup: ->
    $.ajax(
      url: "/notifications.json"
      dataType: "JSON"
      method: "GET"
      success: @handleSuccess
    )

  handleSuccess: (data) ->
    items = $.map data, (notification) ->
      notification.template
    $("[data-behavior='notification-items']").html(items)
    App.notifications.setUnreadCount()

  setupMarkAllRead: ->
    $('#mark-all-read').click (e) ->
      $.ajax(
        url: "/notifications/mark-all-read"
        dataType: "JSON"
        method: "POST"
      )
      $('[data-unread="true"]').attr('data-unread', 'false')
      App.notifications.setUnreadCount()

  setupMarkAsRead: ->
    $('.dropdown-list').click (e) ->
      target = $(e.target.closest('li'))
      $.ajax(
        url: "/notifications/#{target.data('notification-id')}/mark-as-read"
        dataType: "JSON"
        method: "POST"
      )
      target.attr('data-unread', 'false')
      App.notifications.setUnreadCount()

  setUnreadCount: ->
    items = $("[data-unread=true]")
    count = items.length
    $("[data-behavior='unread-count']").text(count)
    if count > 0 then @.markHasUnreadStatus() else @.removeHasUnreadStatus()
    @.updateTitle(count)

  prependToList: (data) ->
    $("[data-behavior='notification-items']").prepend(data.template)

  markHasUnreadStatus: ->
    $("#icon").attr('data-has-unread', 'true')
    $("#count").show()

  removeHasUnreadStatus: ->
    $("#icon").attr('data-has-unread', 'false')
    $("#count").hide()

  updateTitle: (count) ->
    titleWithoutCount = document.title.replace(/\(\d+\)/, '')
    if count > 0
      document.title = "(#{count}) " + titleWithoutCount
    else
      document.title = titleWithoutCount

  application_submitted: (item) -> "#{item.dealership} has submitted a new lease application"
)
