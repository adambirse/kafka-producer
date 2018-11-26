package com.birse.producer;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/send")
public class TestMessageController {

    @Autowired
    private TestMessageSender sender;

    @GetMapping
    public void send() {

        sender.send(createMessage());
    }

    private String createMessage() {
        return "Hello World this is the producer: " + RandomIDGenerator.generateLong();
    }
}
