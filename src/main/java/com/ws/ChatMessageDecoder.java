package com.ws;

import java.io.StringReader;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.json.Json;
import javax.json.JsonObject;
import javax.websocket.DecodeException;
import javax.websocket.Decoder;
import javax.websocket.EndpointConfig;

public class ChatMessageDecoder implements Decoder.Text<ChatMessage> {

    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy hh:mm:ss a");

    @Override
    public void init(final EndpointConfig config) {
    }

    @Override
    public void destroy() {
    }

    @Override
    public ChatMessage decode(String textMessage) throws DecodeException {
        ChatMessage chatMessage = new ChatMessage();
        textMessage = textMessage.trim().replaceAll("\"", "\\\"").replaceAll("\r?\n", "");
        JsonObject obj = Json.createReader(new StringReader(textMessage)).readObject();
        chatMessage.setMessage(obj.getString("message"));
        chatMessage.setSender(obj.getString("sender"));
        chatMessage.setReceived(sdf.format(new Date()));
        return chatMessage;
    }

    @Override
    public boolean willDecode(final String s) {
        return true;
    }
}
