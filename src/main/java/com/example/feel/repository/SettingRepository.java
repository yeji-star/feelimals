package com.example.feel.repository;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface SettingRepository {

	public void changeChara(int id, int charaId);

}
