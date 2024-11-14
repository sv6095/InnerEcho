package com.inecho.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.inecho.model.UserProfile;
import com.inecho.repository.UserProfileRepository;

@Service
public class UserProfileService {

    @Autowired
    private UserProfileRepository repository;

    // Save or update a user profile
    public UserProfile saveUserProfile(UserProfile userProfile) {
        return repository.save(userProfile);  // Uses save from MongoRepository
    }

    // Get all user profiles
    public List<UserProfile> getAllUserProfiles() {
        return repository.findAll();  // Uses findAll from MongoRepository
    }

    // Get a user profile by ID
    public Optional<UserProfile> getUserProfileById(String id) {
        return repository.findById(id);  // Uses findById from MongoRepository
    }

    // Delete a user profile by ID
    public void deleteUserProfile(String id) {
        repository.deleteById(id);  // Uses deleteById from MongoRepository
    }

    // Find user profile by email
    public Optional<UserProfile> getUserProfileByEmail(String email) {
        return repository.findByEmail(email);  // Custom query to find by email
    }

    // Find the current user's profile by their unique ID or email
    public Optional<UserProfile> getCurrentUserProfile(String uniqueIdentifier) {
        // Try finding the profile by email first
        Optional<UserProfile> userProfile = repository.findByEmail(uniqueIdentifier);

        // If not found by email, try finding by ID (if applicable)
        if (!userProfile.isPresent()) {
            userProfile = repository.findById(uniqueIdentifier);
        }

        return userProfile;
    }
}
