package com.ws;

import java.io.IOException;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.inject.Singleton;

import javax.websocket.EncodeException;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.PathParam;
import javax.websocket.server.ServerEndpoint;

@ServerEndpoint(value = "/connect/{room}", encoders = ChatMessageEncoder.class, decoders = ChatMessageDecoder.class)
@Singleton
public class ChatEndpoint {

    private final Logger log = Logger.getLogger(getClass().getName());
    private static final Set<Session> SESSIONS = Collections.synchronizedSet(new HashSet<Session>());

    @OnOpen
    public void open(final Session session, @PathParam("room") final String room) {
        log.log(Level.INFO, "session openend and bound to room: {0}", room);
        session.getUserProperties().put("room", room);
        SESSIONS.add(session);
        ChatMessage chatMessage = new ChatMessage();
        chatMessage.setSender("ADMIN");
        int count = 0;
        for (Session s : SESSIONS) {
            if (s.isOpen() && room.equals(s.getUserProperties().get("room"))) {
                count++;
            }
        }
        chatMessage.setMessage(count + "");
        chatMessage.setReceived("Now");
        sendMessage(chatMessage, room);
    }

    @OnMessage
    public void onMessage(final Session session, final ChatMessage chatMessage) {
        String room = (String) session.getUserProperties().get("room");
        sendMessage(chatMessage, room);
    }

    private void sendMessage(Object message, String room) {
        for (Session s : SESSIONS) {
            try {
                if (s.isOpen() && room.equals(s.getUserProperties().get("room"))) {
                    s.getBasicRemote().sendObject(message);
                }
            } catch (IOException | EncodeException e) {
                e.printStackTrace();
            }
        }
    }
}
