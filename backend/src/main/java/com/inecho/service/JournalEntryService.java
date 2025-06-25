package com.inecho.service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.inecho.model.JournalEntry;
import com.inecho.repository.JournalEntryRepository;

@Service
public class JournalEntryService {

    @Autowired
    private JournalEntryRepository repository;

    // Get all journal entries
    public List<JournalEntry> getAllJournalEntries() {
        return repository.findAll();
    }

    // Get journal entries for a specific user
    public List<JournalEntry> getJournalEntriesByUserId(String userId) {
        return repository.findByUserId(userId);
    }

    // Get a specific journal entry by ID
    public Optional<JournalEntry> getJournalEntryById(String id) {
        return repository.findById(id);
    }

    // Create a new journal entry
    public JournalEntry createJournalEntry(JournalEntry journalEntry) {
        // Set the creation date if not provided
        if (journalEntry.getDate() == null) {
            journalEntry.setDate(LocalDateTime.now());
        }
        return repository.save(journalEntry);
    }

    // Update an existing journal entry
    public Optional<JournalEntry> updateJournalEntry(String id, JournalEntry journalEntry) {
        Optional<JournalEntry> existingEntry = repository.findById(id);
        
        if (existingEntry.isPresent()) {
            JournalEntry updatedEntry = existingEntry.get();
            updatedEntry.setTitle(journalEntry.getTitle());
            updatedEntry.setBody(journalEntry.getBody());
            updatedEntry.setTags(journalEntry.getTags());
            // Don't update the date or userId
            
            return Optional.of(repository.save(updatedEntry));
        }
        
        return Optional.empty();
    }

    // Delete a journal entry
    public boolean deleteJournalEntry(String id) {
        if (repository.existsById(id)) {
            repository.deleteById(id);
            return true;
        }
        return false;
    }

    // Search journal entries by text in title or body
    public List<JournalEntry> searchJournalEntries(String searchText) {
        return repository.findByTitleContainingIgnoreCaseOrBodyContainingIgnoreCase(searchText, searchText);
    }

    // Find journal entries with a specific tag
    public List<JournalEntry> getJournalEntriesByTag(String tag) {
        return repository.findByTagsContaining(tag);
    }

    // Find journal entries for a specific user with a specific tag
    public List<JournalEntry> getJournalEntriesByUserIdAndTag(String userId, String tag) {
        return repository.findByUserIdAndTagsContaining(userId, tag);
    }
}
