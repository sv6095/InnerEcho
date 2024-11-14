/*package com.inecho;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.inecho.controller.UserProfileController;
import com.inecho.model.UserProfile;
import com.inecho.service.UserProfileService;

@WebMvcTest(UserProfileController.class)
public class UserProfileControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean  // Changed from @Autowired to @MockBean
    private UserProfileService userProfileService;

    @Autowired
    private ObjectMapper objectMapper;  // For JSON conversion

    @Test
    public void testCreateUserProfile() throws Exception {
        // Create a user profile object
        UserProfile userProfile = new UserProfile(
            "1",  // userId
            "John Doe",  // username
            "johndoe@example.com"  // email
        );

        // Mock the service method
        when(userProfileService.saveUserProfile(any(UserProfile.class)))
            .thenReturn(userProfile);

        // Convert the userProfile object to JSON string
        String userProfileJson = objectMapper.writeValueAsString(userProfile);

        // Perform the test
        mockMvc.perform(post("/api/userprofiles")
                .contentType(MediaType.APPLICATION_JSON)
                .content(userProfileJson))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.userId").value("1"))
                .andExpect(jsonPath("$.username").value("John Doe"))
                .andExpect(jsonPath("$.email").value("johndoe@example.com"));
    }
}*/