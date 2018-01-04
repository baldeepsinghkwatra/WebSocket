package com.ws;

import lombok.Data;

@Data
public class ChatMessage {

    private String message;
    private String sender;
    private String received;
}
