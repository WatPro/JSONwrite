import com.mongodb.MongoClient;
// import com.mongodb.MongoClientURI;
// import com.mongodb.ServerAddress;

import com.mongodb.client.MongoDatabase;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.FindIterable;

import org.bson.Document;
import org.bson.conversions.Bson; 
import java.lang.Iterable; 
import java.util.Arrays;
import com.mongodb.Block;

import com.mongodb.client.MongoCursor;
import static com.mongodb.client.model.Filters.*;
import com.mongodb.client.result.DeleteResult;
import static com.mongodb.client.model.Updates.*;
import com.mongodb.client.result.UpdateResult;
import java.util.ArrayList;
import java.util.List;

public class TestCollection {
    private MongoClient mongoClient; 
    private MongoDatabase database;
    private MongoCollection<Document> collection; 
    public TestCollection(final String host, final int port, final String databaseName, final String name) {
        MongoClient mongoClient = new MongoClient( host, port ); 
        MongoDatabase database = mongoClient.getDatabase( databaseName ); 
        collection = database.getCollection( name );
    }
    public TestCollection() { 
        this( "localhost", 27017, "testdb", "birthday" ); 
    }
    public Iterable<Document> find() {
        FindIterable<Document> findIterable = collection.find(); 
        return findIterable;
    }
    public Iterable<Document> find(Bson filter) {
        FindIterable<Document> findIterable = collection.find(filter); 
        return findIterable;
    }
    public static void main(String args[]) {
        TestCollection tc = new TestCollection(); 
        Iterable<Document> iterable = tc.find(); 
        for( Document document : iterable ) {
            System.out.println( document ); 
        }
    }
}