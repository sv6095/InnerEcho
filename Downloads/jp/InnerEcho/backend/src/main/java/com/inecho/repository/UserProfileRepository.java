package com.inecho.repository;

import java.util.Optional;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import com.inecho.model.UserProfile;  // Import Optional from java.util

@Repository
public interface UserProfileRepository extends MongoRepository<UserProfile, String> {
    // Custom query method to find a user profile by email
    Optional<UserProfile> findByEmail(String email);
}
