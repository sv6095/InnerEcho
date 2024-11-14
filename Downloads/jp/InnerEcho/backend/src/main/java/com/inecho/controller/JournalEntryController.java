package com.inecho.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.inecho.model.JournalEntry;
import com.inecho.service.JournalEntryService;

@RestController
@RequestMapping("/api/journal")
@CrossOrigin(origins = "*") // Update with specific origins in production
public class JournalEntryController {

    private final JournalEntryService journalEntryService;

    @Autowired
    public JournalEntryController(JournalEntryService journalEntryService) {
        this.journalEntryService = journalEntryService;
    }

    @GetMapping
    public ResponseEntity<List<JournalEntry>> getAllEntries() {
        List<JournalEntry> entries = journalEntryService.getAllEntries();
        return ResponseEntity.ok(entries);
    }

    @GetMapping("/{id}")
    public ResponseEntity<JournalEntry> getEntryById(@PathVariable String id) {
        return journalEntryService.getEntryById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<JournalEntry> createEntry(@Validated @RequestBody JournalEntry entry) {
        JournalEntry createdEntry = journalEntryService.createEntry(entry);
        return ResponseEntity.status(HttpStatus.CREATED).body(createdEntry);
    }

    @PutMapping("/{id}")
    public ResponseEntity<JournalEntry> updateEntry(
            @PathVariable String id,
            @Validated @RequestBody JournalEntry entry) {
        return journalEntryService.updateEntry(id, entry)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteEntry(@PathVariable String id) {
        return journalEntryService.deleteEntry(id)
                ? ResponseEntity.noContent().build()
                : ResponseEntity.notFound().build();
    }
}
