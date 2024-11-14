package com.inecho.repository;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import com.inecho.model.JournalEntry;

@Repository
public interface JournalEntryRepository extends MongoRepository<JournalEntry, String> {
}
