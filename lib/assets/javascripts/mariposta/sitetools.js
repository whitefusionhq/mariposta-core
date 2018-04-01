Mariposta = {}

Mariposta.Awesome = function() {
  var _self = {
    serverURL: null,
    token: null,

    init: function(serverURL) {
      _self.serverURL = serverURL
      $.get(_self.serverURL + '/mariposta/awesome/token', function(data) {
        _self.token = data.token

        _self.initializeButtonCounts()
        document.addEventListener("turbolinks:load", function() {
          _self.initializeButtonCounts()
        })
      });

      document.addEventListener("turbolinks:load", function() {
        $('button[data-behavior=awesome]').off('click.awesome').on('click.awesome', function() {
          var url = $(this).data('url')
          _self.increment(url, $(this))

          if (Mariposta.Utils.readCookie('shownAwesome') == "") {
            $('#awesomePost').foundation('open')
            Mariposta.Utils.writeCookie('shownAwesome', true, 365)
          }
        })
      })
    },

    increment: function(url, $button) {
      if (_self.serverURL == null) {
        console.error("Missing Mariposta server url")
        return
      }

      if (_self.token == null) {
        console.error("Missing Mariposta access token")
        return
      }

      $.post(_self.serverURL + '/mariposta/awesome', {
          token: _self.token,
          url: url
        }, function(data) {
          $button.find('.count').addClass('positive')
          $button.find('.count').text(data.count)
        }
      )
    },

    initializeButtonCounts: function() {
      $('button[data-behavior=awesome]').each(function() {
        var url = $(this).data('url')
        _self.showCount(url, $(this))
      })
    },

    showCount: function(url, $button) {
      if (_self.serverURL == null) {
        console.error("Missing Mariposta server url")
        return
      }

      if (_self.token == null) {
        console.error("Missing Mariposta access token")
        return
      }

      $.get(_self.serverURL + '/mariposta/awesome', {
          token: _self.token,
          url: url
        }, function(data) {
          if (data.count > 0) {
            $button.find('.count').addClass('positive')
            $button.find('.count').text(data.count)
          }
        }
      )
    }
  }

  return _self
}()

Mariposta.Utils = {
  // thanks https://stackoverflow.com/a/4825695/551775
  writeCookie: function(name, value, days) {
    var expires
    if (days) {
      var date = new Date()
      date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000))
      expires = "; expires=" + date.toGMTString()
    }
    else {
      expires = ""
    }
    document.cookie = name + "=" + value + expires + "; path=/"
  },

  readCookie: function(c_name) {
    if (document.cookie.length > 0) {
      c_start = document.cookie.indexOf(c_name + "=");
      if (c_start != -1) {
        c_start = c_start + c_name.length + 1;
        c_end = document.cookie.indexOf(";", c_start);
        if (c_end == -1) {
          c_end = document.cookie.length;
        }
        return unescape(document.cookie.substring(c_start, c_end));
      }
    }
    return "";
  }
}
