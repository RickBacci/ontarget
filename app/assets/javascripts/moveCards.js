$(document).ready(function() {

  $( ".sortable" ).sortable({
    revert: true,
  });

  $( ".panel" ).draggable({

    start: function(event, ui) {
      console.log('dragging started');
    },
    drag: function() {
      console.log('dragging in progress');
    },
    stop: function(event, ui) {
      console.log('dragging stopped');

      var fromBacklog    = this.className.includes('backlog');
      var fromReady      = this.className.includes('ready');
      var fromInprogress = this.className.includes('in-progress');
      var fromCompleted  = this.className.includes('completed');

      if (fromBacklog) {
        var oldColumn = 'backlog';
      }

      if (fromReady) {
        var oldColumn = 'ready';
      }

      if (fromInprogress) {
        var oldColumn = 'in-progress';
      }

      if (fromCompleted) {
        var oldColumn = 'completed';
      }

      var toBacklog    = this.parentElement.className.includes('backlog');
      var toReady      = this.parentElement.className.includes('ready');
      var toInprogress = this.parentElement.className.includes('in-progress');
      var toCompleted  = this.parentElement.className.includes('completed');

      if (toBacklog) {
        var newColumn = 'backlog'
        $(this).addClass('backlog');
        $(this).removeClass('in-progress ready completed');

        var owner  = this.dataset.owner
        var repo   = this.dataset.repo
        var number = this.dataset.number

        $.ajax({
          type: "POST",
          url: '/update_labels',
          data: { owner: owner,
                  repo: repo,
                  number: number,
                  oldcolumn: oldColumn,
                  newcolumn: newColumn,
                  },

          success: function(post) {

            debugger;
            // success need to change the label name
          },
          error: function(xhr) {
            console.log(xhr.responseText)
          }
        })

      }


      if (toReady) {
        var newColumn = 'ready'
        $(this).addClass('ready');
        $(this).removeClass('backlog in-progress completed');


        var owner  = this.dataset.owner
        var repo   = this.dataset.repo
        var number = this.dataset.number

        $.ajax({
          type: "POST",
          url: '/update_labels',
          data: { owner: owner,
                  repo: repo,
                  number: number,
                  oldcolumn: oldColumn,
                  newcolumn: newColumn,
                  },

          success: function(post) {

            // success need to change the label name
          },
          error: function(xhr) {
            console.log(xhr.responseText)
          }
        })

      }

      if (toInprogress) {
        var newColumn = 'in-progress'
        $(this).addClass('in-progress');
        $(this).removeClass('backlog ready completed');


        var owner  = this.dataset.owner
        var repo   = this.dataset.repo
        var number = this.dataset.number

        $.ajax({
          type: "POST",
          url: '/update_labels',
          data: { owner: owner,
                  repo: repo,
                  number: number,
                  oldcolumn: oldColumn,
                  newcolumn: newColumn,
                  },

          success: function(post) {

            // success need to change the label name
          },
          error: function(xhr) {
            console.log(xhr.responseText)
          }
        })

        window.setTimeout(giveAlert, 2000);
      }

      if (toCompleted) {
        var newColumn = 'completed'
        $(this).addClass('completed');
        $(this).removeClass('backlog ready in-progress');

        var owner  = this.dataset.owner
        var repo   = this.dataset.repo
        var number = this.dataset.number

        $.ajax({
          type: "POST",
          url: '/update_labels',
          data: { owner: owner,
                  repo: repo,
                  number: number,
                  oldcolumn: oldColumn,
                  newcolumn: newColumn,
                  },

          success: function(post) {

            // success need to change the label name
          },
          error: function(xhr) {
            console.log(xhr.responseText)
          }
        })

      }

    },
    connectToSortable: ".sortable",
    revert: "invalid",
    cursor: "move"
  });

});

function giveAlert() {
  alert("Times up!");
}
