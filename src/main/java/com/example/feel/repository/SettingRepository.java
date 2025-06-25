package com.example.feel.repository;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface SettingRepository {

	public void changeChara(@Param("memberId") int memberId, int charaId);

}
