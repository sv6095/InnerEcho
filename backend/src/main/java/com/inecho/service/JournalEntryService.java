package com.inecho.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.inecho.model.JournalEntry;
import com.inecho.repository.JournalEntryRepository;

@Service
public class JournalEntryService {

    private final JournalEntryRepository journalEntryRepository;

    @Autowired
    public JournalEntryService(JournalEntryRepository journalEntryRepository) {
        this.journalEntryRepository = journalEntryRepository;
    }

    public List<JournalEntry> getAllEntries() {
        return journalEntryRepository.findAll();
    }

    public Optional<JournalEntry> getEntryById(String id) {
        return journalEntryRepository.findById(id);
    }

    public JournalEntry createEntry(JournalEntry entry) {
        return journalEntryRepository.save(entry);
    }

    public Optional<JournalEntry> updateEntry(String id, JournalEntry updatedEntry) {
        return journalEntryRepository.findById(id).map(entry -> {
            entry.setTitle(updatedEntry.getTitle());
            entry.setBody(updatedEntry.getBody());
            entry.setTags(updatedEntry.getTags());
            return journalEntryRepository.save(entry);
        });
    }

    public boolean deleteEntry(String id) {
        if (journalEntryRepository.existsById(id)) {
            journalEntryRepository.deleteById(id);
            return true;
        }
        return false;
    }
}
