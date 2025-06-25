package com.example.feel.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.feel.repository.DiaryWithChatRepository;
import com.example.feel.repository.SettingRepository;

@Service
public class SettingService {

	@Autowired
	private SettingRepository settingRepository;
	
	public void changeChara(int id, int charaId) {
		settingRepository.changeChara(id, charaId);
		
	}

}
