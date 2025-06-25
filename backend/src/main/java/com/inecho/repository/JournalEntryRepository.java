package com.inecho.repository;

import java.util.List;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import com.inecho.model.JournalEntry;

@Repository
public interface JournalEntryRepository extends MongoRepository<JournalEntry, String> {
    
    // Find all journal entries for a specific user
    List<JournalEntry> findByUserId(String userId);
    
    // Find journal entries containing specific text in title or body
    List<JournalEntry> findByTitleContainingIgnoreCaseOrBodyContainingIgnoreCase(String titleText, String bodyText);
    
    // Find journal entries with a specific tag
    List<JournalEntry> findByTagsContaining(String tag);
    
    // Find journal entries by user ID and containing a tag
    List<JournalEntry> findByUserIdAndTagsContaining(String userId, String tag);
}
