package com.birse.producer;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;

@Service
public class TestMessageSender {

    private static final Logger LOG = LoggerFactory.getLogger(TestMessageSender.class);

    @Autowired
    private KafkaTemplate<Long, String> kafkaTemplate;

    @Value("${app.topic.test}")
    private String topic;

    public void send(String message) {
        LOG.info("sending message='{}' to topic='{}'", message, topic);
        kafkaTemplate.send(topic, message);
    }
}
