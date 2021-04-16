import consumer from "./consumer"

$(document).on('turbolinks:load', function () {
  if (gon.question_id) {
    consumer.subscriptions.create({ channel: "AnswersChannel", question_id: gon.question_id }, {
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
          $(".answers").append(`<p>${data.answer.body}</p><hr>`)
        }
      }
    });
  }
})