package com.oshin.demo.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class MessageController {

    @Value("${message}")
    private String message;

    @GetMapping("/groot-says")
    public String grootSays() {
        return this.message;
    }
}
