package com.daowen.bean;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class DbConfig {

    @Value("${spring.datasource.url}")
    private String url;
    @Value("${spring.datasource.driver-class-name}")
    private String driver;
    @Value("${spring.datasource.username}")
    private String username;
    @Value("${spring.datasource.password}")
    private String password;


    public String getUrl() {
        return url;
    }


    public String getDriver() {
        return driver;
    }


    public String getUsername() {
        return username;
    }


    public String getPassword() {
        return password;
    }


}
