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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.inecho.model.JournalEntry;
import com.inecho.service.JournalEntryService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;

@RestController
@RequestMapping("/api/journal")
@CrossOrigin(origins = "*", allowedHeaders = "*")
@Tag(name = "Journal Entries", description = "Journal Entry Management API")
public class JournalEntryController {

    @Autowired
    private JournalEntryService journalEntryService;

    @Operation(summary = "Get all journal entries", description = "Returns a list of all journal entries")
    @ApiResponse(responseCode = "200", description = "List of journal entries retrieved successfully")
    @GetMapping
    public ResponseEntity<List<JournalEntry>> getAllJournalEntries(
            @Parameter(description = "Filter by user ID") @RequestParam(required = false) String userId,
            @Parameter(description = "Filter by tag") @RequestParam(required = false) String tag) {
        
        List<JournalEntry> entries;
        
        if (userId != null && tag != null) {
            entries = journalEntryService.getJournalEntriesByUserIdAndTag(userId, tag);
        } else if (userId != null) {
            entries = journalEntryService.getJournalEntriesByUserId(userId);
        } else if (tag != null) {
            entries = journalEntryService.getJournalEntriesByTag(tag);
        } else {
            entries = journalEntryService.getAllJournalEntries();
        }
        
        return ResponseEntity.ok(entries);
    }

    @Operation(summary = "Get a journal entry by ID", description = "Returns a journal entry based on its ID")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Journal entry found", 
                     content = @Content(mediaType = "application/json", 
                     schema = @Schema(implementation = JournalEntry.class))),
        @ApiResponse(responseCode = "404", description = "Journal entry not found")
    })
    @GetMapping("/{id}")
    public ResponseEntity<JournalEntry> getJournalEntryById(
            @Parameter(description = "Journal entry ID", required = true) @PathVariable String id) {
        
        Optional<JournalEntry> journalEntry = journalEntryService.getJournalEntryById(id);
        
        return journalEntry.map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @Operation(summary = "Create a new journal entry", description = "Creates a new journal entry and returns it")
    @ApiResponse(responseCode = "201", description = "Journal entry created successfully", 
                 content = @Content(mediaType = "application/json", 
                 schema = @Schema(implementation = JournalEntry.class)))
    @PostMapping
    public ResponseEntity<JournalEntry> createJournalEntry(
            @Parameter(description = "Journal entry to create", required = true) @RequestBody JournalEntry journalEntry) {
        
        JournalEntry createdEntry = journalEntryService.createJournalEntry(journalEntry);
        return ResponseEntity.status(HttpStatus.CREATED).body(createdEntry);
    }

    @Operation(summary = "Update a journal entry", description = "Updates an existing journal entry and returns it")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Journal entry updated successfully", 
                     content = @Content(mediaType = "application/json", 
                     schema = @Schema(implementation = JournalEntry.class))),
        @ApiResponse(responseCode = "404", description = "Journal entry not found")
    })
    @PutMapping("/{id}")
    public ResponseEntity<JournalEntry> updateJournalEntry(
            @Parameter(description = "Journal entry ID", required = true) @PathVariable String id,
            @Parameter(description = "Updated journal entry", required = true) @RequestBody JournalEntry journalEntry) {
        
        Optional<JournalEntry> updatedEntry = journalEntryService.updateJournalEntry(id, journalEntry);
        
        return updatedEntry.map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @Operation(summary = "Delete a journal entry", description = "Deletes a journal entry by its ID")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "204", description = "Journal entry deleted successfully"),
        @ApiResponse(responseCode = "404", description = "Journal entry not found")
    })
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteJournalEntry(
            @Parameter(description = "Journal entry ID", required = true) @PathVariable String id) {
        
        boolean deleted = journalEntryService.deleteJournalEntry(id);
        
        return deleted ? ResponseEntity.noContent().build() : ResponseEntity.notFound().build();
    }

    @Operation(summary = "Search journal entries", description = "Searches for journal entries containing the specified text")
    @ApiResponse(responseCode = "200", description = "Search results")
    @GetMapping("/search")
    public ResponseEntity<List<JournalEntry>> searchJournalEntries(
            @Parameter(description = "Text to search for", required = true) @RequestParam String query) {
        
        List<JournalEntry> entries = journalEntryService.searchJournalEntries(query);
        return ResponseEntity.ok(entries);
    }
}
