import {Socket} from "phoenix"

const currentUser = function(){
  let username = localStorage.getItem("username")
  if (username){
    return username
  }

  username = prompt("What should we call you?");

  localStorage.setItem("username", username)

  return username
}


let socket = new Socket("/socket", {params: {username: currentUser()}})

socket.connect()

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("rooms:lobby", {})
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

export default socket

channel.push("connected", {})

const input = document.getElementById("input")
const messages = document.getElementById("messages")

channel.on("welcome", function(){
  messages.innerHTML += "<p class=message>Welcome to Slack</p>";
})

channel.on("recv_msg", function(message){
  console.log(message)
  messages.innerHTML += `<p class=message>${message.sender} ${message.body}</p>`;
})

input.addEventListener("keyup", function(e){
  if (e.keyCode == 13){
    channel.push("msg", { body:  input.value, sender: currentUser() } )
    input.value = ""
    e.preventDefault()
  }
})

currentUser()
