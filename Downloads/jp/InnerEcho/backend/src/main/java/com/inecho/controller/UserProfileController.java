package com.inecho.controller;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.inecho.model.UserProfile;
import com.inecho.service.UserProfileService;

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*", allowedHeaders = "*") // Configured for development
public class UserProfileController {

    @Autowired
    private UserProfileService service;

    // Endpoint to retrieve a user profile by ID
    @GetMapping("/userProfiles/{id}")
    public ResponseEntity<?> getUserProfileById(@PathVariable String id) {
        Optional<UserProfile> userProfile = service.getUserProfileById(id);
        return userProfile.isPresent()
                ? ResponseEntity.ok(userProfile.get())
                : ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(new ApiResponse("Profile not found for ID: " + id, null, HttpStatus.NOT_FOUND));
    }

    // Endpoint to create a new user profile
    @PostMapping("/userProfiles")
    public ResponseEntity<?> createUserProfile(@RequestBody UserProfile userProfile) {
        try {
            UserProfile savedProfile = service.saveUserProfile(userProfile);
            return ResponseEntity.status(HttpStatus.CREATED).body(savedProfile);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ApiResponse("Error creating profile", e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR));
        }
    }

    // Endpoint to get all user profiles
    @GetMapping("/userProfiles")
    public ResponseEntity<?> getAllUserProfiles() {
        return ResponseEntity.ok(service.getAllUserProfiles());
    }

    // Endpoint to delete a user profile by ID
    @DeleteMapping("/userProfiles/{id}")
    public ResponseEntity<?> deleteUserProfile(@PathVariable String id) {
        try {
            service.deleteUserProfile(id);
            return ResponseEntity.ok("Profile deleted successfully");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ApiResponse("Error deleting profile", e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR));
        }
    }

    // Logout endpoint
    @PostMapping("/logout")
    public ResponseEntity<?> logoutUser() {
        // Here you can add logic to invalidate the user session or token
        return ResponseEntity.ok(new ApiResponse("Logout successful", null, HttpStatus.OK));
    }

    // Unified response structure for success and error responses
    static class ApiResponse {
        private String message;
        private Object data;
        private HttpStatus status;

        public ApiResponse(String message, Object data, HttpStatus status) {
            this.message = message;
            this.data = data;
            this.status = status;
        }

        public String getMessage() {
            return message;
        }

        public void setMessage(String message) {
            this.message = message;
        }

        public Object getData() {
            return data;
        }

        public void setData(Object data) {
            this.data = data;
        }

        public HttpStatus getStatus() {
            return status;
        }

        public void setStatus(HttpStatus status) {
            this.status = status;
        }
    }
}
