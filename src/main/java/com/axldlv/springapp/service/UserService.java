package com.axldlv.springapp.service;

import com.axldlv.springapp.model.User;

public interface UserService {
	public User findUserByEmail(String email);

	public void saveUser(User user);
}
