<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>CHAT</title>
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
        <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.3/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zug+QiDoJOrZ5t4lssLdxGhVrurbmBWopoEl+M6BdEfwnCJZtKxi1KgxUyJq13dy" crossorigin="anonymous">
        <style type="text/css">
            .received {right: 30px;font-size: 10px;position: absolute;}
            .user-chat {left: 0px;font-size: 11px;font-weight: bold;}
            .message{padding-top: 20px;padding-left: 0px;position: relative;word-wrap: break-word;width: 100%}
        </style>
    </head>
    <body>
        <div style="padding-top: 20px" id="chat-signin" class="col-md-6 col-lg-5 mx-auto text-center">
            <div class="card card-cascade">
                <div class="view gradient-card-header blue-gradient">
                    <h2 class="h2-responsive">Chat</h2>
                </div>
                <div class="card-body">
                    <form id="enterRoom">
                        <div class="form-group">
                            <input maxlength="50" type="text" class="form-control" placeholder="Your Name.." autocomplete="off" required="" id="name" >
                        </div>
                        <div class="form-group">
                            <select required="" id="chatroom" class="form-control">
                                <option value="" disabled="" selected="">Choose Group</option>
                                <option value="Java">Java</option>
                                <option value="C++">C++</option>
                                <option value="C">C</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <button class="btn btn-primary" type="submit">Enter Chat</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <div id="chat-wrapper" class="card card-cascade col-md-6 col-lg-5 mx-auto" style="background-color: #F5F5F5;padding: 0px;display: none;">
            <div class="card-body" style="padding: 0px">
                <div style="margin-bottom: 0.3rem;padding: 0.6rem" class="alert alert-success">
                    <span style="font-weight: bold;font-style: italic" id="info"></span>
                    <button style="right:0px;position: absolute;" class="btn btn-sm btn-danger" type="button" id="leave-room">Exit</button>
                </div>
                <div style="overflow-x: scroll;height: 66vh" id="response"></div>
                <form id="do-chat">
                    <div class="form-group">
                        <input placeholder="Type message here.." type="text" class="form-control" autocomplete="off" required="" id="message" >
                    </div>
                    <button type="submit" class="btn btn-block btn-primary">Send Message</button>
                </form>
            </div>
        </div>

        <script type="text/javascript" src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.3/js/bootstrap.min.js" integrity="sha384-a5N7Y/aK3qNeh15eJKGWxsqtnX/wWdSZSKp+81YjTmS15nvnvxKHuzaWwXHDli+4" crossorigin="anonymous"></script>
        <script type="text/javascript">
            var wsocket;
            var serviceLocation = "ws://192.168.10.161:8080/connect/";
            var $message;
            var $chatWindow;
            var room = '';
            var sender = '';

            function onMessageReceived(evt) {
                var msg = JSON.parse(evt.data); // native API
                if (msg.received === 'Now') {
                    $('#info').html(room + " (" + msg.message + " Online)");
                } else {
                    var $messageLine = $('<div style="margin-bottom:0.3rem;" class="card card-cascade"><div style="padding-bottom: 0.4rem;padding-top: 0.4rem" class="row card-body">'
                            + '<span class="user-chat">' + msg.sender + '</span><span class="received">' + msg.received + '</span>'
                            + '<span class="message">' + msg.message + '</span></div></div>');
                    $chatWindow.append($messageLine);
                    $chatWindow.animate({scrollTop: $chatWindow[0].scrollHeight}, 10);
                }
            }
            function sendMessage() {
                var msg = '{"message":"' + $message.val() + '", "sender":"'
                        + sender + '", "received":""}';
                wsocket.send(msg);
                $message.val('');
            }

            function connectToChatserver() {
                room = $('#chatroom option:selected').val();
                sender = $('#name').val();
                wsocket = new WebSocket(serviceLocation + room);
                wsocket.onmessage = onMessageReceived;
                wsocket.onerror = function () {
                    location.reload();
                };
            }

            function leaveRoom() {
                wsocket.close();
                $chatWindow.empty();
                $('#chat-wrapper').hide();
                $('#enterRoom')[0].reset();
                $('#chat-signin').show();
            }

            $(document).ready(function () {
                $message = $('#message');
                $chatWindow = $('#response');
                $('#chat-wrapper').hide();

                $('#enterRoom').submit(function (evt) {
                    evt.preventDefault();
                    connectToChatserver();
                    $('#info').html(room);
                    $('#chat-signin').hide();
                    $('#chat-wrapper').show();
                });
                $('#do-chat').submit(function (evt) {
                    evt.preventDefault();
                    sendMessage();
                });
                $('#leave-room').click(function () {
                    leaveRoom();
                });
            });
        </script>
</html>