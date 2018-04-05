Mariposta = {}

Mariposta.Support = {
  bindRepoNoticeButtons: function() {
    $('button[data-behavior=publish-site]').on('click', function() {
      var commitMsg = prompt('Enter a short summary of your changes for version control history:');

      if (commitMsg != null) {
        $('body > .alert').html('<p class="text-center">Publishing...<p>');

        $.post('/mariposta/publish/now', {commit_message: commitMsg}, function(data) {
          $('body > .alert').html('<p class="text-center"><strong>Site published!</strong> <a href="' + data.published_site_url + '" target="_blank" class="button small hollow icon"><i class="fa fa-globe" aria-hidden="true"></i> Visit Site</a> (might take a minute to refresh)<p>');
        });
      }
    });
    $('button[data-behavior=review-changes]').on('click', function() {
      location.href = "/mariposta/publish/review";
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
  },
  setupCloudinarySelector: function(cloudName, uploadPreset) {
    var _self = this;
    var completeModal = false;

    $('button.cloudinary-selector').click(function(e) {
      e.preventDefault();
      // popup modal
      var $modal = $('#image-selector-modal');
      var frontMatterField = $('#' + $(this).data('front-matter'));
      var thumbnailContainer = $('#' + $(this).data('front-matter') + '-thumbnail')

      $.ajax('/mariposta/images?modal=true')
        .done(function(resp){
          $modal.html(resp);

          $('.image-library .thumbnail').click(function() {
            var cloudinaryId = $(this).data('cloudinary-id');
            var imageSrc = $(this).find('img').attr('src');
            frontMatterField.val(cloudinaryId);

            var thumbnail = '<img class="thumbnail" src="' + imageSrc + '" alt="' + cloudinaryId + '" />';
            console.log(thumbnail);
            console.log($('#' + $(this).data('front-matter') + '-thumbnail'));
            thumbnailContainer.html(thumbnail);
            $modal.foundation('close');
          });

          if (!completeModal) {
            $modal.foundation('open');

            $('#upload_widget_opener').cloudinary_upload_widget({
              cloud_name: cloudName,
              upload_preset: uploadPreset,
              multiple: false,
              max_files: 1,
              button_class: 'button',
              theme: 'minimal',
              stylesheet: _self.cloudinaryStyles()
            }, function(error, result) {
              console.log(error, result);

              if ($(result).is(Array)) {
                // reload!
                completeModal = true;
                $modal.foundation('close');
                $('button.cloudinary-selector').click();
              }
            });
          } else {
            $('.image-library .thumbnail:eq(0)').trigger('click');
            completeModal = false;
          }
      });
    });
  },
  cloudinaryStyles: function() {
    var primaryColor = $('.button:eq(0)').css('background-color')

    var styles = '#cloudinary-widget .panel.local .drag_area .drag_content .label { color: #777 } '
    styles += '#cloudinary-widget .button, #cloudinary-widget .button.small_button { color: ' + primaryColor + '; border-color: ' + primaryColor + '} '
    styles += '#cloudinary-widget .button:hover, #cloudinary-widget .button.small_button:hover, #cloudinary-widget .upload_button_holder:hover .button { background: ' + primaryColor + ' }'
    styles += '#cloudinary-navbar .source.active { border-bottom-color: ' + primaryColor + '}'

    return styles
  }
}
