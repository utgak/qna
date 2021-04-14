import consumer from "./consumer"

$(document).on('turbolinks:load', function () {
  if (gon.question_id) {
    consumer.subscriptions.create({ channel: "CommentsChannel", question_id: gon.question_id }, {
      connected() {
        console.log(gon.question_id)
        // Called when the subscription is ready for use on the server
      },

      disconnected() {
        // Called when the subscription has been terminated by the server

      },

      received(data) {
        console.log(data)
        if (gon.user_id !== data.author_id) {
          if (data.comment.commentable_type === 'Answer') {
            $(".answers").find(`[data-id=${data.comment.commentable_id}]`).children('.comments').append(`<p>${data.email}</p><p> ${data.comment.body}</p><hr>`)
          } else {
            $(".question_comments").append(`<p>${data.email}</p><p> ${data.comment.body}</p><hr>`)
          }
        }
      }
    });
  }
})
