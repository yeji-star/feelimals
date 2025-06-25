package com.example.feel.vo;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Setting {

    // setting
    private int id;
    private int memberId;
    private int charaId;
    private boolean isUser;
    private boolean thisChat;
    private int emoTagId;
    private String regDate;

    // 혹시 모르니까 ai 관련도
    private String aiReply;
    private String model;
    private String aiRegDate;

}
