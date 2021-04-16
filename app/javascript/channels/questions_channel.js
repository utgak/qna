import consumer from "./consumer"

consumer.subscriptions.create("QuestionsChannel", {
  connected() {
    console.log("question")
  },

  disconnected() {

    // Called when the subscription has been terminated by the server
  },

  received(data) {
    $(".questions").append(`<div className='question' data-id=${data.id}><a href='/questions/${data.id}'>${data.title}</a>`)
  }
});
