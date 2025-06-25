package com.inecho.controller;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.inecho.model.UserProfile;
import com.inecho.service.UserProfileService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*", allowedHeaders = "*") // Configured for development
@Tag(name = "User Profile", description = "User Profile Management API")
public class UserProfileController {

    @Autowired
    private UserProfileService service;

    @Operation(summary = "Get a user profile by ID", description = "Returns a user profile based on the ID")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Profile found", 
                     content = @Content(mediaType = "application/json", 
                     schema = @Schema(implementation = UserProfile.class))),
        @ApiResponse(responseCode = "404", description = "Profile not found", 
                     content = @Content(mediaType = "application/json", 
                     schema = @Schema(implementation = ApiErrorResponse.class)))
    })
    @GetMapping("/userProfiles/{id}")
    public ResponseEntity<?> getUserProfileById(
            @Parameter(description = "User profile ID", required = true) @PathVariable String id) {
        Optional<UserProfile> userProfile = service.getUserProfileById(id);
        return userProfile.isPresent()
                ? ResponseEntity.ok(userProfile.get())
                : ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(new ApiErrorResponse("Profile not found for ID: " + id, HttpStatus.NOT_FOUND));
    }

    @Operation(summary = "Create a new user profile", description = "Creates a new user profile and returns the created profile")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "201", description = "Profile created", 
                     content = @Content(mediaType = "application/json", 
                     schema = @Schema(implementation = UserProfile.class))),
        @ApiResponse(responseCode = "500", description = "Internal server error", 
                     content = @Content(mediaType = "application/json", 
                     schema = @Schema(implementation = ApiErrorResponse.class)))
    })
    @PostMapping("/userProfiles")
    public ResponseEntity<?> createUserProfile(
            @Parameter(description = "User profile to create", required = true) @RequestBody UserProfile userProfile) {
        try {
            UserProfile savedProfile = service.saveUserProfile(userProfile);
            return ResponseEntity.status(HttpStatus.CREATED).body(savedProfile);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ApiErrorResponse("Error creating profile: " + e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR));
        }
    }

    @Operation(summary = "Update an existing user profile", description = "Updates a user profile and returns the updated profile")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Profile updated", 
                     content = @Content(mediaType = "application/json", 
                     schema = @Schema(implementation = UserProfile.class))),
        @ApiResponse(responseCode = "404", description = "Profile not found", 
                     content = @Content(mediaType = "application/json", 
                     schema = @Schema(implementation = ApiErrorResponse.class))),
        @ApiResponse(responseCode = "500", description = "Internal server error", 
                     content = @Content(mediaType = "application/json", 
                     schema = @Schema(implementation = ApiErrorResponse.class)))
    })
    @PutMapping("/userProfiles/{id}")
    public ResponseEntity<?> updateUserProfile(
            @Parameter(description = "User profile ID", required = true) @PathVariable String id,
            @Parameter(description = "Updated user profile", required = true) @RequestBody UserProfile userProfile) {
        try {
            Optional<UserProfile> existingProfile = service.getUserProfileById(id);
            if (!existingProfile.isPresent()) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(new ApiErrorResponse("Profile not found for ID: " + id, HttpStatus.NOT_FOUND));
            }
            
            userProfile.setId(id);
            UserProfile updatedProfile = service.saveUserProfile(userProfile);
            return ResponseEntity.ok(updatedProfile);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ApiErrorResponse("Error updating profile: " + e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR));
        }
    }

    @Operation(summary = "Get all user profiles", description = "Returns a list of all user profiles")
    @ApiResponse(responseCode = "200", description = "List of profiles", 
                 content = @Content(mediaType = "application/json", 
                 schema = @Schema(implementation = List.class)))
    @GetMapping("/userProfiles")
    public ResponseEntity<List<UserProfile>> getAllUserProfiles() {
        return ResponseEntity.ok(service.getAllUserProfiles());
    }

    @Operation(summary = "Delete a user profile", description = "Deletes a user profile by ID")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Profile deleted", 
                     content = @Content(mediaType = "application/json", 
                     schema = @Schema(implementation = ApiSuccessResponse.class))),
        @ApiResponse(responseCode = "500", description = "Internal server error", 
                     content = @Content(mediaType = "application/json", 
                     schema = @Schema(implementation = ApiErrorResponse.class)))
    })
    @DeleteMapping("/userProfiles/{id}")
    public ResponseEntity<?> deleteUserProfile(
            @Parameter(description = "User profile ID to delete", required = true) @PathVariable String id) {
        try {
            service.deleteUserProfile(id);
            return ResponseEntity.ok(new ApiSuccessResponse("Profile deleted successfully", HttpStatus.OK));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ApiErrorResponse("Error deleting profile: " + e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR));
        }
    }

    @Operation(summary = "Logout user", description = "Logs out the current user")
    @ApiResponse(responseCode = "200", description = "Logout successful", 
                 content = @Content(mediaType = "application/json", 
                 schema = @Schema(implementation = ApiSuccessResponse.class)))
    @PostMapping("/logout")
    public ResponseEntity<ApiSuccessResponse> logoutUser() {
        // Here you can add logic to invalidate the user session or token
        return ResponseEntity.ok(new ApiSuccessResponse("Logout successful", HttpStatus.OK));
    }

    // Success response class
    public static class ApiSuccessResponse {
        private String message;
        private HttpStatus status;

        public ApiSuccessResponse(String message, HttpStatus status) {
            this.message = message;
            this.status = status;
        }

        public String getMessage() {
            return message;
        }

        public void setMessage(String message) {
            this.message = message;
        }

        public HttpStatus getStatus() {
            return status;
        }

        public void setStatus(HttpStatus status) {
            this.status = status;
        }
    }

    // Error response class
    public static class ApiErrorResponse {
        private String message;
        private HttpStatus status;

        public ApiErrorResponse(String message, HttpStatus status) {
            this.message = message;
            this.status = status;
        }

        public String getMessage() {
            return message;
        }

        public void setMessage(String message) {
            this.message = message;
        }

        public HttpStatus getStatus() {
            return status;
        }

        public void setStatus(HttpStatus status) {
            this.status = status;
        }
    }
}
