package com.inecho.model;

import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "journalEntries")
public class JournalEntry {
    @Id
    private String id;
    private String title;
    private String body;
    private Instant date;
    private List<String> tags;

    // Default constructor matching Flutter defaults
    public JournalEntry() {
        this.title = "";
        this.body = "";
        this.date = Instant.now();
        this.tags = new ArrayList<>();
    }

    // Constructor matching Flutter implementation
    public JournalEntry(String title, String body, List<String> tags) {
        this.title = title;
        this.body = body;
        this.date = Instant.now();
        this.tags = tags != null ? new ArrayList<>(tags) : new ArrayList<>();
    }

    // Full constructor matching Flutter's JournalEntry creation in AddJournalEntryScreen
    public JournalEntry(String id, String title, String body, Instant date, List<String> tags) {
        this.id = id;
        this.title = title;
        this.body = body;
        this.date = date != null ? date : Instant.now();
        this.tags = tags != null ? new ArrayList<>(tags) : new ArrayList<>();
    }

    // Getters and setters without default values to match Flutter implementation
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getBody() {
        return body;
    }

    public void setBody(String body) {
        this.body = body;
    }

    public Instant getDate() {
        return date;
    }

    public void setDate(Instant date) {
        this.date = date;
    }

    public List<String> getTags() {
        return tags;
    }

    public void setTags(List<String> tags) {
        this.tags = tags != null ? new ArrayList<>(tags) : new ArrayList<>();
    }

    @Override
    public String toString() {
        return "JournalEntry{" +
                "id='" + id + '\'' +
                ", title='" + title + '\'' +
                ", body='" + body + '\'' +
                ", date=" + date +
                ", tags=" + tags +
                '}';
    }
}