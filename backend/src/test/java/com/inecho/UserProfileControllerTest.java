package com.inecho;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.util.Arrays;
import java.util.Optional;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.inecho.controller.UserProfileController;
import com.inecho.model.UserProfile;
import com.inecho.service.UserProfileService;

@WebMvcTest(UserProfileController.class)
public class UserProfileControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private UserProfileService userProfileService;

    @Autowired
    private ObjectMapper objectMapper;

    private UserProfile testUserProfile;

    @BeforeEach
    void setUp() {
        testUserProfile = new UserProfile("Test User", "test@example.com");
        testUserProfile.setId("1");
    }

    @Test
    void getUserProfileById_ShouldReturnUserProfile() throws Exception {
        when(userProfileService.getUserProfileById("1")).thenReturn(Optional.of(testUserProfile));

        mockMvc.perform(get("/api/userProfiles/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value("1"))
                .andExpect(jsonPath("$.name").value("Test User"))
                .andExpect(jsonPath("$.email").value("test@example.com"));
    }

    @Test
    void getUserProfileById_NotFound_ShouldReturn404() throws Exception {
        when(userProfileService.getUserProfileById("999")).thenReturn(Optional.empty());

        mockMvc.perform(get("/api/userProfiles/999"))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.message").value("Profile not found for ID: 999"));
    }

    @Test
    void createUserProfile_ShouldReturnCreatedUserProfile() throws Exception {
        UserProfile inputProfile = new UserProfile("New User", "new@example.com");
        UserProfile savedProfile = new UserProfile("New User", "new@example.com");
        savedProfile.setId("2");

        when(userProfileService.saveUserProfile(any(UserProfile.class))).thenReturn(savedProfile);

        mockMvc.perform(post("/api/userProfiles")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(inputProfile)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.id").value("2"))
                .andExpect(jsonPath("$.name").value("New User"))
                .andExpect(jsonPath("$.email").value("new@example.com"));
    }

    @Test
    void getAllUserProfiles_ShouldReturnAllProfiles() throws Exception {
        UserProfile profile1 = new UserProfile("User 1", "user1@example.com");
        profile1.setId("1");
        UserProfile profile2 = new UserProfile("User 2", "user2@example.com");
        profile2.setId("2");

        when(userProfileService.getAllUserProfiles()).thenReturn(Arrays.asList(profile1, profile2));

        mockMvc.perform(get("/api/userProfiles"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].id").value("1"))
                .andExpect(jsonPath("$[0].name").value("User 1"))
                .andExpect(jsonPath("$[1].id").value("2"))
                .andExpect(jsonPath("$[1].name").value("User 2"));
    }
}