Mariposta = {}

Mariposta.Support = {
  bindRepoNoticeButtons: function() {
    $('button[data-behavior=publish-site]').on('click', function() {
      var commitMsg = prompt('Enter a short summary of your changes for version control history:');

      if (commitMsg != null) {
        $('body > .alert').html('<p class="text-center">Publishing...<p>');

        $.post('/publish/now', {commit_message: commitMsg}, function(data) {
          $('body > .alert').html('<p class="text-center"><strong>Site published!</strong> <a href="' + data.published_site_url + '" target="_blank" class="button small hollow icon"><i class="fa fa-globe" aria-hidden="true"></i> Visit Site</a> (might take a minute to refresh)<p>');
        });
      }
    });
    $('button[data-behavior=review-changes]').on('click', function() {
      location.href = "/publish/review";
    });
  },
  setupPageEditor: function() {
    if ($('div.CodeMirror').length == 0) {
      var simplemde = new SimpleMDE({
        element: document.getElementById("page-editor-box"),
        forceSync: true,
        autofocus: true,
        spellChecker: false,
        toolbar: ["bold", "italic", "code", "heading-2", "heading-3", "|", "quote", "unordered-list", "ordered-list", "|", "link", "horizontal-rule", "|", "fullscreen"]
      });
    }
  }
}
